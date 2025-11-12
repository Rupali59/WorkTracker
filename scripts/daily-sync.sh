#!/bin/bash
# Daily sync script to automatically pull updates from Quartz upstream
# This script is designed to run automatically via cron or launchd

set -e

# Change to the repository directory
REPO_DIR="/Users/rupali.b/Documents/GitHub/WorkTracker"
cd "$REPO_DIR" || exit 1

# Log file for tracking sync operations
LOG_FILE="$REPO_DIR/.sync.log"
DATE=$(date '+%Y-%m-%d %H:%M:%S')

# Function to log messages
log() {
    echo "[$DATE] $1" | tee -a "$LOG_FILE"
}

log "🔄 Starting daily sync from Quartz upstream..."

# Fetch latest changes from upstream
log "📥 Fetching updates from upstream..."
if ! git fetch upstream 2>&1 | tee -a "$LOG_FILE"; then
    log "❌ Error: Failed to fetch from upstream"
    exit 1
fi

# Check if there are any updates
LOCAL_COMMIT=$(git rev-parse HEAD)
UPSTREAM_COMMIT=$(git rev-parse upstream/v4)

if [ "$LOCAL_COMMIT" = "$UPSTREAM_COMMIT" ]; then
    log "✅ Already up to date - no changes to merge"
    exit 0
fi

log "📝 New updates available. Merging changes..."

# Switch to v4 branch
git checkout v4

# Merge upstream changes
if git merge upstream/v4 --no-edit 2>&1 | tee -a "$LOG_FILE"; then
    log "✅ Successfully merged upstream changes"
    
    # Push to origin
    log "🚀 Pushing changes to origin..."
    if git push origin v4 2>&1 | tee -a "$LOG_FILE"; then
        log "✅ Successfully pushed to origin"
    else
        log "⚠️  Warning: Failed to push to origin (may need manual intervention)"
    fi
else
    log "⚠️  Warning: Merge conflicts detected - manual resolution required"
    log "   Run 'git status' to see conflicted files"
    exit 1
fi

log "✨ Daily sync completed successfully"

