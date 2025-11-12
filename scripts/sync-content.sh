#!/bin/bash
# Sync content from Obsidian Calendar to WorkTracker content folder
# Usage: ./scripts/sync-content.sh

set -e

OBSIDIAN_CALENDAR="/Users/rupali.b/Documents/GitHub/Obsidian/Calendar"
WORKTRACKER_CONTENT="/Users/rupali.b/Documents/GitHub/WorkTracker/content"

echo "🔄 Syncing content from Obsidian Calendar to WorkTracker..."

if [ ! -d "$OBSIDIAN_CALENDAR" ]; then
    echo "❌ Error: Obsidian Calendar directory not found at $OBSIDIAN_CALENDAR"
    exit 1
fi

# Copy content, preserving directory structure
rsync -av --delete \
    --exclude='.obsidian' \
    --exclude='*.pdf' \
    "$OBSIDIAN_CALENDAR/" "$WORKTRACKER_CONTENT/"

echo "✅ Content synced successfully!"
echo ""
echo "📝 Next steps:"
echo "   1. Review changes: git status"
echo "   2. Commit: git add content/ && git commit -m 'Update content from Obsidian Calendar'"
echo "   3. Push: git push origin v4"

