const dotenv = require("dotenv");
const path = require("path");
const fs = require("fs");

function loadEnv(root, exclude = [], isProd = false) {
    let env = {};

    if (isProd) env = { ...process.env };
    else {
        const envPath = path.join(root, ".env");
        const result = dotenv.config({ path: envPath });
        env = result.parsed || {};
    }

    const filtered = {};
    for (const key in env) {
        if (!exclude.includes(key)) filtered[key] = env[key];
    }

    return filtered;
}

function getEnvVar(key, env = {}) {
    return env[key];
}

function createOrModifyFile(filePath, content) {
    fs.writeFileSync(filePath, content, "utf8");
}

module.exports = { loadEnv, getEnvVar, createOrModifyFile };
