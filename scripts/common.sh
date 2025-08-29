#!/usr/bin/env bash
temp_dir=$(mktemp -d)
key_file=/etc/keys/age.txt
key_dir=$(dirname $key_file)

# Function to cleanup temporary directory on exit
cleanup() {
    rm -rf "$temp_dir"
    echo "Temporary directory removed"
}
trap cleanup EXIT

