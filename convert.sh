#!/bin/bash

# Set input and output directories
input_dir="/media-assets/"

find $input_dir -type f -name "*.mkv" | while read -r input_file; do
  file_name=$(basename "$input_file" .mkv)
  file_path=$(dirname "$input_file")
  parent_dir_name=$(basename "$file_path")

  output_file="$file_path/$parent_dir_name.mp4"

  ffmpeg -nostdin -i "$input_file" -c:v libx264 -c:a aac -crf 23 -c:s dvd_subtitle "$output_file"
  rm "$input_file"
done