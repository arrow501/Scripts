# MinePipe

A simple, KISS approach to running a Minecraft server as a systemd service with an interactive console.

## What is MinePipe?

MinePipe provides a lightweight alternative to RCON for Minecraft server management on modern Linux systems. It uses named pipes and systemd to:

- Run your Minecraft server as a system service
- Provide a simple interactive console for sending commands
- Enable clean server shutdowns
- Work without installing additional server mods

MinePipe is compatible with all Minecraft server implementations including:
- Vanilla Minecraft
- Paper
- Spigot
- Fabric
- Forge
- And any other Java-based Minecraft server variant

## Features

- Universal compatibility - works with all Minecraft server implementations (Vanilla, Paper, Spigot, Fabric, Forge, etc.)
- No plugins required - works with the base server software
- Automatic server startup at boot with systemd
- Graceful shutdown with automatic save
- Simple interactive console interface
- Small footprint with minimal dependencies
- Works on all modern Linux distributions with systemd

## Installation

### 1. Set up the systemd service

1. Copy the `minepipe.service` file to your systemd directory:

```bash
sudo cp minepipe.service /etc/systemd/system/
```

2. Edit the service file to match your setup:

```bash
sudo nano /etc/systemd/system/minepipe.service
```

3. Modify the following variables:
   - `User` and `Group`: The Linux user/group that will run the Minecraft server
   - `SERVER_DIR`: Full path to your Minecraft server directory
   - `START_SCRIPT`: The script that starts your Minecraft server
   - `CONSOLE_PIPE`: Name of the pipe file used for console input

4. Reload systemd, enable and start the service:

```bash
sudo systemctl daemon-reload
sudo systemctl enable minepipe
sudo systemctl start minepipe
```

### 2. Set up the console script

1. Copy the `minepipe.sh` script to your Minecraft server directory:

```bash
cp minepipe.sh /path/to/minecraft/
chmod +x /path/to/minecraft/minepipe.sh
```

2. Run the console script to interact with your server:

```bash
./minepipe.sh
```

## Using MinePipe

The console script allows you to:

- View the server log in real-time
- Send commands to the running server
- Press Ctrl+C to exit the console (the server will continue running)

### Command-line options

```
Usage: minepipe.sh [OPTIONS]

Interactive console for Minecraft server running as a systemd service.

Options:
  -d, --dir DIR     Server directory (default: script directory)
  -p, --pipe FILE   Console input pipe (default: DIR/console-input)
  -s, --service SVC Service name (default: minecraft)
  -l, --lines NUM   Number of log lines to show (default: 50)
  -h, --help        Display this help and exit

Environment variables:
  MC_SERVER_DIR     Same as --dir
  MC_CONSOLE_PIPE   Same as --pipe
  MC_SERVICE_NAME   Same as --service
  MC_LOG_LINES      Same as --lines
```

## Systemd Service Commands

- Start the server: `sudo systemctl start minepipe`
- Stop the server: `sudo systemctl stop minepipe`
- Restart the server: `sudo systemctl restart minepipe`
- Check status: `sudo systemctl status minepipe`
- View logs: `sudo journalctl -u minepipe`

## Why use MinePipe instead of RCON?

- Simpler to set up and use
- No additional server load
- Works with systemd for proper service management
- No need to expose RCON ports or worry about authentication
- Built on standard Linux tools

## License

MIT-0 License - See the LICENSE file for details.

## Author

Copyright (c) 2025 Arrow
