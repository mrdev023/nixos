#!/usr/bin/env bash
# Source : https://github.com/nix-community/nixos-anywhere/blob/main/docs/howtos/secrets.md

if [ $# -lt 1 ]; then
    echo "Usage: $0 <age_key_file> <nixos-anywhere arguments>"
    exit 1
fi

age_key_file=$1
shift

if [ ! -f $age_key_file ]; then
  echo "File not found: $age_key_file"
  exit 1
fi


source $(dirname "$0")/common.sh

# Create the directory where sshd expects to find the host keys
install -d -m755 "$temp_dir$key_dir"

# Copy age key file in the temporary directory
cp $age_key_file "$temp_dir$key_file"

# Set the correct permissions so sshd will accept the key
chmod 600 "$temp_dir$key_file"

# Install NixOS to the host system with our secrets
nix run github:nix-community/nixos-anywhere -- --extra-files "$temp_dir" $@

