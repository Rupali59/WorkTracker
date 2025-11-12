# Content Sync Guide

This guide explains how to sync content from your Obsidian Calendar to the WorkTracker Quartz site.

## Content Source

Your content is sourced from:
```
/Users/rupali.b/Documents/GitHub/Obsidian/Calendar
```

This directory contains your daily notes organized by year and month.

## Syncing Content

### Automatic Sync Script

Use the sync script to copy content from Obsidian Calendar to WorkTracker:

```bash
./scripts/sync-content.sh
```

This script will:
- Copy all markdown files from Obsidian Calendar to `content/`
- Preserve the directory structure (year/month organization)
- Exclude `.obsidian` folders and PDF files
- Show you next steps for committing changes

### Manual Sync

If you prefer to sync manually:

```bash
# Copy content
rsync -av --delete \
    --exclude='.obsidian' \
    --exclude='*.pdf' \
    /Users/rupali.b/Documents/GitHub/Obsidian/Calendar/ \
    /Users/rupali.b/Documents/GitHub/WorkTracker/content/
```

## Workflow

1. **Edit content** in your Obsidian Calendar directory
2. **Sync content** using `./scripts/sync-content.sh`
3. **Review changes**: `git status`
4. **Commit**: `git add content/ && git commit -m "Update content"`
5. **Push**: `git push origin v4`
6. **Build & Deploy**: Your GitHub Actions will automatically build and deploy

## Content Structure

Your content is organized as:
```
content/
├── 2024/
│   ├── January/
│   ├── February/
│   └── ...
└── 2025/
    ├── January/
    ├── February/
    └── ...
```

## Obsidian Compatibility

Quartz is configured with `ObsidianFlavoredMarkdown` plugin, which means:
- ✅ Wikilinks `[[Page Name]]` are supported
- ✅ Obsidian-style callouts work
- ✅ Tags and frontmatter are preserved
- ✅ Internal links are automatically resolved

## Notes

- PDF files are excluded by default (you can modify the script if needed)
- `.obsidian` folders are ignored (Quartz config already excludes them)
- The sync script uses `rsync` with `--delete` flag, so files removed from Obsidian will be removed from content too

## Troubleshooting

### Content not appearing
- Check that files are `.md` format
- Verify files aren't in `.obsidian` folders
- Check `ignorePatterns` in `quartz.config.ts`

### Links not working
- Ensure linked pages exist in the content directory
- Check that wikilinks use correct syntax: `[[Page Name]]`
- Verify `CrawlLinks` plugin is enabled in config

