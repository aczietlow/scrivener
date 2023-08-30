#!/bin/bash

# Set input and output directories
input_dir="/media-assets/"

find $input_dir -type f -name "*.mkv" | while read -r input_file; do
  file_name=$(basename "$input_file" .mkv)
  file_path=$(dirname "$input_file")

  output_file="$file_path/$file_name.mp4"
  echo "$input_file"
  echo "$output_file"

  ffmpeg -i "$input_file" -c:v libx264 -c:a aac -crf 23 -c:s dvd_subtitle "$output_file"
  rm "$input_file"
done