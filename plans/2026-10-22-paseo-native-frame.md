# Paseo: native window frame under i3

## Context

Paseo creates its Linux window with `frame: false` (`dist/window/window-manager.js`,
`getMainWindowChromeOptions`). Electron then reserves a 24 px client-side shadow area
(`_GTK_FRAME_EXTENTS = 24, 24, 0, 24`). i3 ignores `_GTK_FRAME_EXTENTS`, and without
a compositor the area is painted as an opaque grey border. Replacing `frame: false`
with `frame: true` in `resources/app.asar` removes it (tested manually).

Paseo updates itself (electron-updater, AppImage provider), so a patch written into
the AppImage would be lost on every update.

## Approach

- Keep the unmodified AppImage outside the repository at
  `~/.local/share/paseo/Paseo.AppImage` (moved from `~/bin/paseo`).
- `bin/bin/paseo` becomes a wrapper: for each AppImage version (size + mtime) it
  extracts the AppImage into `~/.cache/paseo-native-frame/<key>/`, replaces the
  single `frame: false,` in `app.asar` with the same-length `frame: true, `, and
  runs the extracted `AppRun` with `APPIMAGE` pointing at the original file, so the
  auto-updater keeps replacing the original.
- If the pattern is not found exactly once (Paseo changed its code), start the
  unpatched AppImage and warn instead of failing.
- Old cache entries are removed after a successful extraction.

## Files

- `bin/bin/paseo` (new)

## Verification

- `paseo` starts the patched build; `xprop` on the window shows no
  `_GTK_FRAME_EXTENTS` and i3 draws its normal border.
- A second start reuses the cache (no extraction).
