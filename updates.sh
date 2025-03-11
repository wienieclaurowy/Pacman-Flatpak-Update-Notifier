#!/bin/bash

# Check if required commands are available
if ! command -v checkupdates &>/dev/null; then
    notify-send -u critical "Update Checker" "checkupdates command not found. Please install pacman-contrib package."
    exit 1
fi

if ! command -v flatpak &>/dev/null; then
    notify-send -u normal "Update Checker" "Flatpak not installed. Will only check for system updates."
    has_flatpak=0
else
    has_flatpak=1
fi

# Create temporary files for output
pacman_tmp=$(mktemp)
flatpak_tmp=$(mktemp)

# Check for system updates
checkupdates > "$pacman_tmp" 2>/dev/null
pacman_updates=$(wc -l < "$pacman_tmp")

# Check for flatpak updates if available
if [ "$has_flatpak" -eq 1 ]; then
    flatpak remote-ls --updates > "$flatpak_tmp" 2>/dev/null
    flatpak_updates=$(wc -l < "$flatpak_tmp")
else
    flatpak_updates=0
fi

# Total updates
total_updates=$((pacman_updates + flatpak_updates))

# Create a notification message
if [ "$total_updates" -eq 0 ]; then
    message="No updates available"
    urgency="low"
    icon="software-update-available"
else
    message="<b>System Updates Available:</b>\n"
    
    if [ "$pacman_updates" -eq 1 ]; then
        message+="• <b>1</b> update via <i>pacman</i>\n"
    elif [ "$pacman_updates" -gt 1 ]; then
        message+="• <b>${pacman_updates}</b> updates via <i>pacman</i>\n"
    fi
    
    if [ "$has_flatpak" -eq 1 ]; then
        if [ "$flatpak_updates" -eq 1 ]; then
            message+="• <b>1</b> update via <i>flatpak</i>\n"
        elif [ "$flatpak_updates" -gt 1 ]; then
            message+="• <b>${flatpak_updates}</b> updates via <i>flatpak</i>\n"
        fi
    fi
    
    urgency="normal"
    icon="software-update-urgent"
    
    # If there are many updates, make it more urgent
    if [ "$total_updates" -gt 10 ]; then
        urgency="critical"
    fi
fi

# Send the notification
notify-send -u "$urgency" -i "$icon" -a "Update Checker" "System Updates" "$message"
sudo mount -t ntfs3 -o force /dev/sda2 /mnt;

# Clean up temporary files
rm -f "$pacman_tmp" "$flatpak_tmp"

exit 0

