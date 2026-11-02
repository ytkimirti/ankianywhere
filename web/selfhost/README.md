# Your own Anki Anywhere

This folder deploys your own copy of [Anki Anywhere](https://github.com/ytkimirti/ankianywhere)
to Vercel: the app on your own domain, with your own AnkiWeb proxy, so your
AnkiWeb login and reviews go through no server but yours.

The build step downloads the newest prebuilt site from the project's
releases; nothing is compiled. To update, redeploy the project in Vercel
(Deployments > ... > Redeploy). To pin a build, set the
`ANKIANYWHERE_BUILD_URL` environment variable to another release's
`ankianywhere-web.tar.gz`.

Card HTML runs on the app's own domain here, as it does in desktop Anki, so
only study shared decks whose card scripts you trust.
