#!/bin/bash

pwd_hash_full=$(echo $1 | sha256sum)
pwd_hash=${pwd_hash_full::-3}
echo "$pwd_hash" > password.conf
echo "Your password was registered successfully."