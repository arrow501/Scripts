#!/bin/bash
# minecraft-last-login - Find latest login times for Minecraft server players
# Version 1.0.0
# 
# MIT License (Zeroth Clause)
# 
# Copyright (c) 2025
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

# Default settings
LOG_DIR="./logs"
OUTPUT_FILE=$(mktemp)
VERBOSE=0
FORMAT="table"
SHOW_FILE=0

# Usage information
function show_help {
    echo "Usage: $(basename $0) [OPTIONS]"
    echo
    echo "Find the most recent login times for all Minecraft server players."
    echo
    echo "Options:"
    echo "  -d, --dir DIR     Specify logs directory (default: ./logs)"
    echo "  -j, --json        Output in JSON format"
    echo "  -f, --show-file   Show the log file containing each last login"
    echo "  -v, --verbose     Show detailed processing messages"
    echo "  -h, --help        Display this help and exit"
    echo
    echo "Example:"
    echo "  $(basename $0) --dir /path/to/minecraft/logs"
    echo "  $(basename $0) --json > player_data.json"
    echo
    echo "Run this script from your Minecraft server directory."
    exit 0
}

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -d|--dir)
            LOG_DIR="$2"
            shift 2
            ;;
        -j|--json)
            FORMAT="json"
            shift
            ;;
        -f|--show-file)
            SHOW_FILE=1
            shift
            ;;
        -v|--verbose)
            VERBOSE=1
            shift
            ;;
        -h|--help)
            show_help
            ;;
        *)
            echo "Unknown option: $1"
            echo "Use --help for usage information."
            exit 1
            ;;
    esac
done

# Check if logs directory exists
if [ ! -d "$LOG_DIR" ]; then
    # Try common alternatives
    if [ -d "./raspberry/logs" ]; then
        LOG_DIR="./raspberry/logs"
    elif [ -d "../logs" ]; then
        LOG_DIR="../logs"
    else
        echo "Error: Could not find logs directory at $LOG_DIR"
        echo "Please specify the correct path with --dir option"
        exit 1
    fi
fi

# Clean up on exit
trap "rm -f $OUTPUT_FILE" EXIT

# Show progress message
function progress {
    if [ $VERBOSE -eq 1 ]; then
        echo "$1" >&2
    fi
}

# Always show this initial message
echo "Finding player login data..." >&2

