FROM debian
# Convert to alpine at a later date?

# Path: Dockerfile

RUN apt-get update && apt-get install -y \
    curl \
    git \
    vim \
    ffmpeg \
    && rm -rf /var/lib/apt/lists/*

# This should be mounted, and not part of the image, but it's helpful for testing out ffmpeg tools in the container
WORKDIR /root/media

CMD ["/bin/bash"]