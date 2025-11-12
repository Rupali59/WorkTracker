#!/usr/bin/env python3
"""
Update calendar pages to mark dates without files differently.
Dates with files: [1](01-01-2025.md) (clickable link)
Dates without files: <span style='color: #999; opacity: 0.6;'>1</span> (grayed out, no link)
"""

import os
import re
from pathlib import Path

CONTENT_DIR = Path("/Users/rupali.b/Documents/GitHub/WorkTracker/content")

MONTHS = {
    "January": ("01", 31),
    "February": ("02", 28),  # Will adjust for leap years
    "March": ("03", 31),
    "April": ("04", 30),
    "May": ("05", 31),
    "June": ("06", 30),
    "July": ("07", 31),
    "August": ("08", 31),
    "September": ("09", 30),
    "October": ("10", 31),
    "November": ("11", 30),
    "December": ("12", 31),
}

def is_leap_year(year):
    """Check if year is a leap year"""
    return (year % 4 == 0 and year % 100 != 0) or (year % 400 == 0)

def get_days_in_month(month, year):
    """Get number of days in a month"""
    if month == "February":
        return 29 if is_leap_year(year) else 28
    return MONTHS[month][1]

def format_date_link(year, month, month_num, day, days_in_month):
    """Format a date as either a link or grayed out text"""
    day_padded = f"{day:02d}"
    file_path = CONTENT_DIR / str(year) / month / f"{day_padded}-{month_num}-{year}.md"
    
    if file_path.exists():
        return f"[{day}]({day_padded}-{month_num}-{year}.md)"
    else:
        return f"<span style='color: #999; opacity: 0.6;'>{day}</span>"

def update_calendar_file(file_path, year, month):
    """Update a calendar markdown file"""
    month_num, _ = MONTHS[month]
    days_in_month = get_days_in_month(month, year)
    
    with open(file_path, 'r', encoding='utf-8') as f:
        content = f.read()
    
    # Find the calendar section
    calendar_pattern = r'(## 📅 Calendar View.*?\n)(\| Mon.*?\n\|-+.*?\n)(.*?)(\n## |\n---|\Z)'
    match = re.search(calendar_pattern, content, re.DOTALL)
    
    if not match:
        print(f"⚠️  Could not find calendar section in {file_path}")
        return False
    
    header = match.group(1)
    table_header = match.group(2)
    old_calendar = match.group(3)
    rest = match.group(4)
    
    # Extract existing calendar structure to preserve layout
    # We'll rebuild it with proper date formatting
    lines = old_calendar.strip().split('\n')
    
    # Replace dates in calendar rows
    def process_calendar_line(line):
        """Process a calendar line and replace all date patterns"""
        if not (line.strip().startswith('|') and 'Mon' not in line and '---' not in line):
            return line
        
        # Pattern 1: [1](file.md) - link with file
        def replace_link(match):
            day = int(match.group(1))
            file_name = match.group(2)
            file_path_check = CONTENT_DIR / str(year) / month / file_name
            if file_path_check.exists():
                return match.group(0)  # Keep existing link
            else:
                return f"<span style='color: #999; opacity: 0.6;'>{day}</span>"
        
        # Pattern 2: [1] - just brackets, no link
        def replace_brackets(match):
            day = int(match.group(1))
            return format_date_link(year, month, month_num, day, days_in_month)
        
        # Pattern 3: <span> - already processed, skip
        def skip_span(match):
            return match.group(0)
        
        # Apply replacements in order
        # First, skip already processed spans
        line = re.sub(r'<span[^>]*>(\d+)</span>', skip_span, line)
        # Clean up duplicate link patterns first: [1](file.md)(file.md) -> [1](file.md)
        line = re.sub(r'\[(\d+)\]\(([^)]+)\)\([^)]+\)', r'[\1](\2)', line)
        # Then handle links [1](file.md)
        line = re.sub(r'\[(\d+)\]\(([^)]+)\)', replace_link, line)
        # Finally handle bare brackets [1] - but not if already in a link
        line = re.sub(r'(?<!\]\()\[(\d+)\](?!\()', replace_brackets, line)
        
        return line
    
    new_calendar_lines = []
    for line in lines:
        new_calendar_lines.append(process_calendar_line(line))
    
    new_calendar = '\n'.join(new_calendar_lines)
    new_content = header + table_header + new_calendar + rest
    
    with open(file_path, 'w', encoding='utf-8') as f:
        f.write(new_content)
    
    return True

def main():
    """Main function to update all calendar files"""
    updated = 0
    skipped = 0
    
    for year_dir in sorted(CONTENT_DIR.glob("20??")):
        if not year_dir.is_dir():
            continue
        
        year = int(year_dir.name)
        
        for month_dir in sorted(year_dir.iterdir()):
            if not month_dir.is_dir():
                continue
            
            month = month_dir.name
            if month not in MONTHS:
                continue
            
            # Find the calendar file (month summary file, not daily notes)
            calendar_files = [f for f in month_dir.glob("*.md") 
                            if not re.match(r'\d{2}-\d{2}-\d{4}\.md$', f.name) 
                            and not f.name.startswith('.')]
            
            if not calendar_files:
                continue
            
            calendar_file = calendar_files[0]
            
            if update_calendar_file(calendar_file, year, month):
                print(f"✅ Updated: {year}/{month}")
                updated += 1
            else:
                print(f"⚠️  Skipped: {year}/{month}")
                skipped += 1
    
    print(f"\n✅ Updated {updated} calendar files")
    if skipped > 0:
        print(f"⚠️  Skipped {skipped} calendar files")

if __name__ == "__main__":
    main()

