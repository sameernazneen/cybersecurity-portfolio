#!/usr/bin/env bash
# Reproduce the lab. Run in an empty directory.
set -e
openssl genrsa -out private_key.pem 2048
openssl rsa -in private_key.pem -outform PEM -pubout -out public_key.pem
echo 'This is a secret message, for authorized parties only' > secret.txt
openssl pkeyutl -encrypt -pubin -inkey public_key.pem -in secret.txt -out secret.enc
openssl pkeyutl -decrypt -inkey private_key.pem -in secret.enc
openssl dgst -sha256 -sign private_key.pem -out secret.txt.sha256 secret.txt
openssl dgst -sha256 -verify public_key.pem -signature secret.txt.sha256 secret.txt
