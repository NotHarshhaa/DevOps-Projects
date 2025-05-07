# DevOps Learning Platform with React, Flask, and PostgreSQL

This project demonstrates a 3-tier application architecture using React for the frontend, Flask for the backend, and PostgreSQL as the database.

## Project Overview

- **Frontend**: Built with [React](https://reactjs.org/), a JavaScript library for building user interfaces.
- **Backend**: Powered by [Flask](https://flask.palletsprojects.com/), a lightweight WSGI web application framework.
- **Database**: Uses [PostgreSQL](https://www.postgresql.org/), a powerful, open-source object-relational database system.

## Prerequisites

Ensure the following tools are installed on your system before proceeding:

- [Docker](https://www.docker.com/) and [Docker Compose](https://docs.docker.com/compose/)
- Basic understanding of containerized applications

---

## Getting Started

### 1. Build and Start the Containers

Run the following command to build and start the application containers:

```bash
docker-compose up --build
```

This will build the Docker images and start the containers for the frontend, backend, and database.

---

### 2. Initialize the Database (First-Time Setup Only)

In a new terminal, initialize the database by running the following commands:

```bash
docker-compose exec backend flask db upgrade
```

This applies the database migrations.

Next, seed the database with initial data:

```bash
docker-compose exec backend python seed_data.py
```

---

### 3. Stop the Application

To stop the application and remove the containers, run:

```bash
docker-compose down
```

---

### 4. Restart the Application

To restart the application, first stop it (if running) and then start it again:

```bash
docker-compose down
docker-compose up --build
```

---

## Additional Resources

- **AWS Route 53 Policy**: Refer to the `route53-policy.json` file for DNS configuration details.

---

Feel free to explore and modify the project to suit your learning needs. Happy coding!
