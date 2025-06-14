# Server Setup
To set up a cloud-based server, a server provider was selected (AWS)

-[x] Login to AWS to spin up an AWS EC2 instance
- Click on Launch instance
- Enter preferred instance name, server OS, hardware specification and instance type
- Set up key-pair for SSH access and download the generate .pem file.
- Configure a security group that allows traffic from ports 22 (SSH), 80 (HTTP) and 443 (HTTPS)
- Select storage volume (in this case, the default storage volume is fine)
- Launch instance

# Accessing the Server
To access the EC2 instance, SSH into it with the following command
`sudo ssh -i <path-to-key-pair.pem-file> ubuntu@<instance-public-ip>`

#### bonus: run `sudo apt update` to install latest version of packages and dependencies.

# Webpage Deployment
The landing page for this assignment was created with Next.Js (a mordern React framework for quickly bootstrapping websites and apps) and pushed to github. To deploy the project,

-[x] SSH into the EC2 instance (if that isn't done yet) and run `git clone <project-repo-link>`
This step clones the project from Github into the EC2 instance.

-[x] Install Node.js on the EC2 instance using the commands 
`curl -fsSL https://deb.nodesource.com/setup_<version_number>.x | sudo -E bash -`

This sets up the node source for Nodejs <version_number> on server package manager (apt).

Then run `sudo apt install -y nodejs` to install the specified node version on the EC2 instance. 
Run `node -version` and `npm -version `to confirm that installation was successful.

-[x] Run `npm install` to install nextjs dependencies
-[x] Run `next build` to build the project and generate a .next folder and `next start` to start running the project (default port is 3000).

#### bonus: To ensure server automatically restarts whenever it crashes, install the node process manager 2 (pm2) and run the node app with it.

# Obtaining a domain or subdomain name
A Free (sub)domain names can be obtained from sites like duckdns, freeDNS.afraid.org etc. or one can be purchased from domain name issuers like namecheap, goDaddy etc

# Securing our Website
To secure our website, we can obtain a free SSL certificate from let's encrypt. 
Let's encrypt provides a CLI tool (cerbot) to generate a free SSL certificate for our domain

-[x] Install certbot `sudo apt install certbot python3-certbot-nginx -y`
-[x] Run certbot `sudo certbot --nginx` and follow the prompt to complete the step or just run `sudo certbot --nginx -d <domain-name>`

# Setting up NGINX Reverse proxy
- Install Nginx `sudo apt install nginx -y`
- Run `sudo nano /etc/nginx/sites-available/default` and add the following to both 80 and 443 server blocks

```server {
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
}```

Since our webpage is a nodeJs application comment out the following from the Nginx file
 <!-- 
 root /var/www/html;
 index index.html index.htm index.nginx-debian.html;
 try_files $uri $uri/ =404;
 -->

- Run `sudo nginx -t` to test that the config is okay
- Run `sudo systemctl reload nginx` to reload nginx and apply changes

Your domain should be able to serve your landing page over HTTPS!