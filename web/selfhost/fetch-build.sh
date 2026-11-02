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
# vercel.json as JSON, and only the keys the build's copy has: Vercel may
# reformat it and add keys on upload. Plain sh and node, since its build
# image has no cmp or diff.
same_json() {
    node -e '
        const fs = require("fs");
        const [want, have] = process.argv.slice(1).map((f) => JSON.parse(fs.readFileSync(f, "utf8")));
        const same = Object.keys(want).every((key) => JSON.stringify(want[key]) === JSON.stringify(have[key]));
        process.exit(same ? 0 : 1);
    ' "$1" "$2"
}
same_text() {
    [ "$(cat "$1")" = "$(cat "$2")" ]
}
for check in "same_json vercel.json" "same_text api/ankiweb-proxy.js"; do
    set -- $check
    if ! "$1" "download/selfhost/$2" "$2" 2>/dev/null; then
        echo "This build needs a newer $2. Copy vercel.json and api/ from"
        echo "https://github.com/ytkimirti/ankianywhere/tree/main/web/selfhost into this repository."
        exit 1
    fi
done
mv download/site build
rm -rf download
echo "Fetched build $(cat build/BUILD)"
