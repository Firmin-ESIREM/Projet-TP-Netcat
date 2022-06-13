#!/bin/bash

if [ $# -ne 2 ]
then
  >&2 echo "Usage: ./save_password_hash.sh [password] [password_file]"
  exit 1
fi

pwd_hash_full=$(echo "$1" | sha256sum)
pwd_hash=$(echo $pwd_hash_full | rev | cut -c3- | rev)
echo "$pwd_hash" > "$2"
echo "Your password was registered successfully."
