#!/usr/bin/env bash
set -u

find_hdmi_sink() {
  pactl list short sinks | while read -r _ name _; do
    case "$name" in
      *hdmi*|*HDMI*|*displayport*|*DisplayPort*)
        printf '%s\n' "$name"
        return 0
        ;;
    esac
  done
}

switch_to_hdmi() {
  local sink current input

  pactl set-card-profile alsa_card.pci-0000_00_1f.3 output:hdmi-stereo >/dev/null 2>&1 || true

  sink=$(find_hdmi_sink | head -n 1)
  [ -n "${sink:-}" ] || return 0

  current=$(pactl get-default-sink 2>/dev/null || true)
  [ "$current" = "$sink" ] && return 0

  pactl set-default-sink "$sink" || return 0

  pactl list short sink-inputs | while read -r input _; do
    pactl move-sink-input "$input" "$sink" >/dev/null 2>&1 || true
  done
}

sleep 2
switch_to_hdmi

pactl subscribe | while read -r event; do
  case "$event" in
    *sink*|*card*|*server*)
      sleep 1
      switch_to_hdmi
      ;;
  esac
done
