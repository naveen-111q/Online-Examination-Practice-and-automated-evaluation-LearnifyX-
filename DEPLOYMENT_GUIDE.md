# LearnifyX Deployment Guide

This guide describes how to deploy the **LearnifyX Examination System** in production. The system is built with a Node.js/Express backend that serves the compiled frontend static files from `client/dist` and connects to a MySQL database.

---

## Table of Contents
1. [Prerequisites](#prerequisites)
2. [Option A: Deploying with Docker Compose (VPS / Local)](#option-a-deploying-with-docker-compose-vps--local)
3. [Option B: Deploying to Railway (PaaS - Easiest Live Link)](#option-b-deploying-to-railway-paas---easiest-live-link)
4. [Option C: Deploying to Render.com (PaaS - Free Node.js Hosting)](#option-c-deploying-to-rendercom-paas---free-nodejs-hosting)
5. [Setting Up Cloud MySQL (TiDB Cloud)](#setting-up-cloud-mysql-tidb-cloud)

---

## Prerequisites
No matter which option you choose, make sure you have:
- A GitHub repository containing this codebase (e.g., your linked origin repository: `https://github.com/naveen-111q/Online-Examination-Practice-and-automated-evaluation-LearnifyX-`).
- Your environment variables ready (such as OpenRouter API key, JWT Secret, and Email credentials).

---

## Option A: Deploying with Docker Compose (VPS / Local)
If you are deploying to your own Virtual Private Server (VPS) or running the production environment locally:

1. **Install Docker & Docker Compose** on your host machine.
2. **Clone the repository** on your server:
   ```bash
   git clone https://github.com/naveen-111q/Online-Examination-Practice-and-automated-evaluation-LearnifyX-.git
   cd Online-Examination-Practice-and-automated-evaluation-LearnifyX-
   ```
3. **Verify/Adjust Environment Variables**:
   Open `docker-compose.yml` and adjust the database credentials and credentials for JWT, OpenRouter, and SMTP under the `app` service `environment` section.
4. **Start the containers**:
   ```bash
   docker compose up -d --build
   ```
5. **Verify the installation**:
   - The application automatically runs `init_db.js` and `seed_admin_table.js` to set up tables and create the default admin user.
   - Access the live app at `http://your-server-ip:5000` or `http://localhost:5000`.
   - Admin Login ID: `SRMAP2026` / Password: `naveen`.

---

## Option B: Deploying to Railway (PaaS - Easiest Live Link)
Railway is one of the easiest ways to host node applications with MySQL database and obtain a public live link instantly.

1. **Sign up / Log in** to [Railway.app](https://railway.app).
2. **Create a New Project**:
   - Click **New Project** -> **Deploy from GitHub repo**.
   - Select `Online-Examination-Practice-and-automated-evaluation-LearnifyX-`.
3. **Add MySQL Database**:
   - In your Railway dashboard, click **+ Add** -> **Database** -> **MySQL**.
4. **Link Database Environment Variables**:
   - Click on your **Express app service** in Railway.
   - Go to **Variables** -> **New Variable** -> Click **Reference variables** to automatically map:
     - `DB_HOST` = `${{MySQL.MYSQLHOST}}`
     - `DB_PORT` = `${{MySQL.MYSQLPORT}}`
     - `DB_USER` = `${{MySQL.MYSQLUSER}}`
     - `DB_PASSWORD` = `${{MySQL.MYSQLPASSWORD}}`
     - `DB_NAME` = `${{MySQL.MYSQLDATABASE}}`
5. **Add Remaining Env Variables**:
   - `JWT_SECRET` = (e.g., `super_secret_jwt_key_exam_system_2026`)
   - `OPENROUTER_API_KEY` = (Your OpenRouter API Key)
   - `EMAIL_USER` = `learnifyxteam@gmail.com`
   - `EMAIL_PASS` = `rxefdbwrpqgyxjpw`
   - `PORT` = `5000`
6. **Set Start Command**:
   - Under service settings, Railway will automatically detect Node.js.
   - In the **Start Command** field, specify:
     ```bash
     node init_db.js && node seed_admin_table.js && node index.js
     ```
7. **Generate Domain**:
   - Go to the app service **Settings** tab -> click **Generate Domain** under Networking. This will provide your public live link!

---

## Option C: Deploying to Render.com (PaaS - Free Node.js Hosting)
Render provides free Node.js hosting. Since Render no longer offers free persistent MySQL, you should pair it with a free cloud MySQL instance like **TiDB Cloud** (see details below).

1. **Sign up / Log in** to [Render.com](https://render.com).
2. **Create a Web Service**:
   - Click **New +** -> **Web Service**.
   - Connect your GitHub repository.
3. **Configure Settings**:
   - **Name**: `learnifyx`
   - **Environment**: `Node`
   - **Build Command**: `npm install`
   - **Start Command**: `node init_db.js && node seed_admin_table.js && node index.js`
   - **Instance Type**: `Free`
4. **Configure Environment Variables**:
   Add the following under the **Environment** tab:
   - `PORT` = `10000` (Render's default)
   - `DB_HOST` = (Your TiDB Cloud / external MySQL Hostname)
   - `DB_PORT` = `4000` (for TiDB) or `3306`
   - `DB_USER` = (Database Username)
   - `DB_PASSWORD` = (Database Password)
   - `DB_NAME` = `exam_system`
   - `DB_SSL` = `true` (TiDB requires SSL)
   - `JWT_SECRET` = `super_secret_jwt_key_exam_system_2026`
   - `OPENROUTER_API_KEY` = (Your OpenRouter API Key)
   - `EMAIL_USER` = `learnifyxteam@gmail.com`
   - `EMAIL_PASS` = `rxefdbwrpqgyxjpw`
5. **Deploy**:
   - Click **Deploy Web Service**.
   - Once the build succeeds and logs show `Server running on port 10000`, click the provided Render URL to access your live site!

---

## Setting Up Cloud MySQL (TiDB Cloud)
If you want to use Render or need a separate free production database:

1. **Sign up** at [TiDB Cloud](https://pingcap.com/products/tidb-cloud).
2. **Create a Serverless Cluster** (100% Free).
3. **Get Connection Details**:
   - In the cluster dashboard, click **Connect**.
   - Choose **Node.js (mysql2)** or general parameters.
   - Note the Host, Port (typically 4000), User, and Password.
4. **Enable SSL**:
   - Set `DB_SSL=true` in your deployment environment variables. The codebase `db.js` is already coded to automatically establish an SSL connection when connecting to any host containing `tidbcloud.com`.
