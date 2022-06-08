#!/bin/bash

rm -f ./fifo
mkfifo ./fifo
hname="$(hostname -s)"

function hash_password () {
    local pwd_hash_full=$(echo $1 | sha256sum)
    local pwd_hash=$(echo $pwd_hash_full | rev | cut -c3- | rev)
    echo "$pwd_hash"
}

function test_password() {
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
  echo "Welcome to $hname!"
  echo -n "Please enter your password: "
  pwd_file=$(cat password.conf)



  while read line;
  do
    # echo "Debug, received == $line ==" >&2
    for text_line in $pwd_file
    do
      pwd_hash=$(hash_password "$line")
      if [ "$text_line" == "$pwd_hash" ]
      then
        success="1"
        break
      else
        success="0"
      fi
    done
    if [ $success == "1" ]
    then
      echo "The password is correct. You are now logged in."
      break
    else
      echo -n "The password is incorrect. Please enter your password: "
    fi
  done
  echo -n "$USER@$hname $PWD \$ "
  while read line;
  do
    $line
    echo -n "$USER@$hname $PWD \$ "
  done
}

echo "[LOG] Server starting..."
while true
do
  nc -l localhost 12345 < ./fifo | interpret &> ./fifo
done
echo "[LOG] Server ending..."
