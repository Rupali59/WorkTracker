# Resolving Build Warnings

When building your Quartz site, you may see warnings like:

```
Warning: content/2025/January/01-01-2025.md isn't yet tracked by git, dates will be inaccurate
```

## Why These Warnings Appear

These warnings occur because:
1. **Files aren't tracked by git yet** - Quartz uses git history to determine file creation/modification dates
2. **No git history** - Without git tracking, Quartz falls back to filesystem dates, which may be inaccurate

## How to Resolve

### Step 1: Add Files to Git

```bash
# Add all content files
git add content/

# Or add everything
git add .
```

### Step 2: Commit the Files

```bash
git commit -m "Add Work Tracker content from Obsidian Calendar"
```

### Step 3: Rebuild

After committing, rebuild your site:

```bash
npx quartz build
```

The warnings should disappear because Quartz can now use git history for accurate dates.

## Understanding the Warnings

- **Not critical**: Your site will still build and work correctly
- **Date accuracy**: Dates shown on pages may be based on filesystem timestamps instead of git history
- **Temporary**: Once files are committed, future builds won't show these warnings

## Index.md Warning

If you see:
```
Warning: you seem to be missing an `index.md` home page file
```

But you've created `content/index.md`:
- This is usually a timing issue during the build
- Verify the file exists: `ls content/index.md`
- Rebuild: `npx quartz build`
- The warning should disappear on the next build

## Best Practice

Always commit your content before building for production:

```bash
# 1. Sync content
./scripts/sync-content.sh

# 2. Add and commit
git add content/
git commit -m "Update content"

# 3. Build
npx quartz build

# 4. Sync to GitHub
npx quartz sync
```

This ensures:
- ✅ Accurate dates from git history
- ✅ No warnings during build
- ✅ Proper version control
- ✅ Clean deployment

