import chalk from "chalk";
import path from "path";
import { createRequire } from "module";
const require = createRequire(import.meta.url);

import requestOAuthToken from "./getAccessToken.js";

const environment = process.env.NODE_ENV || "dev";
const PORT = process.env.PORT || 12451;
const configPath = path.resolve(`../../config/${environment}.json`);
console.log(chalk.blue(`Loading configuration from ${configPath}`));
const config = require(configPath);

const { client_id: CLIENT_ID, client_secret: CLIENT_SECRET } = config;

const response = await requestOAuthToken(CLIENT_ID, CLIENT_SECRET, PORT);
console.log(response);
