#!/usr/bin/env bash
# scripts/remote-deploy.sh
#
# Runs ON the EC2 instance. Called by .github/workflows/deploy.yml over SSH,
# but you can also run it by hand for a manual redeploy:
#
#   bash scripts/remote-deploy.sh <app_dir> <app_name> <branch> <health_port>
#
# Why this lives in a script instead of inline YAML:
#   - You can test the exact deploy logic locally over SSH before trusting CI with it.
#   - Diffs/reviews are readable in a PR, instead of buried in workflow YAML.
#   - One script works for both CI and manual "oops, redeploy now" situations.
#
# Why .env is never touched here:
#   .env should be created once on the server and listed in .gitignore.
#   Because it's untracked, `git clean` and `git reset --hard` below never
#   touch it — there's no assume-unchanged trick to maintain. If .env ever
#   ends up tracked by git on your server, untrack it first:
#     git rm --cached .env

set -euo pipefail

APP_DIR="${1:?Usage: remote-deploy.sh <app_dir> <app_name> <branch> <health_port>}"
APP_NAME="${2:?Usage: remote-deploy.sh <app_dir> <app_name> <branch> <health_port>}"
BRANCH="${3:-main}"
HEALTH_PORT="${4:-5000}"

cd "$APP_DIR"

echo "==> Loading nvm + pinning Node LTS"
export NVM_DIR="$HOME/.nvm"
# shellcheck disable=SC1091
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
nvm use --lts >/dev/null

PREV_COMMIT="$(git rev-parse HEAD)"
echo "==> Current commit before deploy: ${PREV_COMMIT}"

echo "==> Cleaning untracked build artifacts (never touches .env, .env is gitignored)"
git clean -fd

echo "==> Fetching and hard-resetting to origin/${BRANCH}"
git fetch origin "$BRANCH"
git reset --hard "origin/${BRANCH}"

echo "==> Installing dependencies (npm ci for reproducible installs)"
npm ci

echo "==> Building TypeScript"
npm run build

echo "==> Reloading via pm2 (starts fresh if this is the first deploy)"
if pm2 describe "$APP_NAME" > /dev/null 2>&1; then
  pm2 reload "$APP_NAME" --update-env
else
  pm2 start ecosystem.config.js --env production
fi
pm2 save

echo "==> Health check"
sleep 3
HEALTH_URL="http://localhost:${HEALTH_PORT}/health"

if curl -fsS "$HEALTH_URL" > /dev/null; then
  echo "✅ Deploy succeeded — ${APP_NAME} is healthy on commit $(git rev-parse --short HEAD)"
  exit 0
fi

echo "❌ Health check failed — rolling back to ${PREV_COMMIT}"
git reset --hard "$PREV_COMMIT"
npm ci
npm run build
pm2 reload "$APP_NAME" --update-env
pm2 save

echo "==> Rollback complete, but the deploy itself FAILED. Investigate before pushing again."
exit 1
