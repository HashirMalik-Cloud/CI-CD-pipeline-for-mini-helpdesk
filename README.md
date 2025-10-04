# Mini Helpdesk (Serverless) – CI/CD with GitHub Actions + AWS + Terraform
![Terraform Apply](https://github.com/HashirMalik-Cloud/C-CD-pipeline-for-mini-helpdesk/actions/workflows/terraform-apply.yml/badge.svg)
![CI](https://github.com/HashirMalik-Cloud/C-CD-pipeline-for-mini-helpdesk/actions/workflows/ci.yml/badge.svg)
![Terraform Plan](https://github.com/HashirMalik-Cloud/C-CD-pipeline-for-mini-helpdesk/actions/workflows/tf-plan.yml/badge.svg)
![Frontend Deploy](https://github.com/HashirMalik-Cloud/C-CD-pipeline-for-mini-helpdesk/actions/workflows/frontend-deploy.yml/badge.svg)

🧾 Mini Helpdesk — Serverless Support Ticketing System
💡 Overview

Mini Helpdesk is a small but production-ready support ticketing app — built entirely on AWS using modern CI/CD and IaC practices.
It’s designed to mimic a real business use case (like a simplified Freshdesk or Zendesk) where users can submit support tickets, attach files, and receive email alerts — all powered by a fully automated, scalable backend.

This project demonstrates:

Real-world AWS serverless architecture

Full CI/CD automation with GitHub Actions

Secure Infrastructure as Code (IaC) via Terraform

Zero-downtime deploys, monitoring, and observability

🧰 Tech Stack & Architecture
⚙️ CI/CD

GitHub Actions — Automates plan/apply/test pipelines.

Uses OIDC for AWS authentication (no long-lived secrets).

Separate workflows for Terraform plan, apply, and frontend deploy.

🏗️ Infrastructure as Code

Terraform — All infrastructure is defined as code for easy reproducibility and multi-environment setup.

☁️ AWS (Serverless, Low Cost, Production Ready)

API Gateway + Lambda (Node.js 20): RESTful API, scalable and event-driven.

DynamoDB: Stores ticket data with auto-scaling and minimal idle cost.

S3 (2 buckets): One for attachments, one for hosting the React SPA — fronted by CloudFront for global delivery.

SQS + Worker Lambda: Handles background notifications asynchronously.

SNS: Sends email notifications to the support inbox when new tickets are created.

SSM Parameter Store: Securely stores configuration and API keys.

CloudWatch Logs + Alarms + X-Ray: Provides deep observability and error tracking.

IAM (OIDC roles per environment): Enforces least-privilege access and secure workflows.

💻 Frontend

React + Vite SPA (hosted on S3 + CloudFront)

Users can:

Create a new ticket (title, description, priority)

Upload attachments (via pre-signed S3 URLs)

View and update ticket status (Open → In Progress → Resolved)

🔙 Backend

Lambda (via API Gateway) exposes routes:

POST /tickets — Validates and stores tickets, issues upload URLs, and sends messages to SQS.

GET /tickets — Retrieves all tickets (with filters).

PATCH /tickets/{id} — Updates ticket status or notes.

🧵 Worker

Lambda (SQS Consumer):
Reads messages from SQS and publishes to SNS — which triggers an email notification to the configured support address.

🔐 Security

API Gateway Key + Usage Plan for controlled access and rate limiting.

Optionally upgradable to Cognito/JWT auth for user-based access.

🧑‍💼 In Plain Words

This app lets a user create support tickets, attach screenshots, and track their progress.
Admins can update ticket statuses, and automatic email alerts keep the support team informed.
It’s a realistic, small-scale SaaS-style app — perfect to showcase your DevOps, Cloud, and IaC skills.

🚀 Tech Summary
Layer	Tool	Purpose
CI/CD	GitHub Actions	Automate Terraform & Frontend deploys
IaC	Terraform	Code-based infra management
Backend	AWS Lambda + API Gateway	Serverless APIs
Database	DynamoDB	Ticket storage
Storage	S3	File uploads & hosting frontend
Async	SQS + SNS	Background notifications
Observability	CloudWatch + X-Ray	Monitoring & tracing
Auth	IAM + API Keys	Secure access
Frontend	React + Vite	Modern, fast web UI
