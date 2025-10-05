# Mini Helpdesk (Serverless) – CI/CD with GitHub Actions + AWS + Terraform
![Terraform Apply](https://github.com/HashirMalik-Cloud/C-CD-pipeline-for-mini-helpdesk/actions/workflows/terraform-apply.yml/badge.svg)
![CI](https://github.com/HashirMalik-Cloud/C-CD-pipeline-for-mini-helpdesk/actions/workflows/ci.yml/badge.svg)
![Terraform Plan](https://github.com/HashirMalik-Cloud/C-CD-pipeline-for-mini-helpdesk/actions/workflows/tf-plan.yml/badge.svg)
![Frontend Deploy](https://github.com/HashirMalik-Cloud/C-CD-pipeline-for-mini-helpdesk/actions/workflows/frontend-deploy.yml/badge.svg)

# 🧾 Mini Helpdesk — Serverless Support Ticketing System

![Architecture Diagram](Architecture%20diagram.png)
![Frontend UI](Frontend%20Picture.PNG)

🎥 **[Watch Demo on YouTube](https://youtu.be/lZ4lR4x31Y4?si=h38aZslTHoYQ_-CT)**  

---

## 💡 What’s This Project About?

**Mini Helpdesk** is a small yet production-ready **support ticketing system** — built fully on **AWS**, following modern **DevOps, CI/CD, and Infrastructure as Code** practices.  

Think of it as a simplified version of platforms like **Freshdesk or Zendesk**, where users can create support tickets, attach files, and get automatic email notifications — all powered by a scalable, serverless backend.  

This project was designed to **feel real**, showing how a cloud-native app runs in production with automation, security, and observability baked in.

---

## 🧠 What You’ll Learn from This Project
This project demonstrates how to build and automate a **real-world AWS serverless architecture**, including:

✅ Fully automated **CI/CD pipelines** with GitHub Actions  
✅ Secure, versioned **Infrastructure as Code (Terraform)**  
✅ **Zero-downtime** deployments  
✅ **Observability** with CloudWatch and X-Ray  
✅ Scalable, event-driven design (SQS + SNS + Lambda)  

---

## ⚙️ CI/CD — Automated from Code to Cloud

- **GitHub Actions** handles planning, applying, and deploying automatically.  
- Uses **OIDC authentication** for secure AWS access (no stored secrets).  
- Has separate workflows for:
  - Terraform Plan  
  - Terraform Apply  
  - Frontend Build & Deploy  

You just push your code — everything else happens automatically. 🚀

---

## 🏗️ Infrastructure as Code (IaC)

Everything is defined in **Terraform** — including IAM roles, queues, buckets, Lambdas, and API Gateway.  
That means you can spin up or destroy the entire system with just a few commands.

This ensures:
- Consistency across environments  
- Easy replication for dev/stage/prod setups  
- Secure and predictable deployments  

---

## ☁️ AWS Architecture — Fully Serverless

| Service | Purpose |
|----------|----------|
| **API Gateway + Lambda (Node.js 20)** | REST API for tickets |
| **DynamoDB** | Ticket storage (fast, scalable, low-cost) |
| **S3 + CloudFront** | Frontend hosting and file uploads |
| **SQS + Worker Lambda** | Asynchronous background processing |
| **SNS** | Sends email notifications on new tickets |
| **SSM Parameter Store** | Stores environment configs |
| **CloudWatch + X-Ray** | Logging, tracing, and monitoring |
| **IAM (OIDC Roles)** | Secure, least-privilege access |

---

## 💻 Frontend — Modern, Fast, and Simple

Built using **React + Vite**, hosted on **S3 + CloudFront** for global performance.

Users can:
- 📝 Create new support tickets  
- 📎 Upload attachments (via pre-signed S3 URLs)  
- 🔄 Track and update ticket statuses (Open → In Progress → Resolved)

---

## 🔙 Backend — Simple but Powerful

- **POST /tickets** — Create new tickets, validate inputs, upload attachments, and send to SQS.  
- **GET /tickets** — Fetch all tickets (with optional filters).  
- **PATCH /tickets/{id}** — Update ticket status or notes.  

The backend is **stateless and event-driven**, ensuring reliability and scalability.

---

## 🧵 Worker Lambda — Background Processing

- Triggered automatically by **SQS**  
- Reads messages and publishes them to **SNS**  
- SNS then sends an **email notification** to the support team  

All background tasks run asynchronously — keeping the API fast and responsive.

---

## 🔐 Security by Design

- **API Gateway Key + Usage Plan** — Controls access and prevents abuse  
- **IAM Roles (OIDC)** — Enforces least privilege  
- **Terraform-managed IAM** — No manual keys  
- Optional upgrade to **Cognito/JWT** for user-level authentication  

---

## 🧑‍💼 In Plain Words

Mini Helpdesk lets users submit support tickets, upload attachments, and stay updated via email — just like a real customer support system.  
Admins can review, manage, and resolve those tickets.  

It’s the perfect small-scale **SaaS-style project** to demonstrate your **DevOps, Cloud, and Infrastructure-as-Code skills**.

---

## 🚀 Quick Tech Summary

| Layer | Tool | Purpose |
|--------|------|----------|
| CI/CD | **GitHub Actions** | Automate Terraform + Frontend deployments |
| IaC | **Terraform** | Manage infrastructure as code |
| Backend | **AWS Lambda + API Gateway** | Serverless APIs |
| Database | **DynamoDB** | Ticket storage |
| Storage | **S3** | File uploads + Frontend hosting |
| Async | **SQS + SNS** | Background notifications |
| Monitoring | **CloudWatch + X-Ray** | Logs & tracing |
| Auth | **IAM + API Keys** | Secure access |
| Frontend | **React + Vite** | Fast web UI |

---

⭐ **If you like this project, consider giving it a star on GitHub!**  
It’s a great example of how to blend **AWS Cloud, Terraform, and CI/CD** into one complete system.

---
