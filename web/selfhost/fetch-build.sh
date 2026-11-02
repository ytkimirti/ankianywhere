#!/bin/sh
# Downloads the newest prebuilt Anki Anywhere site into build/. The download
# also carries the vercel.json and proxy it was built for; when they differ
# from this copy's, the build stops, so Vercel keeps serving the previous
# deployment until this copy's files are updated from web/selfhost.
set -eu
url="${ANKIANYWHERE_BUILD_URL:-https://github.com/ytkimirti/ankianywhere/releases/download/web-latest/ankianywhere-web.tar.gz}"
rm -rf build download
mkdir download
curl -sSfL --retry 5 --retry-all-errors --retry-delay 5 "$url" | tar xz -C download
if [ ! -f download/site/index.html ] || [ ! -d download/selfhost ]; then
    echo "$url is not an Anki Anywhere build."
    exit 1
fi
for file in vercel.json api/ankiweb-proxy.js; do
    if ! cmp -s "download/selfhost/$file" "$file"; then
        echo "This build needs a newer $file. Copy vercel.json and api/ from"
        echo "https://github.com/ytkimirti/ankianywhere/tree/main/web/selfhost into this repository."
        exit 1
    fi
done
mv download/site build
rm -rf download
echo "Fetched build $(cat build/BUILD)"
