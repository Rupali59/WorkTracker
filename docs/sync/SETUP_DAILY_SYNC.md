# Setting Up Daily Automatic Sync

This guide shows you how to set up automatic daily syncing of updates from the Quartz upstream repository.

## Prerequisites

- The `daily-sync.sh` script must be executable
- You need to have SSH keys set up for GitHub (or use a personal access token)

## Option 1: Using Cron (macOS/Linux)

### Step 1: Make the script executable
```bash
chmod +x scripts/daily-sync.sh
```

### Step 2: Edit your crontab
```bash
crontab -e
```

### Step 3: Add a daily job
Add this line to run the sync every day at 2 AM:
```cron
0 2 * * * /Users/rupali.b/Documents/GitHub/WorkTracker/scripts/daily-sync.sh
```

Or to run at a different time, adjust the format:
- `0 2 * * *` = 2:00 AM daily
- `0 9 * * *` = 9:00 AM daily
- `0 */6 * * *` = Every 6 hours

### Step 4: Verify cron is running (macOS)
On macOS, you may need to grant Terminal/iTerm full disk access:
1. System Settings → Privacy & Security → Full Disk Access
2. Add Terminal (or iTerm if you use it)

## Option 2: Using launchd (macOS - Recommended)

Launchd is the native macOS task scheduler and is more reliable than cron.

### Step 1: Create a plist file

Copy the plist file from `scripts/config/com.worktracker.dailysync.plist` to `~/Library/LaunchAgents/`:

```bash
cp scripts/config/com.worktracker.dailysync.plist ~/Library/LaunchAgents/
```

Or create `~/Library/LaunchAgents/com.worktracker.dailysync.plist` manually:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.worktracker.dailysync</string>
    <key>ProgramArguments</key>
    <array>
        <string>/Users/rupali.b/Documents/GitHub/WorkTracker/scripts/daily-sync.sh</string>
    </array>
    <key>StartCalendarInterval</key>
    <dict>
        <key>Hour</key>
        <integer>2</integer>
        <key>Minute</key>
        <integer>0</integer>
    </dict>
    <key>StandardOutPath</key>
    <string>/Users/rupali.b/Documents/GitHub/WorkTracker/.sync.log</string>
    <key>StandardErrorPath</key>
    <string>/Users/rupali.b/Documents/GitHub/WorkTracker/.sync-error.log</string>
    <key>RunAtLoad</key>
    <false/>
</dict>
</plist>
```

### Step 2: Load the launchd job
```bash
launchctl load ~/Library/LaunchAgents/com.worktracker.dailysync.plist
```

### Step 3: Verify it's loaded
```bash
launchctl list | grep com.worktracker.dailysync
```

### Step 4: Test it manually (optional)
```bash
launchctl start com.worktracker.dailysync
```

### To unload (if needed):
```bash
launchctl unload ~/Library/LaunchAgents/com.worktracker.dailysync.plist
```

## Option 3: Using GitHub Actions (Recommended for Cloud)

If you want the sync to happen in the cloud (even when your computer is off), use GitHub Actions.

### Step 1: Create workflow file

Create `.github/workflows/daily-sync.yml`:

```yaml
name: Daily Sync from Quartz

on:
  schedule:
    # Runs daily at 2 AM UTC
    - cron: '0 2 * * *'
  workflow_dispatch: # Allows manual triggering

jobs:
  sync:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout repository
        uses: actions/checkout@v4
        with:
          fetch-depth: 0
          token: ${{ secrets.GITHUB_TOKEN }}

      - name: Setup Git
        run: |
          git config user.name "github-actions[bot]"
          git config user.email "github-actions[bot]@users.noreply.github.com"

      - name: Add upstream remote
        run: |
          git remote add upstream https://github.com/jackyzha0/quartz.git || true
          git fetch upstream

      - name: Merge upstream changes
        run: |
          git checkout v4
          git merge upstream/v4 --no-edit || exit 0

      - name: Push changes
        run: |
          git push origin v4 || exit 0
```

### Step 2: Commit and push
```bash
git add .github/workflows/daily-sync.yml
git commit -m "Add daily sync workflow"
git push origin v4
```

## Monitoring

### Check sync logs
```bash
cat /Users/rupali.b/Documents/GitHub/WorkTracker/.sync.log
```

### Check for errors
```bash
cat /Users/rupali.b/Documents/GitHub/WorkTracker/.sync-error.log
```

### Manual sync (if needed)
```bash
./scripts/daily-sync.sh
```

## Troubleshooting

### Merge Conflicts
If there are merge conflicts, the script will log them. You'll need to:
1. Resolve conflicts manually
2. Commit the resolution
3. Push to origin

### Authentication Issues
If pushing fails, ensure:
- SSH keys are set up: `ssh -T git@github.com`
- Or use a personal access token in the remote URL

### Script Permissions
If you get "Permission denied":
```bash
chmod +x scripts/daily-sync.sh
```

## Recommendations

- **For local development**: Use launchd (Option 2) on macOS
- **For cloud/always-on**: Use GitHub Actions (Option 3)
- **For simple setups**: Use cron (Option 1)

