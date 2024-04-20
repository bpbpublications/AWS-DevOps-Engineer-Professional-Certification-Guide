#!/bin/bash
yum update -y
yum install -y httpd

cat <<EOF > /var/www/html/index.html
<!DOCTYPE html>
<html>
<head>
<title>Hello, World!</title>
</head>
<body>
<h1>Hello, World!</h1>
<p>This is a sample HTML page served by the Apache web server on Amazon EC2.</p>
</body>
</html>
EOF

systemctl start httpd
systemctl enable httpd

