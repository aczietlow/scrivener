Media Converter to transcode mkv files to mp4 files using ffmpeg

## Requirements

- ffmpeg
- mkvtoolnix


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

## Usage 

Add mkv container files into the `assets directory` inside a folder with the name of movie to be transcribed. For example:

```
./assets/Cinderella/t001.mkv
./assets/Top Gun/a001.mkv
./assets/The Little Mermaid/b001.mkv
```

Run `docker run --rm -v /path/to/assets:/media-assets aczietlow/mkv-scriv:latest`

![MKV conversion.jpg](MKV%20conversion.jpg)

This will process a single mkv per execution. So after a single run, assuming 1080p MKV files (common from Blu-ray formats) you may have output like follows: 

```
./assets/Cinderella/Cinderella.mp4
./assets/Cinderella/Cinderella - 720p.mp4
./assets/Cinderella/Cinderella - 480p.mp4
./assets/Cinderella/Cinderella - 240p.mp4
./assets/Top Gun/a001.mkv
./assets/The Little Mermaid/b001.mkv
```


Notice that during clean up the scrivener will delete the mkv file, as it's no longer need. 

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


#### Notes for future Chris

Drop mkv files into the assets directory.

`docker run --rm -v /home/aczietlow/Projects/media-converter/assets:/media-assets aczietlow/mkv-scriv:latest`
or 
`docker run --rm -v $unconverted_files:/media-assets aczietlow/mkv-scriv:latest`

Later I should create a cron job to periodically scan and start this docker container... or something something k8s/openshift

Additionally, create a script that moves them to the remote server when done converting

`scp -r ./Cinderella\ \(2015\) aczietlow@192.168.1.235:/home/aczietlow/Media2/Movies/`
`scp -c aes128-ctr -r /home/aczietlow/Projects/media-converter/assets/Transcoded/* aczietlow@k8s:/home/aczietlow/Media2/Movies/`

## TODO

##### Subtitles

Should automatically detect subtitle codec from the mkv track, and transcode accordingly. 

Need to add switching logic, and better detection here. Look more into soft vs hard subtitles. i.e. separate text file vs burning into the video.
https://ffmpeg.org/ffmpeg-filters.html#subtitles
https://en.wikibooks.org/wiki/FFMPEG_An_Intermediate_Guide/subtitle_options