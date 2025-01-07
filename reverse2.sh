#!/bin/bash
# Reverse content of a file line by line using 'rev'

echo "Enter the input file name:"
read input_file

echo "Enter the output file name:"
read output_file

if [ -f "$input_file" ] then
  rev "$input_file" > "$output_file"
  echo "Reversed content saved to $output_file."
else
  echo "Input file does not exist."
fi