#!/bin/bash

yum update - y
yum install - y httpd
echo '<html><head><title>Welcome</title></head><body><h1>Darryl'
s Custom Page < /h1></body > < /html>' > /var / www / html / index.html
systemctl enable httpd
systemctl start httpd