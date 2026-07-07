# NODEJS TYPESCRIPT DEPLOYMENT ON EC2 WITH AUTO REDEPLOY (CI/CD), NGINX, SSL

Deploy a TypeScript/Node app to an AWS EC2 Ubuntu instance, behind Nginx, with free
auto-renewing SSL, kept alive by PM2, and auto-redeployed on every push to `main`
via GitHub Actions.

This started as a riff on the classic "Node + Nginx + Certbot" tutorials you'll find
all over GitHub, rebuilt as something detailed enough to follow with zero prior
deployment experience: every command is spelled out and explained, the app is
TypeScript instead of plain JS (with its own build step walked through in detail),
and the CI/CD step does a real build + health-check + automatic rollback instead of
a bare `pm2 restart`.

## What you get

- `scripts/setup-server.sh` — optional shortcut that automates everything in steps 3, 6, 8, and 10 below in one go. Worth reading the manual walkthrough at least once first so you know what it's actually doing.
- `scripts/configure-nginx.sh` — per-domain Nginx reverse proxy config (supports multiple apps on one box)
- `scripts/remote-deploy.sh` — the actual deploy logic: pull, build, reload, health-check, **rollback on failure**
- `.github/workflows/deploy.yml` — pushes to `main` trigger a deploy automatically
- `src/index.ts`, `ecosystem.config.js` — a minimal TypeScript/Express app + PM2 config to deploy as a starting point

## 1. Launch the EC2 instance

- Ubuntu 22.04 or 24.04 LTS, any size that fits your workload (`t3.micro` is enough to start)
- Attach an **Elastic IP** so the address doesn't change on reboot
- Security group: allow inbound `22` (SSH), `80` (HTTP), `443` (HTTPS)

## 2. SSH into the server

```sh
ssh -i <key.pem> ubuntu@<elastic-ip>
```

If this is a brand-new key pair, you may need `chmod 400 <key.pem>` first, or SSH
will refuse to use it because the permissions are too open.

## 3. Update the system and install Node.js via nvm

Update package lists and installed packages:

```sh
sudo apt update
sudo apt upgrade -y
```

Install a few basics every server should have:

```sh
sudo apt install -y git htop wget curl
```

Node itself is best installed through **nvm** (Node Version Manager) rather than
`apt`. `apt`'s Node packages lag behind, and nvm lets you switch Node versions per
project without permission issues on global installs.

### 3.1 Install nvm

```sh
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
```

This downloads and runs the official nvm install script, which clones nvm into
`~/.nvm` and adds a few lines to your shell profile (`~/.bashrc` by default) so it
loads automatically in future sessions. Reload your current shell so it takes
effect right now too:

```sh
source ~/.bashrc
```

### 3.2 Confirm nvm is installed

```sh
nvm --version
```

If you get a version number back, you're good. If you get `command not found`,
re-run the `source ~/.bashrc` line above.

### 3.3 Install the current Node LTS release

```sh
nvm install --lts
```

### 3.4 Confirm Node and npm are available

```sh
node --version
npm --version
```

You're now ready to bring your actual app onto the server.

## 4. Clone your repository

```sh
cd /home/ubuntu
git clone https://github.com/<you>/<your-repo>.git
cd <your-repo>
```

## 5. Install, build, and verify the app runs — the TypeScript-specific part

This is the step that's genuinely different from a plain JavaScript app, so it's
worth slowing down here.

A plain `.js` file is already something Node can execute directly — that's why a
JS tutorial can just say `node app.js` and be done. A `.ts` file is **not**
something Node understands natively. You write your code in `src/*.ts`, and before
Node can run any of it, TypeScript has to **compile** it down to plain JavaScript
in a `dist/` folder. That compile step is what `npm run build` does, and it has to
run after every code change — the GitHub Actions workflow in step 11 automates
this for every future deploy, but for now you're doing it by hand once to confirm
everything works.

### 5.1 Install dependencies

```sh
npm install
```

This pulls in everything listed in `package.json`, including `typescript` itself
— it's a `devDependency`, so it gets installed automatically and you do **not**
need to install TypeScript globally on the server for this to work.

(If you ever want the `tsc` command available on its own for poking around
manually, you can run `npm install -g typescript` — but it isn't required for
anything in this guide.)

### 5.2 Build the project

```sh
npm run build
```

Under the hood this just runs `tsc`, which reads `tsconfig.json`, compiles
everything under `src/` into plain JavaScript, and writes the output to `dist/`.
Once it finishes, check that the compiled file is actually there:

```sh
ls dist
```

You should see `index.js` (plus a couple of `.map` files used for debugging
stack traces back to the original TypeScript — safe to ignore them).

