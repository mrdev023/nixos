#!/usr/bin/env bash

if [ $# -eq 0 ]; then
    echo "Usage: $0 <age_key_file> <user@host_name:port> <user@host_name:port> ..."
    exit 1
fi

age_key_file=$1
shift

if [ ! -f $age_key_file ]; then
  echo "file not found: $age_key_file"
  exit 1
fi

source $(dirname "$0")/common.sh

temp_file="$temp_dir/age.txt"

# Copy age key file in the temporary directory
cp $age_key_file "$temp_file"

for ssh_args_line in "$@"
do
    IFS=':' read -r ssh_user_and_host ssh_port <<< "$ssh_args_line"
    echo -e "\nDeploying age key to $ssh_user_and_host with port $ssh_port"

    if [ -z "$ssh_port" ]; then
        ssh_port=22
    fi

    if ssh -q -p "$ssh_port" "$ssh_user_and_host" "mkdir -p $key_dir"; then
        echo -e "\tCreate directory $key_dir \e[32m[OK]\e[0m"
    else
        echo -e "\tCreate directory $key_dir \e[31m[FAILED]\e[0m"
        continue
    fi

    if scp -q -P $ssh_port $temp_file $ssh_user_and_host:$key_file; then
        echo -e "\tCopy age key file $key_file \e[32m[OK]\e[0m"
    else
        echo -e "\tCopy age key file $key_file \e[31m[FAILED]\e[0m"
        continue
    fi

    if ssh -q -p "$ssh_port" "$ssh_user_and_host" "chown root:root $key_file"; then
        echo -e "\tChange owner to root:root for $key_file \e[32m[OK]\e[0m"
    else
        echo -e "\tChange owner to root:root for $key_file \e[31m[FAILED]\e[0m"
        continue
    fi

    if ssh -q -p "$ssh_port" "$ssh_user_and_host" "chmod 600 $key_file"; then
        echo -e "\tChange permission to 600 for $key_file \e[32m[OK]\e[0m"
    else
        echo -e "\tChange permission to 600 for $key_file \e[31m[FAILED]\e[0m"
        continue
    fi
done

echo -e "\n"

