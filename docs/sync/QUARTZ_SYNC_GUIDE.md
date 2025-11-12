# Quartz Content Sync Guide

This guide follows the official [Quartz documentation](https://quartz.jzhao.xyz/) for syncing content step by step.

## Prerequisites

✅ Node.js v22+ installed (you have v24.10.0)  
✅ npm v10.9.2+ installed (you have v11.6.0)  
✅ Dependencies installed (`npm install` completed)

## Step-by-Step Content Sync Process

### Step 1: Verify Your Content is Ready

Your Obsidian Calendar content is already copied to the `content/` directory:
```bash
# Check content
ls -la content/
```

### Step 2: Build Your Site Locally

Before syncing, build and preview your site to ensure everything works:

```bash
# Build the site
npx quartz build

# Preview locally (optional)
npx quartz serve
```

Visit `http://localhost:8080` to preview your site.

### Step 3: Sync Content with GitHub

According to [Quartz documentation](https://quartz.jzhao.xyz/setting-up-your-GitHub-repository), use the built-in sync command:

#### First Time Sync (Initial Push)
```bash
npx quartz sync --no-pull
```

This will:
- Back up your content folder
- Commit all changes to git
- Push to your GitHub repository

#### Future Syncs (Regular Updates)
```bash
npx quartz sync
```

This will:
- Pull latest changes from GitHub
- Merge with your local changes
- Commit and push updates

### Step 4: Sync Options

The `npx quartz sync` command supports several options:

```bash
# Sync without pulling updates first
npx quartz sync --no-pull

# Sync without committing (just pull/push)
npx quartz sync --no-commit

# Sync without pushing (just commit locally)
npx quartz sync --no-push

# Custom commit message
npx quartz sync --message "Update work tracker content"
```

## Content Workflow

### Option A: Using Quartz Sync Command (Recommended)

1. **Edit content** in your Obsidian Calendar directory
2. **Copy content** to WorkTracker:
   ```bash
   ./scripts/sync-content.sh
   ```
3. **Build and test**:
   ```bash
   npx quartz build
   npx quartz serve  # Preview at http://localhost:8080
   ```
4. **Sync with GitHub**:
   ```bash
   npx quartz sync
   ```

### Option B: Using Git Directly

1. **Edit content** in your Obsidian Calendar directory
2. **Copy content**:
   ```bash
   ./scripts/sync-content.sh
   ```
3. **Commit and push manually**:
   ```bash
   git add content/
   git commit -m "Update content from Obsidian Calendar"
   git push origin v4
   ```

## Understanding Quartz Sync

According to the [Quartz documentation](https://quartz.jzhao.xyz/setting-up-your-GitHub-repository):

- **`npx quartz sync`** handles the complete workflow: backup → pull → commit → push
- It automatically handles symlinks if your content folder is a symlink
- It creates backup commits before pulling updates
- It merges upstream changes with your local content

## Symlink Support

If you want to use a symlink to your Obsidian Calendar (so content stays in sync automatically):

```bash
# Remove existing content folder
rm -rf content/

# Create symlink
ln -s /Users/rupali.b/Documents/GitHub/Obsidian/Calendar content

# Quartz sync will handle the symlink automatically
npx quartz sync
```

**Note**: With symlinks, Quartz will dereference the symlink before committing, then restore it after.

## Troubleshooting

### Sync Conflicts
If you encounter conflicts during sync:
```bash
# Resolve conflicts manually
git status
# Edit conflicted files
git add .
git commit -m "Resolve sync conflicts"
npx quartz sync --no-pull
```

### Content Not Appearing
1. Check that files are `.md` format
2. Verify files aren't ignored (check `ignorePatterns` in `quartz.config.ts`)
3. Rebuild: `npx quartz build`

### Build Errors
```bash
# Clean and rebuild
rm -rf .quartz-cache public
npx quartz build
```

## Next Steps

After syncing:
1. Your GitHub Actions workflow will automatically build and deploy
2. Your site will be available at: `https://rupali59.github.io/WorkTracker`
3. Check deployment status in GitHub Actions tab

## References

- [Quartz Documentation](https://quartz.jzhao.xyz/)
- [Setting up GitHub Repository](https://quartz.jzhao.xyz/setting-up-your-GitHub-repository)
- [Authoring Content](https://quartz.jzhao.xyz/authoring-content)
- [Building Quartz](https://quartz.jzhao.xyz/build)