# Process log files from newest to oldest
for logfile in $(find "$LOG_DIR" -name "*.log*" | grep -v debug | sort -r); do
    progress "Checking $(basename $logfile)..."
    
    if [[ $logfile == *.gz ]]; then
        # For compressed logs
        zcat "$logfile" | grep "logged in with entity" | while read -r line; do
            # Extract player name
            if [[ $line =~ \[Server\ thread\/INFO\].*PlayerList.*:\ ([A-Za-z0-9_]+)\[\/ ]]; then
                player="${BASH_REMATCH[1]}"
                
                # Extract timestamp
                if [[ $line =~ \[([0-9]{2}[A-Za-z]{3}[0-9]{4}\ [0-9:.]+)\] ]]; then
                    timestamp="${BASH_REMATCH[1]}"
                    
                    # Only record if we haven't seen this player before
                    if ! grep -q "^$player|" "$OUTPUT_FILE" 2>/dev/null; then
                        echo "$player|$timestamp|$logfile" >> "$OUTPUT_FILE"
                        progress "  Found login for $player: $timestamp"
                    fi
                fi
            fi
        done
    else
        # For uncompressed logs
        cat "$logfile" | grep "logged in with entity" | while read -r line; do
            # Extract player name
            if [[ $line =~ \[Server\ thread\/INFO\].*PlayerList.*:\ ([A-Za-z0-9_]+)\[\/ ]]; then
                player="${BASH_REMATCH[1]}"
                
                # Extract timestamp
                if [[ $line =~ \[([0-9]{2}[A-Za-z]{3}[0-9]{4}\ [0-9:.]+)\] ]]; then
                    timestamp="${BASH_REMATCH[1]}"
                    
                    # Only record if we haven't seen this player before
                    if ! grep -q "^$player|" "$OUTPUT_FILE" 2>/dev/null; then
                        echo "$player|$timestamp|$logfile" >> "$OUTPUT_FILE"
                        progress "  Found login for $player: $timestamp"
                    fi
                fi
            fi
        done
    fi
done

# Sort results by date (most recent first)
# Minecraft timestamps look like "31Mar2025 16:30:59.867"
# We need to sort them chronologically, which is challenging with this format
# First, let's convert dates to sortable format: 2025-03-31 16:30:59.867

# Create a temporary file for sortable dates
SORT_FILE=$(mktemp)

# Convert dates to sortable format
while IFS="|" read -r player timestamp logfile; do
    # Extract day, month, year, time
    if [[ $timestamp =~ ([0-9]{2})([A-Za-z]{3})([0-9]{4})\ (.*) ]]; then
        day="${BASH_REMATCH[1]}"
        month="${BASH_REMATCH[2]}"
        year="${BASH_REMATCH[3]}"
        time="${BASH_REMATCH[4]}"
        
        # Convert month name to number
        case ${month,,} in
            jan) month_num="01" ;;
            feb) month_num="02" ;;
            mar) month_num="03" ;;
            apr) month_num="04" ;;
            may) month_num="05" ;;
            jun) month_num="06" ;;
            jul) month_num="07" ;;
            aug) month_num="08" ;;
            sep) month_num="09" ;;
            oct) month_num="10" ;;
            nov) month_num="11" ;;
            dec) month_num="12" ;;
            *) month_num="00" ;;
        esac
        
        # Create sortable date
        sortable_date="$year-$month_num-$day $time"
        echo "$player|$timestamp|$logfile|$sortable_date" >> "$SORT_FILE"
    else
        # If we can't parse it, just add it with a very old date
        echo "$player|$timestamp|$logfile|0000-00-00 00:00:00" >> "$SORT_FILE"
    fi
done < "$OUTPUT_FILE"

# Sort by the sortable date field (most recent first)
sort -t"|" -k4,4r "$SORT_FILE" > "$OUTPUT_FILE"

# Clean up
rm -f "$SORT_FILE"

# Display results based on requested format
if [ "$FORMAT" = "json" ]; then
    # Output in JSON format
    echo "{"
    echo "  \"players\": ["
    
    first=1
    while IFS="|" read -r player timestamp logfile; do
        if [ $first -eq 1 ]; then
            first=0
        else
            echo "    },"
        fi
        
        echo "    {"
        echo "      \"name\": \"$player\","
        echo "      \"last_login\": \"$timestamp\""
        
        if [ $SHOW_FILE -eq 1 ]; then
            echo "      ,\"logfile\": \"$(basename "$logfile")\""
        fi
    done < "$OUTPUT_FILE"
    
    # Close the last player entry if we had any
    if [ $first -eq 0 ]; then
        echo "    }"
    fi
    
    echo "  ]"
    echo "}"
else
    # Table format output
    if [ $SHOW_FILE -eq 1 ]; then
        echo "┌─────────────────────┬─────────────────────────────────┬─────────────────────┐"
        echo "│ Player              │ Last Login                      │ Log File            │"
        echo "├─────────────────────┼─────────────────────────────────┼─────────────────────┤"
        
        while IFS="|" read -r player timestamp logfile; do
            printf "│ %-19s │ %-33s │ %-19s │\n" "$player" "$timestamp" "$(basename "$logfile")"
        done < "$OUTPUT_FILE"
        
        echo "└─────────────────────┴─────────────────────────────────┴─────────────────────┘"
    else
        echo "┌─────────────────────┬─────────────────────────────────┐"
        echo "│ Player              │ Last Login                      │"
        echo "├─────────────────────┼─────────────────────────────────┤"
        
        while IFS="|" read -r player timestamp logfile; do
            printf "│ %-19s │ %-31s │\n" "$player" "$timestamp"
        done < "$OUTPUT_FILE"
        
        echo "└─────────────────────┴─────────────────────────────────┘"
    fi
fi

# Always show this final message
echo "Analysis complete!" >&2
