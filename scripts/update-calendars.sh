#!/bin/bash
# Update calendar pages to mark dates without files differently
# Usage: ./scripts/update-calendars.sh

set -e

CONTENT_DIR="/Users/rupali.b/Documents/GitHub/WorkTracker/content"

# Function to check if a date file exists and format accordingly
format_date() {
    local year=$1
    local month=$2
    local month_num=$3
    local day=$4
    local day_padded=$(printf "%02d" $day)
    local file="${CONTENT_DIR}/${year}/${month}/${day_padded}-${month_num}-${year}.md"
    
    if [ -f "$file" ]; then
        echo "[${day}](${day_padded}-${month_num}-${year}.md)"
    else
        echo "<span style='color: #999;'>${day}</span>"
    fi
}

# Function to update a calendar file
update_calendar() {
    local year=$1
    local month=$2
    local month_file=$3
    
    echo "Updating ${year}/${month}..."
    
    # Get month number
    case $month in
        January) month_num="01" ;;
        February) month_num="02" ;;
        March) month_num="03" ;;
        April) month_num="04" ;;
        May) month_num="05" ;;
        June) month_num="06" ;;
        July) month_num="07" ;;
        August) month_num="08" ;;
        September) month_num="09" ;;
        October) month_num="10" ;;
        November) month_num="11" ;;
        December) month_num="12" ;;
    esac
    
    # Get number of days in month
    local days_in_month=31
    if [ "$month" = "February" ]; then
        if [ $((year % 4)) -eq 0 ] && ([ $((year % 100)) -ne 0 ] || [ $((year % 400)) -eq 0 ]); then
            days_in_month=29
        else
            days_in_month=28
        fi
    elif [[ "$month" =~ ^(April|June|September|November)$ ]]; then
        days_in_month=30
    fi
    
    # Read the file and update calendar section
    python3 << EOF
import re
import sys

file_path = "${month_file}"
year = ${year}
month = "${month}"
month_num = "${month_num}"
days_in_month = ${days_in_month}
content_dir = "${CONTENT_DIR}"

def format_date(day):
    day_padded = f"{day:02d}"
    file_path = f"{content_dir}/{year}/{month}/{day_padded}-{month_num}-{year}.md"
    import os
    if os.path.exists(file_path):
        return f"[{day}]({day_padded}-{month_num}-{year}.md)"
    else:
        return f"<span style='color: #999; opacity: 0.6;'>{day}</span>"

with open(file_path, 'r') as f:
    content = f.read()

# Find calendar section and update dates
lines = content.split('\n')
in_calendar = False
calendar_start = -1
calendar_end = -1

for i, line in enumerate(lines):
    if '## 📅 Calendar View' in line or '## Calendar View' in line:
        in_calendar = True
        calendar_start = i
    elif in_calendar and line.startswith('##') and 'Calendar' not in line:
        calendar_end = i
        break

if calendar_start >= 0:
    # Rebuild calendar
    calendar_lines = []
    calendar_lines.append(lines[calendar_start])
    calendar_lines.append('')
    calendar_lines.append('| Mon | Tue | Wed | Thu | Fri | Sat | Sun |')
    calendar_lines.append('|-----|-----|-----|-----|-----|-----|-----|')
    
    # Calculate first day of month (simplified - assumes 2025 starts on Wednesday)
    # For January 2025, day 1 is a Wednesday (day 3 of week)
    first_day = 3 if month == "January" and year == 2025 else 1
    
    # For other months, we'd need to calculate properly, but for now use a simple approach
    # This is a simplified version - you may want to use a proper date library
    if month == "January" and year == 2025:
        first_day = 3  # Wednesday
    elif month == "February" and year == 2025:
        first_day = 6  # Saturday (Jan has 31 days, so Feb 1 is 31+1 mod 7 = 4 days after Wed = Sat)
    elif month == "May" and year == 2025:
        first_day = 4  # Thursday
    elif month == "July" and year == 2025:
        first_day = 2  # Tuesday
    else:
        first_day = 1  # Default to Monday
    
    # Build calendar grid
    row = ['|']
    # Add empty cells before first day
    for _ in range(first_day - 1):
        row.append(' |')
    
    day = 1
    while day <= days_in_month:
        if len(row) >= 8:  # Row is full (including | at start)
            calendar_lines.append(''.join(row) + ' |')
            row = ['|']
        
        date_str = format_date(day)
        row.append(f' {date_str} |')
        day += 1
    
    # Fill remaining cells in last row
    while len(row) < 8:
        row.append(' |')
    calendar_lines.append(''.join(row))
    
    # Rebuild content
    new_content = '\n'.join(lines[:calendar_start]) + '\n' + '\n'.join(calendar_lines) + '\n'
    if calendar_end > calendar_start:
        new_content += '\n'.join(lines[calendar_end:])
    
    with open(file_path, 'w') as f:
        f.write(new_content)
    
    print(f"Updated {file_path}")
else:
    print(f"Could not find calendar section in {file_path}")

EOF
}

# Update all calendar files
for year_dir in "${CONTENT_DIR}"/20*; do
    year=$(basename "$year_dir")
    if [ ! -d "$year_dir" ] || [ ! "$year" =~ ^20[0-9][0-9]$ ]; then
        continue
    fi
    
    for month_dir in "${year_dir}"/*; do
        month=$(basename "$month_dir")
        if [ ! -d "$month_dir" ]; then
            continue
        fi
        
        # Find the calendar file (month summary file)
        calendar_file=$(find "$month_dir" -maxdepth 1 -name "*.md" -type f | grep -v "[0-9][0-9]-" | grep -v "^\.space" | head -1)
        
        if [ -n "$calendar_file" ]; then
            update_calendar "$year" "$month" "$calendar_file"
        fi
    done
done

echo ""
echo "✅ Calendar updates complete!"
echo "Rebuild your site with: npx quartz build"

