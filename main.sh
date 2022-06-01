#!/bin/bash

rm -f ./fifo
mkfifo ./fifo

function hash_password(){
    local pwd_hash_full=$(echo $1 | sha256sum)
    local pwd_hash=${pwd_hash_full::-3}
    echo "$pwd_hash"
}
function test_password(){
    for line in $1
    do
    if [ "$line" == "$hash_password $2" ]
        then
        return 1
        else
        return 0
        fi
    done
}

function interpret () {
  current_date=$(LANG=en_us_88591; date)
  
  echo $current_date
  echo "Welcome to Quentin and Firmin’s server!"
  echo -n "Please enter your password: "  
  pwd_file=$(cat password.conf)

  pwd_hash=$(hash_password "$message") 

  while read line;
  do
    # echo "Debug, received == $line ==" >&2
    for text_line in $1
    do
      if [ "$text_line" == "$pwd_hash" ]
      then
        echo "The password is correct. You are now logged in."
        break
      else
        echo -n "Password incorrect. Please enter your password: "   
      fi
    done
  done
  while read line;
  do
    echo $line | bash
  done
}

echo "[LOG] Server starting..."
nc -l localhost 12345 < ./fifo | interpret &> ./fifo
echo "[LOG] Server ending..."
