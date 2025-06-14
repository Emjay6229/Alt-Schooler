## ✅ **Server Setup**

To set up a cloud-based server, a server provider was selected (**AWS**).

1. Log in to AWS and spin up an EC2 instance.
2. Click **Launch Instance**.
3. Enter your preferred instance name, server OS, hardware specification, and instance type.
4. Set up a key pair for SSH access and download the generated `.pem` file.
5. Configure a security group that allows traffic on ports **22 (SSH)**, **80 (HTTP)**, and **443 (HTTPS)**.
6. Select storage volume (the default storage volume is fine).
7. Launch the instance.

---

## ✅ **Accessing the Server**

To access the EC2 instance, SSH into it with the following command:

```bash
ssh -i <path-to-key-pair.pem-file> ubuntu@<instance-public-ip>
```

**Bonus:** Run `sudo apt update` to update the package index.

---

## ✅ **Webpage Deployment**

The landing page was created with **Next.js** (a modern React framework) and pushed to GitHub.

To deploy the project:

1. **SSH into the EC2 instance** (if you haven’t already):

   ```bash
   ssh -i <path-to-key-pair.pem-file> ubuntu@<instance-public-ip>
   ```

2. **Clone the project from GitHub:**

   ```bash
   git clone <project-repo-link>
   ```

3. **Install Node.js on the EC2 instance:**

   ```bash
   curl -fsSL https://deb.nodesource.com/setup_<version_number>.x | sudo -E bash -
   sudo apt install -y nodejs
   ```

   Verify installation:

   ```bash
   node -v
   npm -v
   ```

4. **Install project dependencies:**

   ```bash
   npm install
   ```

5. **Build and start the Next.js project:**

   ```bash
   npm run build
   npm start
   ```

   (The default port is `3000`.)

**Bonus:** To ensure the server automatically restarts on crashes, install **PM2** and run the app with it.

---

## ✅ **Obtaining a Domain or Subdomain**

Free (sub)domain names can be obtained from providers like:
- [DuckDNS](https://www.duckdns.org)
- [FreeDNS (afraid.org)](https://freedns.afraid.org)

Or you can purchase a domain from providers like **Namecheap** or **GoDaddy**.

---

## ✅ **Securing the Website**

To secure your website, obtain a free SSL certificate from **Let’s Encrypt** using **Certbot**.

1. **Install Certbot for NGINX:**

   ```bash
   sudo apt install certbot python3-certbot-nginx -y
   ```

2. **Run Certbot and follow the prompts:**

   ```bash
   sudo certbot --nginx
   ```

   Or specify your domain directly:

   ```bash
   sudo certbot --nginx -d <your-domain-name>
   ```

---

## ✅ **Setting up NGINX Reverse Proxy**

1. **Install NGINX:**

   ```bash
   sudo apt install nginx -y
   ```

2. **Configure the default site:**

   ```bash
   sudo nano /etc/nginx/sites-available/default
   ```

   Update the `server` block for both `80` and `443` ports with this configuration:

   ```nginx
   server {
       listen 80;
       server_name <your-domain-name>;

       location / {
           proxy_pass http://localhost:3000;
           proxy_http_version 1.1;
           proxy_set_header Upgrade $http_upgrade;
           proxy_set_header Connection 'upgrade';
           proxy_set_header Host $host;
           proxy_cache_bypass $http_upgrade;
       }
   }
   ```

   **Note:** Since the webpage is a Node.js application, comment out the default static file settings:

   ```nginx
   # root /var/www/html;
   # index index.html index.htm index.nginx-debian.html;
   # try_files $uri $uri/ =404;
   ```

3. **Test your configuration:**

   ```bash
   sudo nginx -t
   ```

4. **Reload NGINX:**

   ```bash
   sudo systemctl reload nginx
   ```

Your domain should now serve your landing page over **HTTPS**!