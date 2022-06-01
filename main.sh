#!/bin/bash

rm -f ./fifo
mkfifo ./fifo

function interpret () {
  current_date=$(LANG=en_us_88591; date)
  echo $current_date
  echo "Welcome to Quentin and Firmin’s server!"
  echo -n "Please enter your password: "
  pwd_hash=$(cat password.conf)
  while read line;
  do
    # echo "Debug, received == $line ==" >&2
    if [ $line == $pwd_hash ]
    then
       echo "The password is correct. You are now logged in."
       break
    else
      echo -n "Password incorrect. Please enter your password: "
    fi
  done
  while read line;
  do
    echo $line | bash
  done
}

echo "[LOG] Server starting..."
nc -l localhost 12345 < ./fifo | interpret &> ./fifo
echo "[LOG] Server ending..."
