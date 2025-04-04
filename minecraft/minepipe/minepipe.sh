#!/bin/bash
# MinePipe - Simple Minecraft Server Console
# Version 1.0.0
# 
# MIT-0 License
# 
# Copyright (c) 2025 Arrow
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

# Default configuration - can be overridden with environment variables
: "${MC_SERVER_DIR:="$(dirname "$(readlink -f "$0")")"}"
: "${MC_CONSOLE_PIPE:="$MC_SERVER_DIR/console-input"}"
: "${MC_SERVICE_NAME:="minepipe"}"
: "${MC_LOG_LINES:=50}"

# Show usage information
function show_help {
    echo "Usage: $(basename "$0") [OPTIONS]"
    echo
    echo "MinePipe - Interactive console for Minecraft server running as a systemd service."
    echo
    echo "Options:"
    echo "  -d, --dir DIR     Server directory (default: script directory)"
    echo "  -p, --pipe FILE   Console input pipe (default: DIR/console-input)"
    echo "  -s, --service SVC Service name (default: minepipe)"
    echo "  -l, --lines NUM   Number of log lines to show (default: 50)"
    echo "  -h, --help        Display this help and exit"
    echo
    echo "Environment variables:"
    echo "  MC_SERVER_DIR     Same as --dir"
    echo "  MC_CONSOLE_PIPE   Same as --pipe"
    echo "  MC_SERVICE_NAME   Same as --service"
    echo "  MC_LOG_LINES      Same as --lines"
    echo
    exit 0
}

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -d|--dir)
            MC_SERVER_DIR="$2"
            shift 2
            ;;
        -p|--pipe)
            MC_CONSOLE_PIPE="$2"
            shift 2
            ;;
        -s|--service)
            MC_SERVICE_NAME="$2"
            shift 2
            ;;
        -l|--lines)
            MC_LOG_LINES="$2"
            shift 2
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

# Check if pipe exists
if [ ! -p "$MC_CONSOLE_PIPE" ]; then
    echo "Error: Console pipe not found at $MC_CONSOLE_PIPE"
    echo "The server might not be running or you need to specify the correct pipe location."
    exit 1
fi

# Start following the journal in the background
journalctl -fu "$MC_SERVICE_NAME" -n "$MC_LOG_LINES" -o cat &
JOURNAL_PID=$!

# Cleanup on exit
trap 'kill $JOURNAL_PID 2>/dev/null; exit' INT TERM

# Interactive mode
echo "MinePipe Minecraft Console (press Ctrl+C to exit)"
echo "Type your commands:"
while read -r command; do
    echo "$command" > "$MC_CONSOLE_PIPE"
done

# Cleanup
kill $JOURNAL_PID 2>/dev/null
