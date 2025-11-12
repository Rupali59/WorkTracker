# Local Preview Guide

When previewing your Quartz site locally, you may encounter 404 errors because the `baseUrl` includes the repository path (`/WorkTracker`). This guide explains how to preview locally.

## The Issue

Your `baseUrl` is set to `rupali59.github.io/WorkTracker` for GitHub Pages deployment. When serving locally, Quartz generates paths with this prefix, causing 404 errors.

## Solution: Use the Preview Script

Use the provided preview script that handles local serving:

```bash
./scripts/preview.sh
```

This script uses Quartz's built-in serve command with the correct `--baseDir` flag to match your GitHub Pages subdirectory path. It will:
1. Build your site (`npx quartz build`)
2. Start a local server with hot-reload on port 8080
3. Properly handle the `/WorkTracker` base path

Visit `http://localhost:8080/WorkTracker` in your browser.

**⚠️ Important**: 
- ✅ **Correct**: `http://localhost:8080/WorkTracker`
- ❌ **Wrong**: `http://localhost:8080` (will show 404)

The 404 error for `/` is expected - you must include `/WorkTracker` in the URL to match your GitHub Pages deployment path.

## Manual Preview

If you prefer to preview manually, use Quartz's built-in serve command:

### Option 1: Quartz Built-in Serve (Recommended)

```bash
# Build and serve with correct baseDir
npx quartz build --serve --baseDir "/WorkTracker" --port 8080
```

Visit `http://localhost:8080/WorkTracker`

### Option 2: Python HTTP Server (Alternative)

```bash
# Build first
npx quartz build

# Serve from public directory
cd public
python3 -m http.server 8080
```

Visit `http://localhost:8080` (note: paths may not match production exactly)

### Option 3: Using npx serve

```bash
# Build first
npx quartz build

# Serve
npx serve public -p 8080
```

### Option 3: Using Node.js http-server

```bash
# Install globally (one time)
npm install -g http-server

# Build and serve
npx quartz build
http-server public -p 8080
```

## Important Notes

1. **Always build first**: Run `npx quartz build` before previewing
2. **baseUrl is correct**: The `baseUrl` setting (`rupali59.github.io/WorkTracker`) is correct for GitHub Pages deployment
3. **Local preview limitations**: Some features (like RSS feeds) may not work perfectly locally due to absolute URL requirements
4. **GitHub Pages**: Once deployed, your site will work correctly at `https://rupali59.github.io/WorkTracker`

## Troubleshooting

### 404 Errors on Resources

If you see 404 errors for CSS/JS files:
- Make sure you're serving from the `public/` directory
- Check that `npx quartz build` completed successfully
- Verify files exist in `public/` directory

### Port Already in Use

If port 8080 is busy:
```bash
# Use a different port
python3 -m http.server 8081
# Then visit http://localhost:8081
```

### Changes Not Showing

After editing content:
1. Rebuild: `npx quartz build`
2. Refresh your browser (hard refresh: Cmd+Shift+R or Ctrl+Shift+R)

## Production vs Local

- **Local**: Serve from `public/` directory root
- **Production**: GitHub Pages serves from `https://rupali59.github.io/WorkTracker/`

The `baseUrl` configuration ensures correct absolute URLs in production (RSS, sitemaps, etc.) while Quartz uses relative URLs for most resources, making local preview work.

