#!/bin/bash

code=$(cat $2)
code_upper=$(echo $code | tr "a-z" "A-Z")
code_lower=$(echo $code | tr "A-Z" "a-z")
code="$code_upper$code_lower"
cat "$1" | tr "A-Za-z" "$code" > file.sumo
