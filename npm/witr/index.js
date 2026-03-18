#!/usr/bin/env node

const { spawn } = require("child_process");
const os = require("os");
const path = require("path");
const fs = require("fs");
const https = require("follow-redirects").https;
const AdmZip = require("adm-zip");

const VERSION = "0.3.1";
const BASE_URL = `https://github.com/pranshuparmar/witr/releases/download/v${VERSION}`;

const platform = os.platform();
const arch = os.arch();

function resolveAsset() {
  if (platform === "darwin") {
    if (arch === "x64") return { file: "witr-darwin-amd64", binary: "witr-darwin-amd64" };
    if (arch === "arm64") return { file: "witr-darwin-arm64", binary: "witr-darwin-arm64" };
  }

  if (platform === "linux") {
    if (arch === "x64") return { file: "witr-linux-amd64", binary: "witr-linux-amd64" };
    if (arch === "arm64") return { file: "witr-linux-arm64", binary: "witr-linux-arm64" };
  }

  if (platform === "freebsd") {
    if (arch === "x64") return { file: "witr-freebsd-amd64", binary: "witr-freebsd-amd64" };
    if (arch === "arm64") return { file: "witr-freebsd-arm64", binary: "witr-freebsd-arm64" };
  }

  if (platform === "win32") {
    if (arch === "x64") return { file: "witr-windows-amd64.zip", binary: "witr.exe" };
    if (arch === "arm64") return { file: "witr-windows-arm64.zip", binary: "witr.exe" };
  }

  console.error(`Unsupported platform: ${platform} ${arch}`);
  process.exit(1);
}

const { file, binary } = resolveAsset();
const downloadUrl = `${BASE_URL}/${file}`;

const installDir = path.join(os.homedir(), ".witr", `v${VERSION}`);
const binaryPath = path.join(installDir, binary);

function download(url, dest) {
  return new Promise((resolve, reject) => {
    https.get(url, (res) => {
      if (res.statusCode !== 200) {
        reject(new Error(`Download failed: ${res.statusCode}`));
        return;
      }

      fs.mkdirSync(path.dirname(dest), { recursive: true });
      const fileStream = fs.createWriteStream(dest);
      res.pipe(fileStream);

      fileStream.on("finish", () => {
        fileStream.close(resolve);
      });
    }).on("error", reject);
  });
}

async function ensureInstalled() {
  if (fs.existsSync(binaryPath)) return;

  console.log("Downloading witr binary...");
  console.log(downloadUrl);

  const tempPath = path.join(installDir, file);
  await download(downloadUrl, tempPath);

  if (platform === "win32") {
    const zip = new AdmZip(tempPath);
    zip.extractAllTo(installDir, true);
    fs.unlinkSync(tempPath);
  } else {
    fs.renameSync(tempPath, binaryPath);
    fs.chmodSync(binaryPath, 0o755);
  }

  console.log("Installed successfully.");
}

async function run() {
  await ensureInstalled();

  const child = spawn(binaryPath, process.argv.slice(2), {
    stdio: "inherit"
  });

  child.on("exit", (code) => process.exit(code));
}

run();
