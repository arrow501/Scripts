# minecraft-last-login.sh

A simple, lightweight bash script to find the most recent login time for each player on your Minecraft server.

## Version
1.0.0

## Features

- Displays the most recent login timestamp for each player
- Works with both compressed and uncompressed log files
- Sorts players by login date (most recent first)
- Supports multiple output formats (table or JSON)
- Customizable log directory location
- No dependencies beyond standard bash utilities

## Installation

1. Download the script:
   ```bash
   wget https://raw.githubusercontent.com/arrow501/Scripts/main/minecraft/minecraft-last-login.sh
   ```
   
2. Make it executable:
   ```bash
   chmod +x minecraft-last-login.sh
   ```

3. Run it from your Minecraft server directory:
   ```bash
   ./minecraft-last-login.sh
   ```

## Usage

Basic usage (displays a table of players and their last login time):
```bash
./minecraft-last-login.sh
```

### Command-line Options

- `-d, --dir DIR` - Specify logs directory (default: ./logs)
- `-j, --json` - Output in JSON format
- `-f, --show-file` - Show the log file containing each last login
- `-v, --verbose` - Show detailed processing messages
- `-h, --help` - Display help and exit

### Examples

Show detailed information including source log files:
```bash
./minecraft-last-login.sh --show-file
```

Export data as JSON:
```bash
./minecraft-last-login.sh --json > player_data.json
```

Use with a non-standard logs directory:
```bash
./minecraft-last-login.sh --dir /path/to/minecraft/logs
```

## Compatibility

This script works with standard Minecraft server logs and has been tested with:
- Vanilla Minecraft servers
- Forge servers
- Fabric servers
- Paper/Spigot servers

## License

MIT License (Zeroth Clause)

Copyright (c) 2025

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
