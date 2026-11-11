# autorandr: BenQ 5K docked / X1 mobile

## Context
The BenQ (DP-1) supports 5120x2880, but X starts mirrored at 3840x2160.
Wanted: the BenQ at 5K as primary, the X1 panel (DP-2) as its own screen to the
left, all i3 workspaces on the BenQ, and an automatic switch on plug and unplug.
Without the BenQ, everything goes to the X1; on replug, workspaces return.

## Approach
- Install autorandr (Debian package; ships udev and systemd hotplug hooks).
- Profiles, saved from live layouts (matched by EDID, not output name):
  - `docked`: BenQ 5120x2880@60 alone, primary; X1 panel off.
  - `mobile`: X1 only, primary.
- Postswitch hook `~/.config/autorandr/postswitch`: relaunch polybar
  (`launch_polybar.sh` starts one bar per connected output).
- `.xinitrc`: replace `xrandr --output eDP-1-1 --auto` with
  `autorandr --change --default mobile` (after the NVIDIA proxy line).
- No per-profile DPI switching for now (Xft.dpi stays 286).

## Files
- `dotfiles/xinit/.xinitrc`
- `~/.config/autorandr/{docked,mobile,postswitch}` (new)

## Verification
- `autorandr --detected` shows `docked` while the BenQ is connected.
- `autorandr --load mobile`: all workspaces on DP-2; `autorandr --load docked`:
  all workspaces on DP-1.
- Physical unplug and replug switches profiles without intervention.

## Change (same day): one screen at a time
A dual layout (X1 + BenQ 5K, 8960x2880 framebuffer) failed intermittently:
the NVIDIA driver rejected the screen resize with `BadMatch` on
`RRSetScreenSize`. Likely cause: the GTX 1650 had 3.3 of 4 GB VRAM in use
(Xorg, Chromium, Zoom). munen only needs one screen, so `docked` is now the
BenQ alone. With a single output active at a time, i3 moves every workspace to
it, so the workspace-to-output pins were dropped.

## Change: hotplug through X events
A real unplug/replug test showed no drm uevents at all (nvidia-drm without
modeset), so autorandr's udev rule never fires. X does report
`XRROutputChangeNotifyEvent` (RR_Connected/RR_Disconnected).
`bin/autorandr-listen` (started from `.xinitrc`) watches those via
`xev -root -event randr`, debounces, and loads `docked` or `mobile`. After a
replug X still lists the BenQ as active, so the monitor stays dark until a real
modeset: the listener toggles the BenQ to 70 Hz and back to 60 Hz. If no screen
is active afterwards, it falls back to the X1. Log:
`~/.cache/autorandr-listen.log`.
