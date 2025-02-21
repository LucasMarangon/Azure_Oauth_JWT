# Solving Azure's "Unsupported app-only token" Issue

## Overview

This is a step-by-step guide to overcoming Azure's unnecessarily complex authentication process when encountering errors like "Unsupported app-only token."

## Prerequisites

This guide assumes you have already set up your application in Azure. If you haven’t, follow the official documentation to configure permissions and other necessary details.

## The Problem

If you’re seeing "Unsupported app-only token.", you’ve likely attempted to generate a Bearer Token using an OAuth 2.0 request, but the token isn't being accepted.

Below is the process I used to successfully generate an authenticated Bearer Token that works for making API requests (in my case, for the SharePoint API).

## Solution Steps

### 1️⃣ Create and Register Your Certificate

Run Create-SelfSignedCertificate.ps1 in PowerShell (update the variables with your values).

After generating the certificate, upload it to your Azure app.

🔗 [Create a Self-Signed Certificate](https://learn.microsoft.com/en-us/sharepoint/dev/solution-guidance/security-apponly-azuread)

### 2️⃣ Generate a JWT Token

Run JWT.ps1 after filling in the necessary variables.

It should return a working JWT token, which you can validate at:

🔗 [JWT Validator](https://jwt.ms/)

### 3️⃣ Obtain a Valid Bearer Token

Run OAuth.ps1, ensuring that the script contains:

Your Azure details

The JWT token from the previous step

This script will return a valid Bearer Token, which can now be used for authentication.

## Conclusion

Now you can enjoy making requests with a fully functional Bearer Token (it shouldn't be this obscure)!

Hope this helps anyone stuck in Azure's authentication maze.

