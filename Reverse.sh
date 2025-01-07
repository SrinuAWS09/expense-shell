#!/bin/bash
# Transpose rows and columns using paste and cut

echo "Enter the file name:"
read filename

if [ -f "$filename" ]; 
then

  cols=$(head -n1 "$filename" | wc -w)
  echo " cols data is: $cols"
  for ((i = 1; i <= cols; i++)); do
  data1=$(cut -d' ' -f"$i" "$filename")
  echo "data 1 is : $data1"
    data=$(cut -d' ' -f"$i" "$filename" | paste -sd' ' -)
    echo " data is : $data"
  done
else
  echo "File does not exist."
fi