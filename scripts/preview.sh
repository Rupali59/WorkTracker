#!/bin/bash
# Preview Quartz site locally
# Usage: ./scripts/preview.sh

set -e

echo "🔨 Building and serving Quartz site..."
echo ""
echo "🌐 Starting local preview server..."
echo "   Visit: http://localhost:8080"
echo "   (Will automatically redirect to http://localhost:8080/WorkTracker)"
echo ""
echo "   Press Ctrl+C to stop"
echo ""

# Use Quartz's built-in serve command which handles baseDir correctly
# The --baseDir flag matches the GitHub Pages subdirectory path
npx quartz build --serve --baseDir "/WorkTracker" --port 8080

