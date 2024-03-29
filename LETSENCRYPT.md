# Let’s Encrypt DNS Challenge - Cloudflare

Create a cloudflare.ini file inside /root/.secrets/ directory.

mkdir -p /root/.secrets/ && cd /root/.secrets/ && nano cloudflare.ini

Add the below code and save using CTRL+O and exit using CTRL+X

dns_cloudflare_email = "your-cloudflare-email@example.com"
dns_cloudflare_api_key = "XXXXXXXXXXXXXXXXX"

Find your Cloudflare e-mail and Global API key at “My Profile” > API Tokens > Global API Key

chmod 0400 /root/.secrets/cloudflare.ini

Install Certbot and DNS Authenticator according to OS and HTTP web server

snap install --beta --classic certbot
snap set certbot trust-plugin-with-root=ok
snap install --beta certbot-dns-cloudflare
snap connect certbot:plugin certbot-dns-cloudflare

Get Wildcard SSL Certificate

certbot certonly --dns-cloudflare --dns-cloudflare-credentials /root/.secrets/cloudflare.ini -d example.com,*.example.com --preferred-challenges dns-01

Set Automatic Renewal using Cron Job

    Type crontab -e
    Type 1 for nano editor
    Enter below command and save

0 0 * * *  /etc/init.d/apache2 reload >/dev/null 2>&1

Test renewal

certbot renew --dry-run
