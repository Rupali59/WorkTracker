# Sync Scripts

This directory contains scripts for syncing updates from the upstream Quartz repository.

## Scripts

- **`daily-sync.sh`** - Automated daily sync script that fetches, merges, and pushes updates from upstream Quartz
- **`sync-updates.sh`** - Manual sync script for on-demand Quartz updates (requires manual push)
- **`sync-content.sh`** - Sync content from Obsidian Calendar to WorkTracker content folder

## Configuration

- **`config/com.worktracker.dailysync.plist`** - Launchd configuration file for macOS automatic scheduling

## Usage

### Quartz Updates Sync
```bash
# Manual sync
./scripts/sync-updates.sh

# Daily automated sync
See `docs/sync/SETUP_DAILY_SYNC.md` for setup instructions.
```

### Content Sync
```bash
# Sync content from Obsidian Calendar
./scripts/sync-content.sh
```

See `docs/sync/CONTENT_SYNC.md` for detailed content sync instructions.

### Local Preview
```bash
# Build and preview site locally
./scripts/preview.sh
```

See `docs/sync/LOCAL_PREVIEW.md` for detailed preview instructions.

## Logs

Sync logs are written to:
- `.sync.log` - Standard output log
- `.sync-error.log` - Error log (if using launchd)

