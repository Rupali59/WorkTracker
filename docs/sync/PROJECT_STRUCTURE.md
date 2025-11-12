# Project Structure

This document outlines the organization of the WorkTracker Quartz digital garden repository.

## Directory Structure

```
WorkTracker/
├── .github/
│   └── workflows/
│       └── daily-sync.yml          # GitHub Actions workflow for automated syncing
│
├── content/                        # Your markdown content (digital garden notes)
│
├── docs/                           # Documentation
│   ├── sync/                      # Custom sync documentation (won't conflict with upstream)
│   │   ├── syncing-updates.md    # Overview of sync methods
│   │   ├── UPDATE_GUIDE.md        # Manual update instructions
│   │   ├── SETUP_DAILY_SYNC.md    # Automatic sync setup guide
│   │   └── PROJECT_STRUCTURE.md   # This file - project organization
│   └── ...                        # Quartz documentation (from upstream)
│
├── quartz/                         # Quartz core files (don't modify)
│   ├── components/                # React components
│   ├── plugins/                   # Quartz plugins
│   └── ...
│
├── scripts/                        # Sync and utility scripts
│   ├── daily-sync.sh              # Automated daily sync script
│   ├── sync-updates.sh            # Manual sync script
│   ├── config/
│   │   └── com.worktracker.dailysync.plist  # Launchd configuration
│   └── README.md                  # Scripts documentation
│
├── .gitignore                      # Git ignore rules (includes .sync.log)
├── package.json                    # Node.js dependencies
├── quartz.config.ts               # Quartz configuration
├── quartz.layout.ts               # Layout configuration
│
└── README.md                       # Main project README
```

## Key Files

### Sync Scripts
- **`scripts/daily-sync.sh`** - Fully automated sync (fetches, merges, pushes)
- **`scripts/sync-updates.sh`** - Manual sync (requires manual push)

### Configuration
- **`scripts/config/com.worktracker.dailysync.plist`** - macOS launchd config
- **`.github/workflows/daily-sync.yml`** - GitHub Actions workflow

### Documentation
- **`docs/sync/UPDATE_GUIDE.md`** - How to manually sync updates
- **`docs/sync/SETUP_DAILY_SYNC.md`** - How to set up automatic daily syncing
- **`docs/sync/syncing-updates.md`** - Overview and quick reference
- **`docs/sync/PROJECT_STRUCTURE.md`** - Project organization guide

> **Note**: All sync-related documentation is in `docs/sync/` to avoid conflicts with upstream Quartz documentation in `docs/`.

## Logs

Sync operations create log files in the project root:
- `.sync.log` - Standard output log
- `.sync-error.log` - Error log (launchd only)

These are automatically ignored by git (see `.gitignore`).

## Best Practices

1. **Don't modify** files in `quartz/` directory
2. **Keep your content** in `content/` directory
3. **Customize** `quartz.config.ts` and `quartz.layout.ts` as needed
4. **Use scripts** in `scripts/` for syncing updates
5. **Review logs** in `.sync.log` after automated syncs

