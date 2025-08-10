#!/bin/bash
yum update -y
yum install -y nginx

# Start and enable nginx
systemctl start nginx
systemctl enable nginx

# Create a simple index page
cat > /var/www/html/index.html << EOF
<!DOCTYPE html>
<html>
<head>
    <title>Frontend Server</title>
</head>
<body>
    <h1>Welcome to Frontend Server</h1>
    <p>This is the nginx frontend server</p>
</body>
</html>
EOF

# Configure nginx to proxy to backend
cat > /etc/nginx/conf.d/app.conf << EOF
upstream backend {
    server internal-backend-lb:8080;
}

server {
    listen 80;
    location / {
        proxy_pass http://backend;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
    }
}
EOF

systemctl restart nginx