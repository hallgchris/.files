#!/bin/bash
#   Some widgets (volume) rely on scripts that have to be
#   run persistently in the background.
#   They sleep until volume state changes, in an infinite loop.
#   As a result when awesome restarts, they keep running in background, along with the new ones that are created after the restart.
#   This script cleans up the old processes.

# Volume widgets
ps aux | grep "pactl subscribe" | grep -v grep | awk '{print $2}' | xargs kill
