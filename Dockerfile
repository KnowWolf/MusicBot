FROM alpine:3.11

# Install dependencies
RUN apk update \
&& apk add --no-cache \
  ca-certificates \
  ffmpeg \
  opus \
  python3 \
  libsodium-dev \
\
# Install build dependencies
&& apk add --no-cache --virtual .build-deps \
  gcc \
  git \
  libffi-dev \
  make \
  musl-dev \
  python3-dev 

# Set working directory
WORKDIR /home/container

# Add project requirements
COPY ./requirements.txt ./requirements.txt

# Install pip dependencies
RUN pip3 install --upgrade pip \
 && pip3 install --no-cache-dir -r requirements.txt \
\
# Clean up build dependencies
 && apk del .build-deps
 && adduser -D -h /home/container container
# Add project sources
COPY . ./

# Create volume for mapping the config
VOLUME /usr/src/musicbot/config

ENV USER=container HOME=/home/container

CMD ["python3", "dockerentry.py"]
