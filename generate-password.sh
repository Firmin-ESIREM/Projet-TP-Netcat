#!/bin/bash

pwd_hash_full=$(echo $1 | sha256sum)
pwd_hash=$(echo $pwd_hash_full | rev | cut -c3- | rev)
echo "$pwd_hash" > password.conf
echo "Your password was registered successfully."
