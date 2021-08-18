#!/bin/bash

date=$(date +'%Y%m%d')
## on determine le nom de l'image
IFS='-' read -ra my_array <<<"$1"
# shellcheck disable=SC2004
arrayLen="${#my_array[@]}"
if ((my_array[$((arrayLen -2))] != $date)); then
  my_array[$((arrayLen -2))]=$date
  my_array[$((arrayLen -1))]="001"
else
  # sed removes leading zeroes from stdin
  occurence=$(echo ${my_array[$((arrayLen -1))]} | sed 's/^0*//')
  number=$((occurence + 1))
  if ((occurence < 10)); then
    occurence="00${number}"
  else
    occurence="0${number}"
  fi
  my_array[$((arrayLen -1))]=$occurence
fi

imageDesc=$(
  IFS='-'
  echo "${my_array[*]}"
)

echo -e "$imageDesc" | tr -d '\n' >> ./modules/"$2"/"$3".txt

