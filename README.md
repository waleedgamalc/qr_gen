<p align="center">
  <img src="https://circleci.com/topics/devops/" alt="Banner" width="100%">
</p>

# QR Generator - DevOps Project

A simple Flask web application that generates QR codes from user input.

This project was created to practice modern DevOps concepts by building a complete CI/CD pipeline and deploying the application on AWS using Infrastructure as Code.

---

## Features

- Generate QR codes from text or URLs
- Simple Flask web interface
- Dockerized application
- Multi-stage Docker build
- Automated CI/CD with GitHub Actions
- Infrastructure provisioned with Terraform
- Automatically deployed to an AWS EC2 instance

---

## Technologies Used

- Python
- Flask
- Docker
- GitHub Actions
- Terraform
- AWS EC2
- Docker Hub

---

## Project Structure

```
.
├── app.py
├── templates/
├── static/
├── Dockerfile
├── requirements.txt
├── terraform/
├── .github/
│   └── workflows/
└── README.md
```

---

## CI/CD Workflow

Whenever code is pushed to the main branch:

1. GitHub Actions starts the pipeline.
2. The Flask application is built.
3. A Docker image is created using a multi-stage Dockerfile.
4. The image is pushed to Docker Hub.
5. Terraform provisions the required AWS infrastructure (if needed).
6. The EC2 instance pulls the latest Docker image.
7. The application is restarted automatically.

---

## Deployment

The application is deployed on an AWS EC2 instance.

Infrastructure is managed using Terraform (HCL), making it easy to recreate the environment whenever needed.

---

## Running Locally

Clone the repository:

```bash
git clone https://github.com/waleedgamalc/qr_gen.git
cd qr_gen
```

Install dependencies:

```bash
pip install -r requirements.txt
```

Run the application:

```bash
python app.py
```

The application will be available at:

```
http://localhost:5000
```

---

## Running with Docker

Build the image:

```bash
docker build -t qr-generator .
```

Run the container:

```bash
docker run -p 5000:5000 qr-generator
```

---

## What I Learned

Through this project I gained hands-on experience with:

- Docker containerization
- Multi-stage Docker builds
- GitHub Actions CI/CD pipelines
- Infrastructure as Code using Terraform
- AWS EC2 deployment
- Automated application delivery
- Docker Hub image management

---

## Author

**Waleed Gamal**

Computer Science Graduate | Cloud & DevOps Enthusiast
