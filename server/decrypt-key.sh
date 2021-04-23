#!/bin/sh
set -ue

# RSA-decrypt the device key.
openssl pkeyutl -decrypt -inkey master.pem -in device_key-aes.rsa -out device_key-aes.key
mv device_key-aes.key ../client/
rm device_key-aes.rsa