### 5.3 Run it once by hand to confirm it actually works

```sh
node dist/index.js
```

You should see something like:

```
Server listening on port 5000
```

Leave that running and, in a second terminal (or a second SSH session), confirm
it's actually responding:

```sh
curl http://localhost:5000/health
```

Expected response:

```json
{"status":"ok","uptimeSeconds":1,"env":"development"}
```

Once you've confirmed that, go back to the first terminal and stop it with
`Ctrl+C`. You don't want to leave it running in the foreground forever — that's
exactly what pm2 is for next.

## 6. Install pm2

```sh
npm install -g pm2
```

pm2 keeps your app running in the background, restarts it automatically if it
crashes, and (after one more step below) brings it back up automatically if the
whole server reboots.

## 7. Start the app with pm2

You could start it the simple way, pointing pm2 straight at the compiled file —
this is the direct equivalent of `pm2 start app.js` from a plain-JS setup:

```sh
pm2 start dist/index.js --name my-app
```

This project also ships an `ecosystem.config.js`, which is the better option once
you have more than one or two environment variables to manage — it keeps
`NODE_ENV`, `PORT`, and the app name defined in one file instead of scattered
across terminal commands:

```sh
APP_NAME=my-app pm2 start ecosystem.config.js --env production
```

Either approach works the same way under the hood; the rest of this guide (and
`scripts/remote-deploy.sh`, used by CI/CD later) assumes you're using
`ecosystem.config.js`.

### 7.1 Save the process list

```sh
pm2 save
```

Without this, pm2 forgets which apps it was running the next time the server
reboots.

### 7.2 Make pm2 itself start on boot

```sh
pm2 startup
```

This prints a command tailored to your OS and user — copy that exact output and
run it. Then confirm everything's running:

```sh
pm2 status
```

You should see your app listed with status `online`.

## 8. Install and configure Nginx

Install Nginx:

```sh
sudo apt install -y nginx
```

Instead of hand-editing `/etc/nginx/sites-available/default` (which works fine
until you want a second app on the same box, and then breaks), this project's
`configure-nginx.sh` script writes a dedicated config file per domain:

```sh
chmod +x scripts/configure-nginx.sh
./scripts/configure-nginx.sh app.yourdomain.com 5000
```

Replace `app.yourdomain.com` with your actual domain and `5000` with whatever port
your app listens on (matches `PORT` in `.env` / `ecosystem.config.js`).

Visit `http://<elastic-ip>` — you should see your app on port 80, no port number
needed in the URL.

## 9. Point your domain at the server

Add an `A` record for your domain/subdomain pointing at the EC2 Elastic IP, in
whichever registrar or DNS provider you use (GoDaddy, Route 53, Cloudflare, etc.).
Give it a few minutes to propagate before moving on.

## 10. Get free SSL

Install certbot via snap (the apt version tends to be outdated):

```sh
sudo apt remove -y certbot
sudo snap install core
sudo snap refresh core
sudo snap install --classic certbot
sudo ln -s /snap/bin/certbot /usr/bin/certbot
```

Then request the certificate:

```sh
sudo certbot --nginx -d app.yourdomain.com
```

Certbot finds the Nginx config block for that domain, gets you a Let's Encrypt
cert, and sets up auto-renewal via a systemd timer. Confirm the timer is active:

```sh
sudo systemctl status snap.certbot.renew.service
sudo certbot renew --dry-run
```

Visit `https://app.yourdomain.com` — you're live with SSL.

## 11. Set up auto-deploy on every push

This is the part most versions of this tutorial skip entirely. Once it's wired up,
`git push origin main` is your entire deploy process.

### Generate a deploy key (don't reuse your personal SSH key)

On your own machine:

```sh
ssh-keygen -t ed25519 -f deploy_key -N ""
```

Add `deploy_key.pub` to `~/.ssh/authorized_keys` on the EC2 instance. Keep
`deploy_key` (the private half) for the next step.

### Add GitHub repo secrets and variables

In your repo: **Settings → Secrets and variables → Actions**.

**Secrets** (sensitive — never shown in logs):

| Name            | Value                                  |
| --------------- | --------------------------------------- |
| `HOST_DNS`      | Your Elastic IP or domain               |
| `SSH_USERNAME`  | `ubuntu`                                |
| `EC2_SSH_KEY`   | Contents of the private `deploy_key`    |

**Variables** (not secret — just config):

| Name           | Value                                    |
| -------------- | ----------------------------------------- |
| `APP_DIR`      | `/home/ubuntu/<your-repo>`                |
| `APP_NAME`     | `my-app` (must match the pm2 process name)|
| `HEALTH_PORT`  | `5000` (whatever port your app listens on)|

