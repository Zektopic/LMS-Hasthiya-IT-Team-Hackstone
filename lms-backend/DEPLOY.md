# Deployment Instructions for LMS Backend

This guide provides instructions for deploying the Node.js backend for the Learning Management System.

## Prerequisites

Before you begin, ensure you have the following installed:
- [Node.js](https://nodejs.org/) (which includes `npm`)
- [Git](https://git-scm.com/)
- An account with a cloud hosting provider that supports Node.js, such as [Heroku](https://www.heroku.com/) or [Render](https://render.com/).

## Local Setup

1.  **Clone the repository:**
    ```bash
    git clone <repository-url>
    cd <repository-folder>/lms-backend
    ```

2.  **Install dependencies:**
    ```bash
    npm install
    ```

## Environment Variables

The application requires environment variables to manage sensitive information like database credentials and secrets.

1.  **Create a `.env` file** in the `lms-backend` directory by copying the example file:
    ```bash
    cp .env.example .env
    ```

2.  **Edit the `.env` file** with your specific configuration:

    -   `DATABASE_URL`: Your full MongoDB connection string.
    -   `JWT_SECRET`: A long, random, and secret string used for signing authentication tokens.
    -   `PORT`: (Optional) The port the server will run on. Defaults to 5000.

## Running the Server Locally

To start the server in a development environment, run:
```bash
npm start
```
The server should now be running on the port specified in your `.env` file or on the default port 5000.

## Deployment to a Cloud Platform (e.g., Heroku/Render)

These are generic steps for deploying to a modern cloud hosting service. Please refer to your provider's specific documentation for details.

1.  **Create a New Application:**
    -   Log in to your hosting provider (e.g., Render).
    -   Create a new "Web Service" or "Application".

2.  **Connect Your Repository:**
    -   Connect your GitHub, GitLab, or Bitbucket account and select the repository containing this project.

3.  **Configure the Environment:**
    -   **Build Command:** Set this to `npm install`.
    -   **Start Command:** Set this to `npm start`.

4.  **Add Environment Variables:**
    -   In your application's dashboard, find the section for "Environment Variables" or "Secrets".
    -   **Do not upload your `.env` file.** Instead, add each variable from your `.env` file (`DATABASE_URL`, `JWT_SECRET`, etc.) one by one into the platform's configuration. This is a critical security step.

5.  **Deploy:**
    -   Trigger a manual deployment or push to your main branch to initiate an automatic deployment.
    -   The platform will use the build and start commands to build the application and run the server.

6.  **Check Logs:**
    -   Use the platform's logging tools to monitor the deployment process and check for any errors. Once deployed, you will be given a public URL to access your API.
