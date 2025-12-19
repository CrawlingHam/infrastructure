const { TFConfig } = require("./configs");
const { file } = require("./utils");
const path = require("path");

const root = path.join(__dirname, "..");

const env = file.loadEnv(root);

TFConfig(env, root);
