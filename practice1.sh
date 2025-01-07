#!/bin/bash
# Check if the file exists
 
if [ -f "$filename" ]
 then
  echo "Processing file: $filename"
  else 
  echo "Something wrong somewhere"
fi

  # Count word occurrences and display the top 5
  #tr -s '[:space:][:punct:]' '\n' < "$filename" | tr '[:upper:]' '[:lower:]' | sort | uniq -c | sort -nr | head -5
#else
 # echo "File does not exist. Please provide a valid file."
#fi