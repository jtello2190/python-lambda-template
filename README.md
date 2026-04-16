# 🚀 Python Lambda Microservice Template

A minimal, production-ready template to build and deploy Python microservices on AWS Lambda using container images.

---

## 🧭 What This Is

This repository defines a standardized unit of execution and deployment for Python-based microservices.

It provides:

- a consistent Lambda entrypoint `(run(event, context))`
- a Docker-based runtime aligned with AWS Lambda
- a reproducible build process
- a deployment pipeline using CodeBuild + ECR

The goal is simple:

*Define the structure once. Reuse it across services.*

---

## 📚 Related Articles

This repository is part of a 3-part series:

- [Part 1 — Build a Reusable Python Lambda Microservice with Docker, Makefile, and ECR](https://medium.com/@fisk2190/8d6fb2e6baa9?source=friends_link&sk=d01b4ea564e5883ce7bff8d970695589)

- [Part 2 — Automate Lambda Deployments with CodeBuild and ECR, and Container Images](https://medium.com/@fisk2190/e25c519f0d2a?source=friends_link&sk=dddfbcdc8dfbe52304091dd0d94f5d44)

- [Part 3 — Build Real Services (coming next) — DynamoDB ingestion + SES email microservice](https://medium.com/@fisk2190/8d6fb2e6baa9?source=friends_link&sk=d01b4ea564e5883ce7bff8d970695589)

---

## ⚙️ How to Use

This template is designed to be cloned and adapted quickly.

### 1. Fork or clone the repository

```bash
# Fork via GitHub CLI
gh repo fork jtello2190/python-lambda-template --clone

# Or clone directly
git clone https://github.com/jtello2190/python-lambda-template.git
```

### 2. Implement your service logic

All application logic lives in `src/main.py`

Define your service through a single function:

```python
def run(event, context):
    return {
        "statusCode": 200,
        "body": "hello world"
    }
```

### 3. (Optional) Adapt the Lambda handler

The default handler is a thin adapter:

```python
from main import run

def handler(event, context):
    return run(event, context)
```

Modify this only if you need preprocessing, routing, or input normalization.

### 4. Build and test locally

```bash
make build
make run
```

This uses the AWS Lambda Python base image to replicate the runtime locally.

### 5. Create your ECR repository

Make sure the name matches the environment variables in CodeBuild. Consistency here is part of the deployment pattern.

### 6. Connect to CodeBuild

Create a CodeBuild project:

- source → this repository
- enable privileged mode (required for Docker)
- use `buildspec.yml` from the repo
- define environment variables:

```bash
ACCOUNT_ID
AWS_REGION
IMAGE_REPO_NAME
LAMBDA_FUNCTION_NAME
```

### 7. Deploy

Push a commit:

```bash
git commit -m "deploy"
git push
```

The pipeline will build the image, push it to ECR, update the Lambda function.

---

## 🧩 Project Structure

```
python-lambda-template/
├── src/
│   ├── __init__.py
│   ├── main.py
│   └── handler.py
├── events/
│   └── test_event.json
├── Dockerfile
├── Makefile
├── requirements.txt
├── .dockerignore
├── .gitignore
└── README.md
```

---

## 🧠 Design Principles

This template is built around two boundaries:

- **Execution boundary** `run(event, context)`: Defines how the service behaves.
- **Deployment boundary** `buildspec.yml`: Defines how the service is built and deployed.

Everything else is implementation detail.

---

## 🏗️ When to Use This

This pattern works best for:

- small, independent microservices
- event-driven systems
- async processing pipelines
- services triggered by SNS, SQS, or API Gateway

---

## ⚠️ Notes

- Match Lambda architecture (`x86_64` or `arm64`) with your Docker build
- Avoid relying on `latest` in production — prefer versioned tags
- Keep IAM permissions scoped to the specific repo and function

---

## 📌 Summary

- Clone/Fork
- Implement `run()`
- Build once
- Deploy through CodeBuild
- Reuse across services