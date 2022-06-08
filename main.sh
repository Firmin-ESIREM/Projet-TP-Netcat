#!/bin/bash

rm -f ./fifo
mkfifo ./fifo
hname="$(hostname -s)"

priv_key=$(cat "code.key")
code_upper=$(echo "$priv_key" | tr "a-z" "A-Z")
code_lower=$(echo "$priv_key" | tr "A-Z" "a-z")
code="$code_upper$code_lower"

function hash_password () {
    local pwd_hash_full=$(echo $1 | sha256sum)
    local pwd_hash=$(echo $pwd_hash_full | rev | cut -c3- | rev)
    echo "$pwd_hash"
}

function decrypt() {
  echo -n "$1" | tr "$code" "A-Za-z"
}

function crypt() {
  echo -n "$1" | tr "A-Za-z" "$code"
}

function interpret () {
  current_date=$(LANG=en_us_88591; date)

  crypt "$current_date\n"
  crypt "Welcome to $hname!\n"
  crypt "Please enter your password: "
  pwd_file=$(cat password.conf)



  while read line_enc;
  do
    line=$(decrypt line_enc)
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
      crypt "The password is correct. You are now logged in.\n"
      break
    else
      crypt "The password is incorrect. Please enter your password: "
    fi
  done
  echo -n "$USER@$hname $PWD \$ "
  while read line_enc;
  do
    line=$(decrypt line_enc)
    $line | xargs -I{} crypt {}
    crypt "$USER@$hname $PWD \$ "
  done
}

echo "[LOG] Server starting..."
while true
do
  nc -l 12345 < ./fifo | interpret &> ./fifo
done
echo "[LOG] Server ending..."
