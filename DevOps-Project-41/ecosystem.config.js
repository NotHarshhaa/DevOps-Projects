module.exports = {
  apps: [
    {
      name: process.env.APP_NAME || "ts-ec2-app",
      script: "dist/index.js",
      cwd: __dirname,
      instances: 1,
      exec_mode: "fork", // bump instances + switch to "cluster" once you need it
      autorestart: true,
      watch: false,
      max_memory_restart: "300M",
      env: {
        NODE_ENV: "development",
        PORT: 5000,
      },
      env_production: {
        NODE_ENV: "production",
        PORT: 5000,
      },
    },
  ],
};
