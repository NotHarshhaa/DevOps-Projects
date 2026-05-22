#!/usr/bin/env bash
set -euo pipefail

API_URL="${API_URL:-http://localhost:8080}"
MAX_WAIT=30
PASS=0
FAIL=0

green() { printf "\e[32m[PASS]\e[0m %s\n" "$*"; }
red()   { printf "\e[31m[FAIL]\e[0m %s\n" "$*"; }
info()  { printf "\e[34m[INFO]\e[0m %s\n" "$*"; }

assert_eq() {
  local label="$1" expected="$2" actual="$3"
  if [[ "$actual" == "$expected" ]]; then
    green "$label"
    ((PASS++))
  else
    red "$label — expected '$expected', got '$actual'"
    ((FAIL++))
  fi
}

assert_contains() {
  local label="$1" needle="$2" haystack="$3"
  if echo "$haystack" | grep -q "$needle"; then
    green "$label"
    ((PASS++))
  else
    red "$label — expected to contain '$needle'"
    ((FAIL++))
  fi
}

info "Smoke test against: $API_URL"
echo ""

# ── /health ────────────────────────────────────────────────────────────────────
info "Testing /health"
health_status=$(curl -s -o /dev/null -w "%{http_code}" "$API_URL/health")
assert_eq "GET /health returns 200" "200" "$health_status"

# ── /ready ─────────────────────────────────────────────────────────────────────
info "Testing /ready"
ready_status=$(curl -s -o /dev/null -w "%{http_code}" "$API_URL/ready")
if [[ "$ready_status" == "200" || "$ready_status" == "503" ]]; then
  green "GET /ready returns 200 or 503 (degraded acceptable)"
  ((PASS++))
else
  red "GET /ready returned unexpected status: $ready_status"
  ((FAIL++))
fi

# ── POST /ask ──────────────────────────────────────────────────────────────────
info "Testing POST /ask"
ask_response=$(curl -s -X POST "$API_URL/ask" \
  -H "Content-Type: application/json" \
  -d '{"prompt":"Explain GitOps in simple terms","model":"mock-devops-model"}')

ask_status=$(curl -s -o /dev/null -w "%{http_code}" -X POST "$API_URL/ask" \
  -H "Content-Type: application/json" \
  -d '{"prompt":"second job","model":"mock-devops-model"}')

assert_contains "POST /ask returns jobId" "jobId" "$ask_response"
assert_contains "POST /ask returns status=queued" "queued" "$ask_response"

JOB_ID=$(echo "$ask_response" | grep -o '"jobId":"[^"]*"' | cut -d'"' -f4)
info "Job created: $JOB_ID"

# ── GET /jobs/{jobId} — poll until completed ───────────────────────────────────
info "Polling /jobs/$JOB_ID (max ${MAX_WAIT}s)"
elapsed=0
job_status="queued"
while [[ "$job_status" != "completed" && "$job_status" != "failed" && $elapsed -lt $MAX_WAIT ]]; do
  sleep 2
  elapsed=$((elapsed + 2))
  job_response=$(curl -s "$API_URL/jobs/$JOB_ID")
  job_status=$(echo "$job_response" | grep -o '"status":"[^"]*"' | cut -d'"' -f4)
  info "  status=$job_status (${elapsed}s elapsed)"
done

assert_eq "Job completes with status=completed" "completed" "$job_status"
assert_contains "Completed job has a result" "result" "$job_response"

# ── GET /jobs/{unknown} ────────────────────────────────────────────────────────
info "Testing 404 for unknown job"
not_found_status=$(curl -s -o /dev/null -w "%{http_code}" "$API_URL/jobs/nonexistent-job-id")
assert_eq "GET /jobs/nonexistent returns 404" "404" "$not_found_status"

# ── POST /ask with empty prompt ────────────────────────────────────────────────
info "Testing validation"
bad_req_status=$(curl -s -o /dev/null -w "%{http_code}" -X POST "$API_URL/ask" \
  -H "Content-Type: application/json" \
  -d '{"prompt":"","model":"mock-devops-model"}')
assert_eq "POST /ask with empty prompt returns 400" "400" "$bad_req_status"

# ── Summary ────────────────────────────────────────────────────────────────────
echo ""
echo "────────────────────────────────────────"
info "Results: PASS=$PASS  FAIL=$FAIL"
echo "────────────────────────────────────────"

if [[ $FAIL -gt 0 ]]; then
  red "Smoke test FAILED"
  exit 1
else
  green "All smoke tests PASSED"
  exit 0
fi
