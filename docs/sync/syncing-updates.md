# Syncing Updates from Quartz

This guide covers how to keep your Quartz digital garden up-to-date with the latest changes from the upstream Quartz repository.

## Quick Links

- [Manual Update Guide](./UPDATE_GUIDE.md) - Step-by-step manual sync instructions
- [Automatic Daily Sync Setup](./SETUP_DAILY_SYNC.md) - Set up automated daily syncing
- [Project Structure](./PROJECT_STRUCTURE.md) - Repository organization guide

## Overview

Your repository was created from the [Quartz template](https://github.com/jackyzha0/quartz). To sync updates:

1. **Manual Sync** - Use `scripts/sync-updates.sh` when you want to update on-demand
2. **Automatic Sync** - Set up daily automatic syncing using cron, launchd, or GitHub Actions

## Repository Structure

```
WorkTracker/
├── scripts/
│   ├── daily-sync.sh          # Automated daily sync script
│   ├── sync-updates.sh        # Manual sync script
│   ├── config/
│   │   └── com.worktracker.dailysync.plist  # Launchd config
│   └── README.md              # Script documentation
├── .github/
│   └── workflows/
│       └── daily-sync.yml     # GitHub Actions workflow
└── docs/
    └── sync/                 # Custom sync docs (isolated from upstream)
        ├── UPDATE_GUIDE.md        # Manual update instructions
        ├── SETUP_DAILY_SYNC.md   # Automatic sync setup guide
        └── syncing-updates.md    # Overview and quick reference
```

## Getting Started

1. **First-time setup**: Add upstream remote (if not already done)
   ```bash
   git remote add upstream https://github.com/jackyzha0/quartz.git
   ```

2. **Choose your sync method**:
   - **Manual**: Run `./scripts/sync-updates.sh` when needed
   - **Automatic**: Follow [SETUP_DAILY_SYNC.md](./SETUP_DAILY_SYNC.md)

## Understanding Conflicts

- ✅ **Safe**: Your content in `content/` folder won't conflict
- ⚠️ **May conflict**: Config files (`quartz.config.ts`, `quartz.layout.ts`) if customized
- ✅ **Rare conflicts**: Core Quartz files in `quartz/` folder

## Monitoring

Check sync logs:
```bash
cat .sync.log
cat .sync-error.log
```

