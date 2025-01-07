#!/bin/bash
# Transpose rows and columns using paste and cut

echo "Enter the file name:"
read filename

if [ -f "$filename" ]; 
then
  A= $(head -n1 "$filename")
  echo "A data is : $A"

  cols=$(head -n1 "$filename" | wc -w)
  echo " cols data is: $cols"
  for ((i = 1; i <= cols; i++)); do
    cut -d' ' -f"$i" "$filename" | paste -sd' ' -
  done
else
  echo "File does not exist."
fi