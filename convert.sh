#!/bin/bash

# Set input and output directories
#input_dir="assets/"
input_dir="/media-assets/"
debug_out=true

function transcode() {
  ffmpeg -nostdin -i "${input_file}" "${video_opts}" "${audio_opts}" "${subtitle_opt}" "${output_file}"
}

function debug() {
      echo "$input_file"
      echo "$output_file"
      echo "$parent_dir_name"

      echo "$AUDIO_CH"
      echo "$AUDIO_CODEC"

      echo "$HEIGHT"
      echo "$WIDTH"

      echo "$AC3"
      echo "$AAC"
      echo "$DTS"
      echo "$order"
      echo "$audio_codec"
      echo "$video"
      echo "$fps"
}

find $input_dir -type f -name "*.mkv" | while read -r input_file; do
  file_name=$(basename "$input_file" .mkv)
  file_path=$(dirname "$input_file")
  parent_dir_name=$(basename "$file_path")

#  output_file="$file_path/$file_name.mp4"
#  output_file="$file_path/$parent_dir_name.mp4"

  #  Detect what audio_codec codec is being used:
  audio_codec=$(ffprobe "$input_file" 2>&1 | sed -n '/Audio:/s/.*: \([a-zA-Z0-9]*\).*/\1/p' | sed 1q)
  ##  Detect video codec:
  video=$(ffprobe "$input_file" 2>&1 | sed -n '/Video:/s/.*: \([a-zA-Z0-9]*\).*/\1/p' | sed 1q)

  WIDTH=$(ffprobe -v error -select_streams v:0 -show_entries stream=width -of default=nw=1:nk=1 "$input_file")
  HEIGHT=$(ffprobe -v error -select_streams v:0 -show_entries stream=height -of default=nw=1:nk=1 "$input_file")

  AUDIO_CH=$(ffprobe "$input_file" -show_streams -select_streams a:0 -loglevel quiet | sed -n '/channels=/s/channels=//p')
  AUDIO_CODEC=$(ffprobe "$input_file" -show_streams -select_streams a:0 -loglevel quiet | sed -n '/codec_name=/s/codec_name=//p')

  # Check the audio_codec track used in the files
  # Check if it's AC3 audio_codec or DTS
  AC3=$(mkvinfo "$input_file" | grep AC3)
  AAC=$(mkvinfo "$input_file" | grep AAC)
  DTS=$(mkvinfo "$input_file" | grep DTS)
  #check if the video track is first or the audio_codec track
  order=$(mkvinfo "$input_file" | grep "Track type" | sed 's/.*://' | head -n 1 | tr -d " ")

  ##  Set default audio_codec settings
  audio_opts="-c:a aac -vbr 3"

  ##  Set default video settings:
  video_opts="-c:v libx264 -crf 23"

  ## Set default subtitle settings:
  # TODO Fix this. dvd_subtitle not always available
#  subtitle_opt="-c:s dvd_subtitle"
  subtitle_opt=""

  #store the fps of the video track
  fps=$(mkvinfo "$input_file" | grep duration | sed 's/.*(//' | sed 's/f.*//' | head -n 1)

  if [[ $AUDIO_CH == "6" ]]; then
    # TODO Figure out if we want to keep this long term? i.e. have a standard and surround sound version.
    # Downmix 6ch audio to 2ch aac
   audio_opts="-af aresample=matrix_encoding=dplii -ac 2 -c:a aac -strict -2 -b:a 128k"
  elif [[ $AUDIO_CODEC == "ac3" ]]; then
    # Convert ac3 audio to aac for better compatibility
    audio_opts="-c:a aac -strict -2 -b:a 128k"
  elif [[ $AUDIO_CODEC == "dca" || $AUDIO_CODEC == "dts" ]]; then
    # Convert dts audio to aac for better compatibility
    audio_opts="-c:a aac -strict -2 -b:a 128k"
  else
    # Simple container change for files that do not hit conditions above
    audio_opts="-c:a aac -vbr 3"
  fi

  if [[ $HEIGHT == "2160" ]]; then
    video_opts="-vf scale=-1:1080 -c:v libx264 -crf 18 -preset veryslow"
    output_file="$file_path/$parent_dir_name.mp4"
    transcode

    video_opts="-vf scale=-1:1080 -c:v libx264 -crf 18 -preset veryslow"
    output_file="$file_path/$parent_dir_name - 1080p.mp4"
    transcode

    # 720
    video_opts="-vf scale=-1:720 -c:v libx264 -crf 23 -preset slow"
    output_file="$file_path/$parent_dir_name - 720p.mp4"
    transcode

    # 480
    video_opts="-vf scale=-1:480 -c:v libx264 -crf 23"
    output_file="$file_path/$parent_dir_name - 480p.mp4"
    transcode

  elif [[ $HEIGHT == "1080" ]]; then
    video_opts="-vf scale=-1:1080 -c:v libx264 -crf 18 -preset veryslow"
    output_file="$file_path/$parent_dir_name.mp4"
    transcode

    # 720
    video_opts="-vf scale=-1:720 -c:v libx264 -crf 23 -preset slow"
    output_file="$file_path/$parent_dir_name - 720p.mp4"
    transcode

    # 480
    video_opts="-vf scale=-1:480 -c:v libx264 -crf 23"
    output_file="$file_path/$parent_dir_name - 480p.mp4"
    transcode

    # 240 (width not divisible by 2)
#    video_opts="-vf scale=-1:240 -c:v libx264 -crf 23"
#    output_file="$file_path/$file_name - 240p.mp4"
#    ffmpeg -i "${input_file}" ${video_opts} ${audio_opts} "$output_file"
  elif [[ $HEIGHT == "720" ]]; then
    # 720
    video_opts="-vf scale=-1:720 -c:v libx264 -crf 23 -preset slow"
    output_file="$file_path/$parent_dir_name.mp4"
    transcode

    # 480
    video_opts="-vf scale=-1:480 -c:v libx264 -crf 23"
    output_file="$file_path/$parent_dir_name - 480p.mp4"
    transcode

    # 240
    video_opts="-vf scale=-1:240 -c:v libx264 -crf 23"
    output_file="$file_path/$parent_dir_name - 240p.mp4"
    transcode

#  elif [[ $HEIGHT == "576" ]]; then


  elif [[ $HEIGHT == "480" ]]; then
    # 480
    video_opts="-vf scale=-1:480 -c:v libx264 -crf 23"
    output_file="$file_path/$parent_dir_name.mp4"
    transcode

    # 240
    video_opts="-vf scale=-1:240 -c:v libx264 -crf 23"
    output_file="$file_path/$parent_dir_name - 240p.mp4"
    transcode

#  elif [[ $HEIGHT == "320" ]]; then
  else
    # Not much else to do here but to copy.
    video_opts="-c:v copy"
  fi

# Poor mans console log.
  if $debug_out; then
    debug
  fi
#  ffmpeg -i "$input_file" -c:v libx264 -c:a aac -crf 23 -c:s dvd_subtitle "$output_file"
# TODO add opt to delete source file when done.
#  rm "$input_file"
done