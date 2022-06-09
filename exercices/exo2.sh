rm -f ./fifo
mkfifo ./fifo

function interpret () {
  current_date=$(LANG=en_us_88591; date)
  echo $current_date
  echo "Welcome to Quentin and Firmin’s server!"
  echo -n " \$  "
  while read line;
  do
    echo $line > toto
    echo $line | bash
    echo -n " \$  "
  done
}

echo "[LOG] Server starting..."
nc -kl localhost 12345 < ./fifo | interpret &> ./fifo
echo "[LOG] Server ending..."