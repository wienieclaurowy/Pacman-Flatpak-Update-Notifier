# PacFlat-Update-Alert
Arch Linux Update Checker
A lightweight Bash script that checks for available system updates on Arch Linux and displays desktop notifications.
Features

Monitors both pacman and Flatpak updates in a single notification
Automatically detects if necessary tools are installed
Provides clear desktop notifications with urgency levels based on update count
Shows formatted count of available updates by package manager
Uses different notification icons based on update status

How it works
The script performs dependency checks for required tools, then counts available updates from both pacman and Flatpak repositories. It displays a desktop notification with:

Total update count
Breakdown by package manager
Appropriate urgency level (critical for 10+ updates)
Relevant system icons

Requirements

pacman-contrib package (for the checkupdates command)
flatpak (optional - will be detected if installed)
Desktop environment with notification support

Usage
Simply execute the script to check for available updates:
bash
