#!/bin/bash
set -e -u

PACKAGES=""
PACKAGES+=" ant" # Used by apksigner.
PACKAGES+=" asciidoc"
PACKAGES+=" automake"
PACKAGES+=" bison"
PACKAGES+=" clang" # Used by golang, useful to have same compiler building.
PACKAGES+=" curl" # Used for fetching sources.
PACKAGES+=" flex"
PACKAGES+=" gettext" # Provides 'msgfmt' which the apt build uses.
PACKAGES+=" git" # Used by the neovim build.
PACKAGES+=" help2man"
PACKAGES+=" intltool" # Used by qalc build.
PACKAGES+=" libgdk-pixbuf2.0-dev" # Provides 'gkd-pixbuf-query-loaders' which the librsvg build uses.
PACKAGES+=" libglib2.0-dev" # Provides 'glib-genmarshal' which the glib build uses.
PACKAGES+=" libtool-bin"
PACKAGES+=" lzip"
PACKAGES+=" python3.6"
PACKAGES+=" tar"
PACKAGES+=" unzip"
PACKAGES+=" m4"
PACKAGES+=" openjdk-8-jdk" # Used for android-sdk.
PACKAGES+=" pkg-config"
PACKAGES+=" python-docutils" # For rst2man, used by mpv.
PACKAGES+=" scons"
PACKAGES+=" texinfo"
PACKAGES+=" xmlto"
PACKAGES+=" xutils-dev" # Provides 'makedepend' which the openssl build uses.

# TODO: Validate if all these packages are necessary on host
PACKAGES+=" wget" # For dotnet-coreclr build-android-rootfs.sh
PACKAGES+=" libunwind8" # For dotnet-coreclr
PACKAGES+=" libicu57 libicu-dev" # For dotnet-coreclr
PACKAGES+=" autoconf" # For dotnet-coreclr
PACKAGES+=" libcurl4-openssl-dev" # For dotnet-coreclr

DEBIAN_FRONTEND=noninteractive sudo apt-get install -yq $PACKAGES

sudo mkdir -p /data/data/com.termux/files/usr
sudo chown -R `whoami` /data
