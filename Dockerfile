FROM debian
# Convert to alpine at a later date?

# Path: Dockerfile

RUN apt-get update && apt-get install -y \
    curl \
    git \
    vim \
    ffmpeg \
    mkvtoolnix \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir /media-assets

# Copy file and make executable
COPY convert.sh /usr/local/bin/convert.sh

RUN chmod +x /usr/local/bin/convert.sh

ENTRYPOINT ["/usr/local/bin/convert.sh"]