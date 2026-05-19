# artifact-share releases

Distribution repo for [artifact-share](https://github.com/Cometa-Labs/artifact-share) — the Cometa MCP server for sharing HTML artifacts via Google Drive.

Binary releases are attached to GitHub releases. `version.json` is the manifest the `update_server` MCP tool reads to check for and apply updates.

## Releasing a new version

1. Bump the version in `artifact-share/package.json`
2. In `artifact-share`, run `npm run build` — outputs `dist/artifact-share` (arm64) and `dist/artifact-share-x64`
3. Create a GitHub release on this repo tagged `v<version>`, attach both binaries as assets
4. Update `version.json` in this repo:
   ```json
   {
     "version": "<new version>",
     "binaries": {
       "darwin-arm64": "https://github.com/Cometa-Labs/artifact-share-release/releases/download/v<new version>/artifact-share",
       "darwin-x64":   "https://github.com/Cometa-Labs/artifact-share-release/releases/download/v<new version>/artifact-share-x64"
     }
   }
   ```
5. Commit and push — the update is live immediately

## First-time install

**Preferred — one-liner in Terminal:**

```bash
curl -fsSL https://raw.githubusercontent.com/Cometa-Labs/artifact-share-release/main/install.sh | bash
```

Auto-detects Apple Silicon vs Intel, downloads the right binary, and runs setup. Then restart Claude Desktop.

**Manual fallback:**

1. Download the right binary from the [Releases](https://github.com/Cometa-Labs/artifact-share-release/releases/latest) tab:
   - `artifact-share` — Apple Silicon (M1/M2/M3)
   - `artifact-share-x64` — Intel Mac
2. In Terminal:
   ```bash
   chmod +x ~/Downloads/artifact-share
   xattr -d com.apple.quarantine ~/Downloads/artifact-share
   ~/Downloads/artifact-share setup
   ```
3. Restart Claude Desktop

After install, updates happen automatically via the `update_server` tool in Claude Desktop — no re-running setup, no full app restart.