### The workflow

`.github/workflows/deploy.yml` triggers on every push to `main` (plus a manual
**Run workflow** button via `workflow_dispatch`), SSHes in, and runs
`scripts/remote-deploy.sh` on the server:

```yaml
name: Deploy to EC2

on:
  push:
    branches: [main]
  workflow_dispatch: {}

concurrency:
  group: production-deploy
  cancel-in-progress: false

jobs:
  deploy:
    name: Deploy to EC2
    runs-on: ubuntu-latest
    steps:
      - name: SSH in and run remote-deploy.sh
        uses: appleboy/ssh-action@v1.2.0
        with:
          host: ${{ secrets.HOST_DNS }}
          username: ${{ secrets.SSH_USERNAME }}
          key: ${{ secrets.EC2_SSH_KEY }}
          script: |
            bash ${{ vars.APP_DIR }}/scripts/remote-deploy.sh \
              "${{ vars.APP_DIR }}" \
              "${{ vars.APP_NAME }}" \
              "main" \
              "${{ vars.HEALTH_PORT }}"
```

What's different from a typical inline-bash deploy step:

- **The deploy logic lives in `scripts/remote-deploy.sh`, not the YAML.** You can
  run the exact same script by hand over SSH to test it, and reviewers can read a
  diff to it like normal code instead of squinting at indented YAML strings.
- **The SSH action is pinned to a version tag (`@v1.2.0`), not `@master`.** A
  floating tag on an action that holds your production SSH key is a supply-chain
  risk — pin it, and bump the version deliberately when you choose to.
- **`concurrency` serializes deploys.** If you push twice in quick succession, the
  second run waits for the first instead of two deploys racing on the same server.
- **There's a real health check with rollback.** `remote-deploy.sh` curls
  `/health` after restarting; if it doesn't respond, it resets the server back to
  the previous commit, rebuilds, and reloads pm2 — so a broken build doesn't stay
  live just because `pm2 restart` technically succeeded.
- **`npm ci` instead of `npm install`**, and a hard `git reset --hard` instead of
  `git pull`, so the server always matches `origin/main` exactly with no chance of
  a stray local commit or merge conflict on the box itself.

### Why `.env` is never at risk here

A common failure mode with this kind of setup: `.env` gets tracked by git at some
point, and a later `git pull` / `git reset --hard` either wipes it or refuses to
proceed because of a conflict. The fix used here is structural rather than a git
trick: `.env` is listed in `.gitignore` from the start and created **once**,
directly on the server, outside of any git operation. Since it's untracked,
`git clean -fd` and `git reset --hard` in `remote-deploy.sh` never touch it —
there's nothing to protect because git doesn't know the file exists.

(If you've seen the `git update-index --assume-unchanged .env` pattern elsewhere —
that's a workaround for when `.env` *is* tracked. It stops `git status`/`diff`
from flagging local edits, but `git reset --hard` will still happily overwrite a
tracked file to match the commit. Keeping `.env` out of git entirely avoids the
whole problem.)

## 12. Redeploying

```sh
git push origin main
```

That's it — watch the run in your repo's **Actions** tab, or trigger one manually
with **Run workflow**.

## Common pitfalls this setup avoids

- **Stale `dist/` builds.** `remote-deploy.sh` always runs `npm run build` after
  pulling, so PM2 is never pointed at compiled output that's older than the source
  that's checked out.
- **CORS breaking silently behind Nginx.** If your API and frontend live on
  different subdomains, make sure your Express CORS config's allowed origin
  matches the *public* HTTPS domain, not `localhost` or the bare EC2 IP — it's an
  easy thing to leave pointed at a dev value after the first deploy.
- **One Nginx file, many apps, total chaos.** Editing `sites-available/default`
  directly works until you have a second app. Giving each domain its own file via
  `configure-nginx.sh` avoids that entirely.

## Scaling further

- **Repeating this on a second server or a second app?** `scripts/setup-server.sh`
  automates steps 3, 6, 8, and 10 above in one idempotent script — handy once
  you've done the manual version enough times to trust it.
- **Multiple apps on one box:** rerun steps 4–11 with a different `APP_DIR`,
  `APP_NAME`, `HEALTH_PORT`, and domain.
- **Extra hardening worth adding as traffic grows:** `ufw` (firewall) and
  `fail2ban` (SSH brute-force protection) — both included automatically if you use
  `setup-server.sh`. Also consider switching `ecosystem.config.js` to
  `exec_mode: "cluster"` with multiple instances once a single process is no
  longer enough.

## License

MIT — see [LICENSE](./LICENSE).