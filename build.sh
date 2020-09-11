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
realmandir="/usr/share/man/man1"
mandir="${builddir}/${realmandir}"
mkdir -p "${mandir}"
pandoc --standalone --to man README.md -o "${mandir}/${cmdname}.1"

# Bin
realbindir="/usr/bin"
bindir="${builddir}/${realbindir}"
mkdir -p "${bindir}"
cp "./${cmdname}" "${bindir}/"

# Config
realconfdir="/etc/xdg/${cmdname}"
confdir="${builddir}/${realconfdir}"
mkdir -p "${confdir}"
cp "./${cmdname}.config" "${confdir}/"

# Lib
reallibdir="/usr/lib/${cmdname}"
libdir="${builddir}/${reallibdir}"
mkdir -p "${libdir}"
cp  ./lib/* "${libdir}/"

# Data
realdatadir="/usr/share/${cmdname}"
datadir="${builddir}/${realdatadir}/data"
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

echo "#!/usr/bin/env bash
  # This script creates the proper ownership/mode for Splatmoji's files after installation because I could not get fpm to do it by its own means :/

  chown root:root '${realmandir}/${cmdname}.1'
  chmod 0644 '${realmandir}/${cmdname}.1'

  chown root:root '${realbindir}/${cmdname}'
  chmod 0755 '${realbindir}/${cmdname}'

  find '${realconfdir}' -exec chown root:root {} \;
  find '${realconfdir}' -type f -exec chmod 0644 {} \;

  find '${reallibdir}' -exec chown root:root {} \;
  find '${reallibdir}' -type f -exec chmod 0644 {} \;

  find '${realdatadir}' -exec chown root:root {} \;
  find '${realdatadir}' -type f -exec chmod 0644 {} \;

" > "${builddir}/splatmoji-postinstall-ownership.sh"

fpm \
  --after-install "${builddir}/splatmoji-postinstall-ownership.sh" \
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
  --verbose \
  \
  "${builddir}/"=/
