#!/bin/sh
# Downloads the prebuilt Anki Anywhere site into build/. Each deploy fetches
# the newest build; set ANKIANYWHERE_BUILD_URL to pin another one.
set -eu
url="${ANKIANYWHERE_BUILD_URL:-https://github.com/ytkimirti/ankianywhere/releases/download/web-latest/ankianywhere-web.tar.gz}"
rm -rf build
mkdir build
curl -sSfL --retry 3 "$url" | tar xz -C build
test -f build/index.html
echo "Fetched $(cat build/BUILD 2>/dev/null || echo "$url")"
