# Let’s Encrypt DNS Challenge - Cloudflare

Create a cloudflare.ini file inside /root/.secrets/ directory.

mkdir -p /root/.secrets/ && cd /root/.secrets/ && touch cloudflare.ini
chmod 0400 /root/.secrets/cloudflare.ini

Add the below code and save using CTRL+O and exit using CTRL+X

dns_cloudflare_email = "your-cloudflare-email@example.com"
dns_cloudflare_api_key = "XXXXXXXXXXXXXXXXX"

Find your Cloudflare e-mail and Global API key at “My Profile” > API Tokens > Global API Key

Install Certbot and DNS Authenticator according to OS and HTTP web server

apt install certbot
apt install python3-certbot-dns-cloudflare

Get Wildcard SSL Certificate

certbot certonly --dns-cloudflare --dns-cloudflare-credentials /root/.secrets/cloudflare.ini -d <<FQDN>> --preferred-challenges dns-01

### Disable IPv6 if Cloudflare Token is resticted by IP
sysctl -w net.ipv6.conf.all.disable_ipv6=1
sysctl -w net.ipv6.conf.default.disable_ipv6=1
sysctl -w net.ipv6.conf.lo.disable_ipv6=1

Test renewal

certbot renew --dry-run

Set Automatic Renewal using Cron Job

echo "0 0 * * *  /etc/init.d/apache2 reload >/dev/null 2>&1" > /etc/cron.d/certbot.cron
