#!/usr/bin/env bash
set -e

version="${1}"
target="${2}"
cmdname=splatmoji

if [ -z "${version}" ]; then
  echo "Please give a version number"
  exit 1
fi

# shellcheck disable=SC2211
./test/*

# Build dir
builddir="${SPLATMOJI_BUILDDIR:-./build}"

# Clean
rm -rf "${builddir:?}"/*

# Docs
mandir="${builddir}/usr/share/man/man1"
mkdir -p "${mandir}"
pandoc --standalone --to man README.md -o "${mandir}/${cmdname}.1"

# Bin
bindir="${builddir}/usr/bin"
mkdir -p "${bindir}"
cp "./${cmdname}" "${bindir}/"

# Config
confdir="${builddir}/etc/xdg/${cmdname}"
mkdir -p "${confdir}"
cp "./${cmdname}.config" "${confdir}/"

# Lib
libdir="${builddir}/usr/lib/${cmdname}"
mkdir -p "${libdir}"
cp  ./lib/* "${libdir}/"

# Data
datadir="${builddir}/usr/share/${cmdname}/data"
mkdir -p "${datadir}"
cp -r ./data/* "${datadir}/"

if [ -n "${target}" ]; then
  true
elif command -v rpm >/dev/null; then
  target='rpm'
elif command -v apt >/dev/null; then
  target='deb'
else
  echo 'Cannot determine target :(' 2>&1
fi
fpm \
  --architecture noarch \
  --depends 'bash > 4.4' \
  --depends 'rofi' \
  --depends 'xdotool' \
  --depends 'xsel' \
  --description 'Quickly look up and input emoji and/or emoticons/kaomoji on your GNU/Linux desktop via pop-up menu.' \
  --input-type dir \
  --maintainer='Christopher Peterson @ ChrisPeterson.info' \
  --name "${cmdname}" \
  --output-type "${target}" \
  --package "${builddir}/" \
  --url 'https://github.com/cspeterson/splatmoji' \
  --version "${version}" \
  \
  "${builddir}/"=/
