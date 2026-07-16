#!/bin/sh

set -eu

usage() {
  cat <<EOF
Usage: ${0##*/} [--blur]

Show /dev/video0 in a window.

  -b, --blur  Use OBS AI person segmentation to blur the background.
  -h, --help  Show this help.
EOF
}

fail() {
  printf '%s\n' "$*" >&2
  exit 1
}

blur=false

while [ "$#" -gt 0 ]; do
  case "$1" in
    -b|--blur)
      blur=true
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      printf 'Unknown option: %s\n\n' "$1" >&2
      usage >&2
      exit 2
      ;;
  esac
  shift
done

if [ "$blur" = true ]; then
  obs=/usr/bin/obs
  obs_plugin=/usr/lib/x86_64-linux-gnu/obs-plugins/obs-backgroundremoval.so
  virtual_device=/dev/video10
  script_path=$(readlink -f "$0")
  template_dir=$(dirname "$script_path")/../share/show_webcam/obs-studio
  runtime_dir=${XDG_RUNTIME_DIR:-/tmp}/show-webcam-obs
  config_home=$runtime_dir/config
  obs_config_dir=$config_home/obs-studio
  obs_log=$runtime_dir/obs.log
  obs_pid=
  loaded_loopback=false

  cleanup() {
    trap - 0 1 2 15
    if [ -n "$obs_pid" ] && kill -0 "$obs_pid" 2>/dev/null; then
      kill "$obs_pid" 2>/dev/null || true
      wait "$obs_pid" 2>/dev/null || true
    fi
    if [ "$loaded_loopback" = true ]; then
      if ! sudo -n /usr/sbin/modprobe -r v4l2loopback 2>/dev/null; then
        printf 'Could not unload v4l2loopback; it is still in use or sudo credentials expired.\n' >&2
      fi
    fi
  }
  trap cleanup 0 1 2 15

  [ -x "$obs" ] || fail 'OBS is required for --blur.'
  [ -f "$obs_plugin" ] || \
    fail 'The OBS Background Removal plugin is required for --blur.'
  if readelf -W -l "$obs_plugin" 2>/dev/null | grep 'GNU_STACK' | grep -q 'RWE'; then
    fail 'The OBS Background Removal plugin has an incompatible executable-stack flag.'
  fi
  [ -d "$template_dir" ] || fail "OBS template not found: $template_dir"
  command -v v4l2-ctl >/dev/null 2>&1 || fail 'v4l2-ctl is required for --blur.'

  if [ ! -e "$virtual_device" ]; then
    [ -x /usr/sbin/modprobe ] || fail 'modprobe is required for --blur.'
    command -v sudo >/dev/null 2>&1 || fail 'sudo is required to load v4l2loopback.'
    printf 'Loading the temporary OBS virtual camera (requires sudo).\n' >&2
    sudo /usr/sbin/modprobe v4l2loopback devices=1 video_nr=10 \
      card_label='OBS Virtual Camera' exclusive_caps=0 || \
      fail 'Could not load the v4l2loopback virtual camera.'
    loaded_loopback=true
    if command -v udevadm >/dev/null 2>&1; then
      udevadm settle --timeout=5
    fi
    [ -e "$virtual_device" ] || fail "v4l2loopback did not create $virtual_device."
  fi

  mkdir -p "$obs_config_dir"
  cp -R "$template_dir/." "$obs_config_dir/"

  QT_DEVICE_PIXEL_RATIO=2 XDG_CONFIG_HOME=$config_home \
    "$obs" --collection 'Webcam Blur' --profile 'Webcam Blur' \
    --scene 'Webcam Blur' --startvirtualcam --minimize-to-tray --multi \
    --disable-shutdown-check --disable-missing-files-check \
    >"$obs_log" 2>&1 &
  obs_pid=$!

  attempts=0
  while [ "$attempts" -lt 200 ]; do
    if ! kill -0 "$obs_pid" 2>/dev/null; then
      printf 'OBS exited before its virtual camera became ready. Log:\n' >&2
      tail -n 30 "$obs_log" >&2
      exit 1
    fi

    if grep -q 'Virtual camera started' "$obs_log" 2>/dev/null; then
      break
    fi

    attempts=$((attempts + 1))
    sleep 0.1
  done

  if [ "$attempts" -eq 200 ]; then
    printf 'Timed out waiting for the OBS virtual camera. Log:\n' >&2
    tail -n 30 "$obs_log" >&2
    exit 1
  fi

  ffplay -fflags nobuffer -flags low_delay -framedrop \
    -f video4linux2 -i "$virtual_device"
  cleanup
  exit 0
fi

exec ffplay -f video4linux2 -i /dev/video0
