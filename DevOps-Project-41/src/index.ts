import "dotenv/config";
import path from "path";
import express, { Request, Response } from "express";

const app = express();
const PORT = Number(process.env.PORT) || 5000;
const startedAt = Date.now();

app.use(express.json());

// Serves public/index.html at "/" automatically (express.static defaults
// to looking for an index.html when a directory/root is requested), plus
// any other static assets you drop into public/ later.
app.use(express.static(path.join(__dirname, ".", "public")));

// Used by remote-deploy.sh to verify the new build actually came up
// before pm2 commits to it. Keep this cheap and dependency-free.
app.get("/health", (_req: Request, res: Response) => {
  res.status(200).json({
    status: "ok",
    uptimeSeconds: Math.round((Date.now() - startedAt) / 1000),
    env: process.env.NODE_ENV ?? "development",
  });
});

app.listen(PORT, () => {
  console.log(`Server listening on port ${PORT}`);
});