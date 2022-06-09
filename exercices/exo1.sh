rm -f ./fifo
mkfifo ./fifo

function interpret () {
  current_date=$(LANG=en_us_88591; date)
  echo $current_date
  echo "Welcome to Quentin and Firmin’s server!"
  while read line;
  do
   echo $text_line
  done
}

echo "[LOG] Server starting..."
nc -l localhost 12345 < ./fifo | interpret &> ./fifo