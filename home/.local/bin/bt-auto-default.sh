#!/bin/bash
sleep 2
bt_sink=$(pactl list short sinks | grep bluez | awk '{print $2}')
if [ -n "$bt_sink" ]; then
  pactl set-default-sink "$bt_sink"
fi
