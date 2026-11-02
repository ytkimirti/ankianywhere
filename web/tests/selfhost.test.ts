// Copyright: Ankitects Pty Ltd and contributors
// License: GNU AGPL, version 3 or later; http://www.gnu.org/licenses/agpl.html

// @ts-nocheck: run with `bun test web/tests`; bun:test has no types in this repo

import { expect, test } from "bun:test";
import { readFileSync } from "node:fs";

const read = (path: string) => readFileSync(new URL(path, import.meta.url), "utf8");

test("the self-hosting template routes and proxies like the main deployment", () => {
    const main = JSON.parse(read("../vercel.json"));
    const selfhost = JSON.parse(read("../selfhost/vercel.json"));
    for (const key of ["buildCommand", "outputDirectory", "installCommand", "framework"]) {
        delete selfhost[key];
    }
    expect(selfhost).toEqual(main);
    expect(read("../selfhost/api/ankiweb-proxy.js")).toBe(read("../api/ankiweb-proxy.js"));
});
