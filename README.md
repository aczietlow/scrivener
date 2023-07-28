Media Converter to transcode mkv files to mp4 files using ffmpeg

## Requirements

- ffmpeg
- 


## Installation (@TODO)

### Linux

#### Debian/Ubuntu

```bash 
#sudo apt install ffmpeg mkvtoolnix mkvtoolnix-gui mkvtoolnix-doc mkvtoolnix-qt mkvtoolnix-gui mkvtoolnix-gui-doc mkvtoolnix-gui-qt mkvtoolnix-gui-common mkvtoolnix-gui-extra mkvtoolnix-gui-extra-doc mkvtoolnix-gui-extra-qt
```

#### Fedora

```bash
#sudo dnf install ffmpeg mkvtoolnix mkvtoolnix-gui mkvtoolnix-doc mkvtoolnix-qt mkvtoolnix-gui mkvtoolnix-gui-doc mkvtoolnix-gui-qt mkvtoolnix-gui-common mkvtoolnix-gui-extra mkvtoolnix-gui-extra-doc mkvtoolnix-gui-extra-qt
```

## License

[MIT](https://choosealicense.com/licenses/mit/)

## Terms

MKV - Matroska Multimedia Container that can hold an unlimited number of video, audio, picture, or subtitle tracks in one file.

MP4 - MPEG-4 Part 14 or MP4 is a digital multimedia container format most commonly used to store video and audio, but it can also be used to store other data such as subtitles and still images.

Scrivener - a person who writes a text, book, or other document for another person.

## TIL

The only reason worth doing anything: the pursuit of knowledge!

`ffmpeg -encoders` - List all available encoders

### Notes

Build sandbox container for test
`docker run -v ./assets:/root/media -it --rm aczietlow/mkv-scriv /bin/bash`

Straight container copy. No encoding. Kind of defeats the whole purpose
1) `ffmpeg -i A1_t00.mkv -c copy oliver.mp4`

-> But why though? 

Use H264 encoding with a constant rate factor of 23 (default is 28) and AAC audio codec.

`ffmpeg -i "$input_file" -c:v libx264 -crf 23 -c:a aac "$output_file"`

2) `ffmpeg -i "A1_t00.mkv" -c:v libx264 -c:a aac -c:s dvd_subtitle -crf 23 -hide_banner "oliver.mp4"`

3) `fmpeg -i "A1_t00.mkv" -c:v mpeg4 -c:a aac -c:s ass -hide_banner "oliver.mp4"`

Not sure why ffmpeg won't do subtitles. Although the `mpeg4` codec in theory includes subtitles
Future Chris: It's because the mkv files Im working with use `dvd_subtitle` codec for subtitles. this is a bitmap codec and can't directly be converted to text, but there are tools that can do this.

#### Notes for future Chris

Added a successfully converted and encoded copy of lilo for reference.

I can successfully change the container to MP4, but when I run #2 and attempt to encode from within the container, I get the following error:

> "Internal data stream error."

Look into different ffmpeg commands or maybe add additional system resources to the containre (How to share CPU with docker)
Also maybe ffmpeg needs additional libraries to do the encoding correctly?