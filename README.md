# debian-php-fpm

For https://hub.docker.com/r/phzfi/debian-php-fpm

## 1. Project Description

Docker image for debian-php-fpm

### 1.1. Business Vision

Easy to use php-fpm

### 1.2. Task Management

### 1.3. Personas

### 1.4. Use Cases

This project enables php-fpm to be run on Debian docker for example with phzfi/wordpress, or any other service requiring php-fpm.

### 1.5. Non-Functional Requirements

Ease of Use: Instead of being the most lightweight container out there, this container aims to be developer friendly.

Security: Update security updates regularly

## 2. Architecture

### 2.1. Technologies

* PHP-FPM
* Docker
* Debian 
* Jenkins (declarative multibranch pipeline)
* sh2ju for testing

### 2.2. Naming, Terms and Key Concepts

### 2.3. Coding Convention

## 3. Development Environment

### 3.1. Prerequisites

### 3.2. Start the Application

### 3.3. Access the Application

### 3.4. Run Tests

### 3.5. IDE Setup and Debugging

### 3.6. Version Control

### 3.7. Databases and Migrations

### 3.8. Continuous Integration

## 4. Staging Environment

### 4.1. Access

### 4.2. Deployment

### 4.3. Smoke Tests

#### 4.3.1. Automated Test Cases

#### 4.3.2. Manual Test Cases

### 4.4. Rollback

### 4.5. Logs

### 4.6. Monitoring

## 5. Production Environment

### 5.1. Access

### 5.2. Deployment

Run
```
./docker/build.sh prod <version> <docker_hub_username> <docker_hub_password>
```

### 5.3. Smoke Tests

#### 5.3.1. Automated Test Cases

#### 5.3.2. Manual Test Cases

### 5.4. Rollback

### 5.5. Logs

### 5.6. Monitoring

## 6. Operating Manual

### 6.1 Scheduled Jobs

### 6.2 Manual Processes

## 7. Problems

