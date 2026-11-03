# cam: fix red cast and reduce latency

## Context

`cam start` (bin/bin/cam) pipes the iPhone's MJPEG stream (IP Camera Lite,
via iproxy) through ffmpeg into v4l2loopback `/dev/video10`. Compared to the
phone's own video it looks clearly red, and it lags.

Measurements (2026-11-03, live stream, 1920x1080 MJPEG, 30 fps):

- The source JPEG is full range (`yuvj420p`, BT.601). The current filter chain
  leaves the range conversion to the auto-inserted scaler before `yuyv422`;
  read back as limited-range BT.601 (what consumers assume) the mean RGB moves
  from 131/113/97 to 133/114/93 — more red, less blue, more contrast.
- The source itself is warm: the white window frame measures 124/117/111.
  IP Camera Lite has no white balance setting.
- The phone delivers 30 fps, evenly spaced, with Content-Length per part. The
  script declares 25 fps and forces `-r 25`; ffmpeg guesses 25 fps timestamps
  for the stream, so `-r` is 1:1 today but would duplicate frames at any other
  value.
- ffmpeg processing is ~5 ms/frame; a stalled reader builds a backlog on the
  phone, but ffmpeg drains it immediately. The Linux side adds about one
  frame. The rest is the phone app (capture + JPEG at 1080p) and the consumer.
- `transpose=1,transpose=1` (ROTATE=180) runs on the full 1080p frame before
  scaling and is the most expensive step.

## Approach

1. Scale first, with explicit `in_range=pc:out_range=tv`, then rotate
   (`hflip,vflip` for 180; for 90/270 scale into the swapped box, then
   transpose), then pad.
2. White balance: fixed per-channel gains `WB_R` (default 0.94) and `WB_B`
   (default 1.06) via `colorchannelmixer` on the scaled frame; `WB_R=1 WB_B=1`
   skips the RGB stage.
3. Default `FPS=30` to match the phone, and replace `-r` with
   `-fps_mode passthrough` so frames are never duplicated or held back.
4. Warn when the stream is larger than the output size: setting the app to
   720p cuts phone-side encode time and therefore latency.

## Files

- bin/bin/cam

## Verification

- Run the new filter chain on a captured frame; mean RGB read back as
  limited BT.601 matches the source (no WB) / is neutral on the window frame
  (WB).
- `ffmpeg -benchmark` on a captured clip: CPU no higher than today.
- `bash -n`, shellcheck; restart `cam` only with the user's consent (Zoom is
  holding the device).
