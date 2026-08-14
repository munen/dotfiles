#!/bin/bash

# Terminate already running bar instances
killall -q polybar
while pgrep -u "$UID" -x polybar >/dev/null; do
  sleep 0.1
done

if type "xrandr"; then
  for m in $(xrandr --query | grep " connected" | cut -d" " -f1); do
    MONITOR=$m polybar --reload example >>/tmp/polybar.log 2>&1 &
  done
else
  polybar --reload example >>/tmp/polybar.log 2>&1 &
fi

echo "Polybar launched..."
