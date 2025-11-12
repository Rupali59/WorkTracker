#!/usr/bin/env python3
"""
Create index.md files in each month folder that redirect to the calendar page.
This prevents Quartz from showing folder listings and ensures clicking a month
shows the calendar directly.
"""

import os
from pathlib import Path

CONTENT_DIR = Path("/Users/rupali.b/Documents/GitHub/WorkTracker/content")

MONTHS = ["January", "February", "March", "April", "May", "June", 
          "July", "August", "September", "October", "November", "December"]

def find_calendar_file(month_dir):
    """Find the calendar file in a month directory"""
    # Look for files that are NOT daily notes (not matching DD-MM-YYYY.md pattern)
    for file in month_dir.glob("*.md"):
        if not file.name.startswith('.') and not file.name[0:2].isdigit():
            return file
    return None

def create_index_file(year, month, calendar_file):
    """Create an index.md file that includes the calendar content"""
    month_dir = CONTENT_DIR / str(year) / month
    index_file = month_dir / "index.md"
    
    # Read the calendar file content
    with open(calendar_file, 'r', encoding='utf-8') as f:
        calendar_content = f.read()
    
    # Extract the title from frontmatter if it exists, or use month/year
    title = f"{month} {year}"
    if calendar_content.startswith('---'):
        # Extract title from frontmatter
        frontmatter_end = calendar_content.find('---', 3)
        if frontmatter_end > 0:
            frontmatter = calendar_content[3:frontmatter_end]
            for line in frontmatter.split('\n'):
                if line.startswith('title:'):
                    title = line.split('title:')[1].strip().strip('"').strip("'")
                    break
    
    # Create index content that includes the calendar
    # Use transclusion to include the calendar content
    # hideFolderListing: true prevents Quartz from showing the file listing below
    index_content = f"""---
title: {title}
description: Calendar view for {month} {year}
hideFolderListing: true
---

![[{calendar_file.stem}]]
"""
    
    with open(index_file, 'w', encoding='utf-8') as f:
        f.write(index_content)
    
    print(f"✅ Created: {year}/{month}/index.md (includes calendar)")

def main():
    """Create index files for all month folders"""
    created = 0
    
    for year_dir in sorted(CONTENT_DIR.glob("20??")):
        if not year_dir.is_dir():
            continue
        
        year = int(year_dir.name)
        
        for month in MONTHS:
            month_dir = year_dir / month
            if not month_dir.is_dir():
                continue
            
            calendar_file = find_calendar_file(month_dir)
            if calendar_file:
                create_index_file(year, month, calendar_file)
                created += 1
            else:
                print(f"⚠️  No calendar file found in {year}/{month}")
    
    print(f"\n✅ Created {created} index files")

if __name__ == "__main__":
    main()

