#!/bin/bash
set -eux

dev_packages=(
	libfdk-aac-dev # fdkaac.0.2.1
	libpcre3-dev # conf-libpcre.1
	libssl-dev # conf-openssl.1
	libmp3lame-dev # lame.0.3.3
	libmad0-dev # mad.0.4.5
	libogg-dev # ogg.0.5.2, flac.0.1.3, opus.0.1.2, vorbis.0.7.0
	libsamplerate0-dev # samplerate.0.1.4
	libtag1-dev # taglib.0.3.3
	libflac-dev # flac.0.1.3
	libopus-dev # opus.0.1.2
	libvorbis-dev # vorbis.0.7.0
	lsb-release # Local: Remove only
	m4 # Build-Dep
)

system_deps=(
	libfdk-aac1
	libflac8
	libmad0
	libmp3lame0
	libogg0
	libopus0
	libpcre16-3
	libpcre32-3
	libpcrecpp0v5
	libsamplerate0
	libssl1.1
	libtag1v5
	libtag1v5-vanilla
	libvorbis0a
	libvorbisenc2
	libvorbisfile3
)

ocaml_deps=(
	cry
	fdkaac
	flac
	inotify
	lame
	liquidsoap.${LIQUIDSOAP_VERSION}
	mad
	ogg
	opus
	samplerate
	ssl
	taglib
	vorbis
	xmlplaylist
)

export DEBIAN_FRONTEND=noninteractive

sudo apt-get update
sudo apt-get install --no-install-recommends -y lsb-release
echo "deb http://deb.debian.org/debian $(lsb_release -cs) non-free" |
	sudo tee /etc/apt/sources.list.d/non-free.list

sudo apt-get update
sudo apt-get install --no-install-recommends -y "${dev_packages[@]}" "${system_deps[@]}"

# The image comes with a local repo with no recent state. Re-add the
# official repo on https://opam.ocaml.org in order to get updates...
opam repo add official https://opam.ocaml.org

opam update
eval $(opam config env)
opam install -y "${ocaml_deps[@]}"

sudo apt-get remove --purge -y "${dev_packages[@]}"
sudo apt-get autoremove --purge -y

# Install dumb-init
sudo curl -sSfLo /usr/bin/dumb-init \
	"https://github.com/Yelp/dumb-init/releases/download/v${DUMB_INIT_VERSION}/dumb-init_${DUMB_INIT_VERSION}_amd64"
sudo chmod 0755 /usr/bin/dumb-init
