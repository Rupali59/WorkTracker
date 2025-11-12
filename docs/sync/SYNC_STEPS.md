# Step-by-Step Content Sync Guide

Follow these steps to sync your content using Quartz's built-in sync command, as documented at [quartz.jzhao.xyz](https://quartz.jzhao.xyz/).

## ✅ Step 1: Verify Setup

Your environment is ready:
- ✅ Node.js v24.10.0 installed
- ✅ npm v11.6.0 installed  
- ✅ Dependencies installed (`npm install` completed)
- ✅ Content copied to `content/` directory (221 markdown files)
- ✅ Git remotes configured (origin + upstream)

## ✅ Step 2: Build Your Site

Build your site to ensure everything works:

```bash
cd /Users/rupali.b/Documents/GitHub/WorkTracker
npx quartz build
```

Expected output:
- ✅ Found 221 input files from `content`
- ✅ Build completes successfully
- ✅ `public/` directory created

**Note**: Warnings about files not tracked by git are normal for new files. They'll be resolved after the first sync.

## ✅ Step 3: Preview Locally (Optional)

Preview your site before syncing:

```bash
./scripts/preview.sh
```

Or manually:
```bash
npx quartz build
cd public
python3 -m http.server 8080
```

Visit `http://localhost:8080` in your browser to see your site.

Press `Ctrl+C` to stop the preview server.

**Note**: See [docs/sync/LOCAL_PREVIEW.md](./docs/sync/LOCAL_PREVIEW.md) for detailed preview instructions.

## ✅ Step 4: Sync with GitHub

According to [Quartz documentation](https://quartz.jzhao.xyz/setting-up-your-GitHub-repository), use the sync command:

### First Time Sync (Initial Push)

```bash
npx quartz sync --no-pull
```

This command will:
1. ✅ Back up your content folder
2. ✅ Stage all changes (`git add .`)
3. ✅ Create a commit with timestamp
4. ✅ Push to your GitHub repository (`origin v4`)

### What Happens During Sync

The `npx quartz sync` command:
- **Backs up** your content folder (handles symlinks if present)
- **Commits** changes with message: `Quartz sync: [timestamp]`
- **Pulls** updates from GitHub (if `--pull` is enabled)
- **Pushes** your changes to GitHub (if `--push` is enabled)

## ✅ Step 5: Verify Sync

Check that your changes are on GitHub:

```bash
git log --oneline -5
git status
```

You should see:
- ✅ New commit: "Quartz sync: [timestamp]"
- ✅ Clean working directory
- ✅ Content pushed to `origin v4`

## 🔄 Regular Content Updates Workflow

For future content updates, follow this workflow:

### Option 1: Using Quartz Sync (Recommended)

```bash
# 1. Update content in Obsidian Calendar
# 2. Copy to WorkTracker
./scripts/sync-content.sh

# 3. Build and test
npx quartz build
npx quartz serve  # Optional: preview at http://localhost:8080

# 4. Sync with GitHub
npx quartz sync
```

### Option 2: Manual Git Workflow

```bash
# 1. Update content in Obsidian Calendar
# 2. Copy to WorkTracker
./scripts/sync-content.sh

# 3. Commit and push manually
git add content/
git commit -m "Update content from Obsidian Calendar"
git push origin v4
```

## 📋 Sync Command Options

```bash
# Sync without pulling updates first (faster for first sync)
npx quartz sync --no-pull

# Sync without committing (just pull/push)
npx quartz sync --no-commit

# Sync without pushing (just commit locally)
npx quartz sync --no-push

# Custom commit message
npx quartz sync --message "Update work tracker - November 2025"

# Verbose output
npx quartz sync --verbose
```

## 🚀 After Syncing

Once synced:
1. ✅ GitHub Actions will automatically build and deploy
2. ✅ Your site will be available at: `https://rupali59.github.io/WorkTracker`
3. ✅ Check deployment status in the GitHub Actions tab

## 📚 Additional Resources

- [Quartz Documentation](https://quartz.jzhao.xyz/)
- [Setting up GitHub Repository](https://quartz.jzhao.xyz/setting-up-your-GitHub-repository)
- [Content Sync Guide](./docs/sync/CONTENT_SYNC.md)
- [Quartz Sync Guide](./docs/sync/QUARTZ_SYNC_GUIDE.md)

## ⚠️ Troubleshooting

### Build Errors
```bash
# Clean and rebuild
rm -rf .quartz-cache public
npx quartz build
```

### Sync Conflicts
```bash
# Resolve conflicts manually
git status
# Edit conflicted files, then:
git add .
git commit -m "Resolve conflicts"
npx quartz sync --no-pull
```

### Content Not Appearing
- Check files are `.md` format
- Verify files aren't in ignored directories (`.obsidian`, `.space`)
- Check `ignorePatterns` in `quartz.config.ts`

