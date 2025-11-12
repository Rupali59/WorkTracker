#!/bin/bash
# Sync script to pull updates from the original Quartz repository
# Usage: ./sync-updates.sh

set -e

echo "🔄 Fetching latest changes from Quartz upstream..."
git fetch upstream

echo "📥 Merging updates into your repository..."
git checkout v4
git merge upstream/v4

echo "✅ Updates merged successfully!"
echo ""
echo "📝 Review the changes, then push to your repository with:"
echo "   git push origin v4"
echo ""
echo "⚠️  If you have conflicts, resolve them first before pushing."

