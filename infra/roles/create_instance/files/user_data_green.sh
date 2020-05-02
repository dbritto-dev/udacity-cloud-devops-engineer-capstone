#!/bin/bash
set -e -x
sudo apt install nginx -y

# cat > /etc/nginx/sites-enabled/default << EOF
# server {
#     #listen   80; ## listen for ipv4; this line is default and implied
#     #listen   [::]:80 default_server ipv6only=on; ## listen for ipv6
#     listen 80;
#     server_name $domain_name;
#     root /var/www/html;
#     index index.html index.htm;
#     access_log /var/log/nginx/access.log;
#     error_log /var/log/nginx/error.log;
#     # Make site accessible from http://localhost/
#     server_name localhost;
#     location / {
#     }
# }
# EOF

# cat > /var/www/html/index.html << HEREDOC
# <!DOCTYPE html>
# <html>
# <body>
# <p style="color:green">green.</p>
# </body>
# </html>
# HEREDOC

echo '<p style="color:blue">green.</p>' > /var/www/html/index.html

sudo systemctl enable nginx
sudo systemctl start nginx
