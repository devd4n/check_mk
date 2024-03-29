# Let’s Encrypt DNS Challenge - Cloudflare

https://certbot-dns-cloudflare.readthedocs.io/en/stable/

Create a cloudflare.ini file inside /root/.secrets/ directory.

mkdir -p /root/.secrets/ && cd /root/.secrets/ && touch cloudflare.ini
chmod 0400 /root/.secrets/cloudflare.ini

Add the below code and save using CTRL+O and exit using CTRL+X

dns_cloudflare_api_token = "XXXXXXXXXXXXXXXXX"

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

### SSL_ERROR_RX_RECORD_TOO_LONG

/etc/apache2/sites-enabled/default-ssl.conf
SSLEngine on
SSLCertificateKeyFile /etc/letsencrypt/live/<<fqdn>>/privkey.pem
SSLCertificateChainFile /etc/letsencrypt/live/<<fqdn>>/chain.pem
SSLCertificateFile /etc/letsencrypt/live/<<fqdn>>/cert.pem
Header always set Strict-Transport-Security "max-age=43200"


### Config default page and settings

touch /var/www/html/check_mk.html

/etc/apache2/sites-enabled/000-default
RewriteEngine On
# Next 2 lines: Force redirection if incoming request is not on 443
RewriteCond %{SERVER_PORT} !^443$
RewriteRule (.*) https://%{HTTP_HOST}$1 [L]
# Rewrite / to use another path (intern redirecting - not visible for client)
RewriteRule    "^/$"  "/check_mk.html" [PT]
RewriteRule    "^/index.html$"  "/check_mk.html" [PT]
# This section passes the system Apaches connection mode to the
# instance Apache. Make sure mod_headers is enabled, otherwise it
# will be ignored and "Analyze configuration" will issue "WARN".
<IfModule headers_module>
    RequestHeader set X-Forwarded-Proto expr=%{REQUEST_SCHEME}
    RequestHeader set X-Forwarded-SSL expr=%{HTTPS}
</IfModule>

### Create Site
omd create test_monitoring1
# change password:
cmk-passwd cmkadmin

### Create Site Choosing Menu

# get all sites and write a link record to check_mk.html (ls /omd/sites/)
echo "<meta http-equiv=\"refresh\" content=\"300;/$(ls /omd/sites/ | head -1)\" />" > /var/www/html/check_mk.html
echo "<h2>SITES</h2>" >> /var/www/html/check_mk.html
x="$(ls /omd/sites/)"; for i in "${x[@]}"; do echo "<p><a href=\"/$i\">$i</a></p>" >> /var/www/html/check_mk.html; done
systemctl restart apache2





