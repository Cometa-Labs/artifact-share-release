# artifact-share releases

Distribution repo for [artifact-share](https://github.com/Cometa-Labs/artifact-share) — the Cometa MCP server for sharing HTML artifacts via Google Drive.

Binary releases are attached to GitHub releases. `version.json` is the version manifest — the running MCP server fetches this in the background to detect when a new version is available.

## First-time install

**One-liner in Terminal:**

```bash
curl -fsSL https://raw.githubusercontent.com/Cometa-Labs/artifact-share-release/main/install.sh | bash
```

Auto-detects Apple Silicon vs Intel, downloads the right binary, strips Gatekeeper quarantine, and registers the server in Claude Desktop and Claude CLI. Then restart Claude Desktop or reload Claude CLI.

**Clean install** — clears saved Google auth token and folder history, then reinstalls (useful when switching accounts or fixing auth issues):

```bash
curl -fsSL https://raw.githubusercontent.com/Cometa-Labs/artifact-share-release/main/install.sh | bash -s -- --clean
curl -fsSL https://raw.githubusercontent.com/Cometa-Labs/artifact-share-release/main/install.sh | bash
```

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
3. Restart Claude Desktop or reload Claude CLI

## How updates work

The running server silently checks `version.json` at most once every 30 minutes. When a newer version is detected, it appends a notice to the next Claude tool response — you'll see something like:

> **artifact-share update available** (0.0.2 → 0.0.3)
> To apply: restart Claude Desktop to load the new binary.

Tell Claude "update artifact-share" and it downloads and installs the new binary atomically to `~/.local/bin/artifact-share`. Then restart Claude Desktop.

## Releasing a new version

**Preferred — use the release skill in Claude Code (in the source repo):**

1. Bump the version in `package.json`
2. Say `release` (or `/release`) in Claude Code

The skill builds both binaries, creates this GitHub release with assets attached, updates `version.json` here, and pushes — all in one step. The update is live immediately after the push.

**Manual fallback:**

1. Bump the version in `artifact-share/package.json`
2. Run `npm run build` — outputs `dist/artifact-share` (arm64) and `dist/artifact-share-x64`
3. Create a GitHub release on this repo tagged `v<version>`, attach both binaries
4. Update `version.json`:
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
