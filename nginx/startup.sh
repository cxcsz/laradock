#!/bin/bash

if [ ! -f /etc/nginx/ssl/default.crt ]; then
    openssl genrsa -out "/etc/nginx/ssl/default.key" 2048
    openssl req -new -key "/etc/nginx/ssl/default.key" -out "/etc/nginx/ssl/default.csr" -subj "/CN=default/O=default/C=UK"
    openssl x509 -req -days 365 -in "/etc/nginx/ssl/default.csr" -signkey "/etc/nginx/ssl/default.key" -out "/etc/nginx/ssl/default.crt"
    chmod 644 /etc/nginx/ssl/default.key
fi

if [ ! -f /etc/nginx/ssl/cxcsz.crt ]; then
    openssl genrsa -out "/etc/nginx/ssl/cxcsz.key" 2048
    openssl req -new -key "/etc/nginx/ssl/cxcsz.key" -out "/etc/nginx/ssl/cxcsz.csr" -subj "/CN=cxcsz.test/O=cxcsz/C=CN"
    openssl x509 -req -days 3650 -extfile <(printf "subjectAltName=DNS:cxcsz.test,DNS:*.cxcsz.test") -in "/etc/nginx/ssl/cxcsz.csr" -signkey "/etc/nginx/ssl/cxcsz.key" -out "/etc/nginx/ssl/cxcsz.crt"
    chmod 644 /etc/nginx/ssl/cxcsz.key
fi

# Start crond in background
crond -l 2 -b

# Start nginx in foreground
nginx
