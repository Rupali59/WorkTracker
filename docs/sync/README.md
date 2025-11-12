# Sync Documentation

This directory contains documentation for syncing updates from the upstream Quartz repository.

## Files

- **`UPDATE_GUIDE.md`** - Manual sync instructions
- **`SETUP_DAILY_SYNC.md`** - Automatic daily sync setup guide
- **`syncing-updates.md`** - Overview and quick reference
- **`PROJECT_STRUCTURE.md`** - Project organization guide

## Why This Directory?

This directory (`docs/sync/`) is isolated from the main `docs/` folder to prevent conflicts when syncing updates from the upstream Quartz repository. The upstream repository has its own documentation files in `docs/`, so keeping our sync-related documentation in a subdirectory ensures safe merging.

## Related Files

- Sync scripts: `scripts/` directory
- GitHub Actions workflow: `.github/workflows/daily-sync.yml`

