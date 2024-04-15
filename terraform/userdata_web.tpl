#!/bin/bash

sudo apt - get update && sudo apt - get upgrade - y
sudo apt install - y apache2
sudo systemctl enable apache2
sudo systemctl start apache2

# Create HTML file with content
cat << EOF > index.html <
    !DOCTYPE html >
    <
    html lang = "en" >
    <
    head >
    <
    meta charset = "UTF-8" >
    <
    meta name = "viewport"
content = "width=device-width, initial-scale=1.0" >
    <
    title > Hello, from Darryl 's Three Tier Application</title> <
    /head> <
    body >
    <
    h1 > Hello, World! < /h1> <
    /body> <
    /html>
EOF

# Copy HTML file to Apache2 web directory
sudo cp index.html /
    var / www / html /

    #Set correct permissions
for the HTML file
sudo chmod 644 /
    var / www / html / index.html