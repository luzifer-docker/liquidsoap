FROM debian:stable-slim

# Allows passing in a different script name, if desired.
ENV LIQUIDSOAP_SCRIPT=/etc/liquidsoap/liquidsoap.liq \
    LIQUIDSOAP_VERSION=1.3.3

# Add package repo
RUN echo "deb http://deb.debian.org/debian stable main contrib non-free" > /etc/apt/sources.list

# Set up dependencies
RUN set -ex \
 && apt-get update \
 && apt-get -y install --no-install-recommends \
      autoconf \
      automake \
      autotools-dev \
      build-essential \
      ca-certificates \
      camlp4-extra \
      curl \
      dnsutils \
      libasound2-dev \
      libavutil-dev \
      libfdk-aac-dev \
      libflac-dev \
      libid3tag0-dev \
      libmad0-dev \
      libmp3lame-dev \
      libogg-dev \
      libopus-dev \
      libpcre3-dev \
      libsamplerate-dev \
      libshout3-dev \
      libssl-dev \
      libtag1-dev \
      libtool \
      libvorbis-dev \
      m4 \
      ocaml-nox \
      opam \
      telnet \
      wget \
 && useradd --create-home --system liquidsoap \
 && mkdir /var/log/liquidsoap \
 && chown -R liquidsoap:liquidsoap /var/log/liquidsoap \
 && chmod 0755 /var/log/liquidsoap \
 && mkdir /etc/liquidsoap && chmod -R 0755 /etc/liquidsoap \
 && apt-get autoremove -y --purge \
 && rm -rf /var/lib/apt/lists/*

# Switch over so we can use OPAM
USER liquidsoap

# Initialize OPAM and install Liquidsoap and asssociated packages
RUN set -ex \
 && opam init -a -y \
 && opam update \
 && eval $(opam config env) \
 && opam install -y \
      cry \
      fdkaac \
      flac \
      inotify \
      lame \
      liquidsoap.${LIQUIDSOAP_VERSION} \
      mad \
      ogg \
      opus \
      samplerate \
      ssl \
      taglib \
      vorbis \
      xmlplaylist

# Expose mountpoints for script / data
VOLUME ["/data", "/etc/liquidsoap"]

# Expose ports for harbor connections and telnet server, respectively
EXPOSE 8080 8011

# Start Liquidsoap with a path to the script defined in the variable
ENTRYPOINT ["/home/liquidsoap/.opam/system/bin/liquidsoap"]
CMD [${LIQUIDSOAP_SCRIPT}]
