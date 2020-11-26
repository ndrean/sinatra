#!/usr/bin/env bash

main () {
  # for i in {1..100};
  for ((i=1;i<=$1;++i)); do
    curl  -s http://localhost:8080  > /dev/null
  done
}

gettime(){  # execute a Ruby command
  ruby -e "puts (Time.now.to_f * 1000).to_i"; 
}

measure () {
  start=$(gettime) # saves the output of a command into a variable
  $1 $2  # execute 'main' with 'variable', which is user's input
  end=$(gettime)
  res=$(( end - start))
  echo "Time: $res ms"
}

echo "Enter number iterations: " 
read var
[[ $var ]] && echo "working..." && measure main "$var"
