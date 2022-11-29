# Run this in a cronjob every minute
# * * * * * XDG_RUNTIME_DIR=/run/user/$(id -u) ~/bin/low-battery-shutdown.sh >/dev/null 2>&1

low_threshold=15
critical_threshold=5
timeout=59
#shutdown_cmd='systemctl suspend'
shutdown_cmd='sudo systemctl hibernate'

state=$(cat /sys/class/power_supply/BAT0/status)

export DISPLAY=:0

if [ x"$state" != x'Discharging' ]; then
  exit 0
fi

current=$(cat /sys/class/power_supply/BAT0/energy_now)
max=$(cat /sys/class/power_supply/BAT0/energy_full)
level=$(echo "scale=0; 100 * $current / $max" | bc)

echo "Current: " $current
echo "Max: " $max
echo "Level: " $level
echo "State: " $state

do_shutdown() {
  sleep $timeout && kill $zenity_pid 2>/dev/null

  if [ x"$state" != x'Discharging' ]; then
    exit 0
  else
    $shutdown_cmd
  fi
}

if [ "$level" -lt $low_threshold ]; then
  notify-send -u critical "Battery level is low: $level%"
fi

if [ "$level" -lt $critical_threshold ]; then

  notify-send -u critical -t 20000 "Battery level is low: $level%" \
    'The system is going to shut down in 1 minute.'

  zenity --question --ok-label 'OK' --cancel-label 'Cancel' \
    --text "Battery level is low: $level%.\n\n The system is going to shut down in 1 minute." &
  zenity_pid=$!

  do_shutdown &
  shutdown_pid=$!

  trap 'kill $shutdown_pid' 1

  if ! wait $zenity_pid; then
    kill $shutdown_pid 2>/dev/null
  fi

fi

exit 0
