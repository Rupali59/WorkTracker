# How to Update Your Quartz Digital Garden

This repository was created from the [Quartz template](https://github.com/jackyzha0/quartz). To sync updates from the original Quartz repository, follow these steps:

## Quick Update (Using Script)

1. Run the sync script:
   ```bash
   chmod +x scripts/sync-updates.sh
   ./scripts/sync-updates.sh
   ```

2. Review any changes and resolve conflicts if needed

3. Push updates to your repository:
   ```bash
   git push origin v4
   ```

## Manual Update Steps

### 1. Fetch Latest Changes
```bash
git fetch upstream
```

### 2. Merge Updates
```bash
git checkout v4
git merge upstream/v4
```

### 3. Handle Conflicts (if any)
If you see conflicts, resolve them:
```bash
# Edit conflicted files
# Then stage and commit:
git add .
git commit -m "Merge upstream Quartz updates"
```

### 4. Push to Your Repository
```bash
git push origin v4
```

## Understanding Conflicts

- **Your content** (`content/` folder) typically won't conflict - it's unique to your garden
- **Config files** (`quartz.config.ts`, `quartz.layout.ts`) may conflict if you've customized them
- **Core Quartz files** (`quartz/` folder) rarely need customization, so conflicts here are uncommon

## Best Practices

1. **Keep your customizations separate**: If possible, avoid modifying core Quartz files
2. **Commit your content regularly**: Your markdown files in `content/` are safe
3. **Review before merging**: Always check what changed before merging upstream updates
4. **Test locally**: After merging, test your site locally before pushing

## Checking What Changed

Before merging, see what updates are available:
```bash
git fetch upstream
git log HEAD..upstream/v4 --oneline
```

To see detailed changes:
```bash
git diff v4 upstream/v4
```

