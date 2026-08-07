#!/bin/bash

rfkill unblock bluetooth 2>/dev/null

get_device_property() {
  busctl --json=short get-property \
    org.bluez "$1" org.bluez.Device1 "$2" 2>/dev/null |
    jq -r '.data // empty'
}

mapfile -t device_paths < <(
  busctl tree --list org.bluez 2>/dev/null |
    grep '/dev_'
)

if (( ${#device_paths[@]} == 0 )); then
  notify-send -u low "Bluetooth" "No devices found. Right-click the Bluetooth icon to scan and pair."
  exit 0
fi

options=()
for path in "${device_paths[@]}"; do
  alias=$(get_device_property "$path" Alias)
  connected=$(get_device_property "$path" Connected)
  paired=$(get_device_property "$path" Paired)

  if [[ $connected == "true" ]]; then
    status="●"
  elif [[ $paired == "true" ]]; then
    status="○"
  else
    status="＋"
  fi

  options+=("$status ${alias:-Unknown device}")
done

selection=$(
  printf '%s\n' "${options[@]}" |
    omarchy-launch-walker --dmenu --index --width 420 --minheight 1 --maxheight 360 \
      -p "Bluetooth device…" 2>/dev/null
)

[[ $selection =~ ^[0-9]+$ ]] || exit 0
(( selection < ${#device_paths[@]} )) || exit 0

path=${device_paths[$selection]}
alias=$(get_device_property "$path" Alias)
connected=$(get_device_property "$path" Connected)
paired=$(get_device_property "$path" Paired)

if [[ $connected == "true" ]]; then
  if timeout 20s busctl call org.bluez "$path" org.bluez.Device1 Disconnect >/dev/null 2>&1; then
    notify-send -u low "Bluetooth" "Disconnected from ${alias:-device}."
  else
    notify-send -u normal "Bluetooth" "Could not disconnect from ${alias:-device}."
  fi
  exit 0
fi

if [[ $paired != "true" ]]; then
  if ! timeout 30s busctl call org.bluez "$path" org.bluez.Device1 Pair >/dev/null 2>&1; then
    notify-send -u normal "Bluetooth" "Could not pair with ${alias:-device}. Right-click the icon for advanced pairing."
    exit 1
  fi
fi

if timeout 20s busctl call org.bluez "$path" org.bluez.Device1 Connect >/dev/null 2>&1; then
  notify-send -u low "Bluetooth" "Connected to ${alias:-device}."
else
  notify-send -u normal "Bluetooth" "Could not connect to ${alias:-device}. Make sure it is powered on and nearby."
fi
