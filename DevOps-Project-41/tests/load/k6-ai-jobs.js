import http from "k6/http";
import { check, sleep } from "k6";
import { Counter, Rate, Trend } from "k6/metrics";

const jobsCreated = new Counter("ai_jobs_created");
const jobsCompleted = new Counter("ai_jobs_completed");
const jobsFailed = new Counter("ai_jobs_failed");
const successRate = new Rate("ai_success_rate");
const jobDuration = new Trend("ai_job_duration_ms", true);

export const options = {
  stages: [
    { duration: "30s", target: 5 },   // ramp up
    { duration: "1m", target: 10 },   // sustained load — enough to trigger KEDA
    { duration: "30s", target: 20 },  // spike
    { duration: "30s", target: 0 },   // ramp down
  ],
  thresholds: {
    http_req_failed: ["rate<0.05"],
    http_req_duration: ["p(95)<2000"],
    ai_success_rate: ["rate>0.90"],
  },
};

const BASE_URL = __ENV.API_URL || "http://localhost:8080";

const PROMPTS = [
  "Explain GitOps in simple terms",
  "What is Kubernetes?",
  "How does KEDA work?",
  "What is DevSecOps?",
  "Describe OpenTelemetry",
  "What is a container image?",
  "Explain CI/CD pipelines",
  "What is a service mesh?",
];

function randomPrompt() {
  return PROMPTS[Math.floor(Math.random() * PROMPTS.length)];
}

export default function () {
  const askPayload = JSON.stringify({
    prompt: randomPrompt(),
    model: "mock-devops-model",
  });

  const askRes = http.post(`${BASE_URL}/ask`, askPayload, {
    headers: { "Content-Type": "application/json" },
  });

  const askOk = check(askRes, {
    "POST /ask status 202": (r) => r.status === 202,
    "POST /ask has jobId": (r) => r.json("jobId") !== undefined,
  });

  if (!askOk) {
    jobsFailed.add(1);
    successRate.add(false);
    return;
  }

  jobsCreated.add(1);
  const jobId = askRes.json("jobId");
  const start = Date.now();

  // Poll for completion (max 10 attempts)
  let completed = false;
  for (let i = 0; i < 10; i++) {
    sleep(1);
    const jobRes = http.get(`${BASE_URL}/jobs/${jobId}`);
    const status = jobRes.json("status");

    if (status === "completed") {
      completed = true;
      jobsCompleted.add(1);
      jobDuration.add(Date.now() - start);
      successRate.add(true);

      check(jobRes, {
        "completed job has result": (r) => r.json("result") !== null,
      });
      break;
    }

    if (status === "failed") {
      jobsFailed.add(1);
      successRate.add(false);
      break;
    }
  }

  if (!completed) {
    successRate.add(false);
  }

  sleep(0.5);
}
