# autorandr: BenQ 5K docked / X1 mobile

## Context
The BenQ (DP-1) supports 5120x2880, but X starts mirrored at 3840x2160.
Wanted: the BenQ at 5K as primary, the X1 panel (DP-2) as its own screen to the
left, all i3 workspaces on the BenQ, and an automatic switch on plug and unplug.
Without the BenQ, everything goes to the X1; on replug, workspaces return.

## Approach
- Install autorandr (Debian package; ships udev and systemd hotplug hooks).
- Profiles, saved from live layouts (matched by EDID, not output name):
  - `docked`: X1 3840x2160 at 0,0; BenQ 5120x2880@60 at 3840,0, primary.
  - `mobile`: X1 only, primary.
- Postswitch hook `~/.config/autorandr/postswitch`: relaunch polybar
  (`launch_polybar.sh` starts one bar per connected output).
- `.xinitrc`: replace `xrandr --output eDP-1-1 --auto` with
  `autorandr --change --default mobile` (after the NVIDIA proxy line).
- i3 (`~/.i3/config`): `workspace <ws> output DP-1 DP-2` for workspaces 1-10 and
  F1-F12, so they move back to the BenQ after a replug and fall back to the X1.
- No per-profile DPI switching for now (Xft.dpi stays 286).

## Files
- `dotfiles/xinit/.xinitrc`
- `~/.i3/config` (separate repo `munen/i3_config`)
- `~/.config/autorandr/{docked,mobile,postswitch}` (new)

## Verification
- `autorandr --detected` shows `docked` while the BenQ is connected.
- `autorandr --load mobile`: all workspaces on DP-2; `autorandr --load docked`:
  pinned workspaces back on DP-1.
- Physical unplug and replug switches profiles without intervention.
