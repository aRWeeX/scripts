#!/bin/bash

# * Replace "xfwm4" with your window manager service
# * Enable "Start Service at Login" on PulseEffects
# * Replace "RCD-M40(RCA)" with your own preset
# * Put this script on "$HOME/.config/PulseEffects"
# * Make the script executable "chmod +x $HOME/.config/PulseEffects/startup_preset.sh"
# * echo -e "[Desktop Entry]\nComment=PulseEffects Preset\nExec=$HOME/.config/PulseEffects/startup_preset.sh\nIcon=pulseeffects\nName=PulseEffects Preset\nStartupNotify=false\nTerminal=false\nType=Application" > $HOME/.config/autostart/pulseeffects-preset.desktop
# * Restart your PC

# Get this script's PID
PID=$$

# Outputless
{
  while $(sleep 10); do
    if systemctl is-system-running | grep -qE "running|degraded"; then
      break
    fi
  done

  # Wait for the GUI to be ready
  while [[ ! $(pgrep gnome-shell) ]]; do sleep 1; done
  echo -e "GUI is started\n"

  # Wait for PulseEffects to be ready
  pulseeffects --gapplication-service
  while [[ ! $(pgrep pulseeffects) ]]; do sleep 1; done
  echo -e "PulseEffects is started\n"

  # Load the preset
  PRESET="LoudnessEqualizerPE"
  /usr/bin/pulseeffects --reset
  /usr/bin/pulseeffects --load-preset ${PRESET}
  echo -e "Preset \"${PRESET}\" is loaded\n"

  # Kill this script
  echo -e "Killing myself..\n"
} &> /dev/null

/usr/bin/kill -9 ${PID}
