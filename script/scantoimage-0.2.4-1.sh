#!/bin/bash
# $1 = scanner device
# $2 = friendly name

{
  #override environment, as brscan is screwing it up:
  export $(grep -v '^#' /opt/brother/scanner/env.txt | xargs)

  resolution="${IMAGE_RESOLUTION:-600}"
  device="$1"
  date=$(date +%Y-%m-%d-%H-%M-%S)
  script_dir="/opt/brother/scanner/brscan-skey/script"
  output_jpeg_file="/image_scans/${date}.jpeg"
  trimmed_jpeg_file="/image_scans/${date}_trimmed.jpeg"

  set -e # Exit on error

  function scan_cmd() {
    # `brother4:net1;dev0` device name gets passed to scanimage, which it refuses as an invalid device name for some reason.
    # Let's use the default scanner for now
    # scanimage -l 0 -t 0 -x 215 -y 297 --device-name="$1" --resolution="$2" --batch="$3"
    scanimage -l 0 -t 0 -x 215 -y 297 --format=jpeg --mode "24bit Color[Fast]" --resolution="$2" -o "$3"
  }

  function trim_cmd() {
    convert "$1" -shave 40x40 -fuzz 80% -trim +repage "$2"
  }

  if [ "$(which usleep 2>/dev/null)" != '' ]; then
    usleep 100000
  else
    sleep 0.1
  fi

  scan_cmd "$device" "$resolution" "$output_jpeg_file"
  trim_cmd "$output_jpeg_file" "$trimmed_jpeg_file"

} >>/var/log/scanner.log 2>&1
