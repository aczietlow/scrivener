#!/bin/bash

# Set input and output directories
input_dir="/path/to/input/directory"
output_dir="/path/to/output/directory"

# Ensure the output directory exists
mkdir -p "$output_dir"

# For every .mkv file in the input directory
for input_file in "$input_dir"/*.mkv; do
    # Get the file name without the extension
    file_name=$(basename "$input_file" .mkv)

    # Set the output file path
    output_file="$output_dir/$file_name.mp4"

    # Convert the file with ffmpeg
    ffmpeg -i "$input_file" -c:v libx264 -crf 23 -c:a aac "$output_file"
done