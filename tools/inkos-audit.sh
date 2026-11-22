#!/usr/bin/env bash
# Lightweight repository safety audit for InkOS. This does not build or flash firmware.
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
fail() { printf 'FAIL: %s\n' "$*" >&2; exit 1; }
need() { [[ -e "$ROOT/$1" ]] || fail "required path missing: $1"; }
need "sonix-player/Makefile"
need "sonix-player/src/system/ebook/ebook.c"
need "sonix-player/src/system/ebook/ebook.h"
need "sonix-player/src/system/net/wifi.c"
need "sonix-player/src/system/net/wifitransfer.c"
need "sonix-packer/sonix_firmware_packer.sh"
need "sonix-packer/assets/R1/etc/init.d/S43wifi_bcm_init_config"
need "sonix-packer/assets/R1/usr/bin/sonix_player.sh"
need "sonix-packer/assets/R1/usr/resource/sonix/components/system-info.json"

grep -q 'sonix_player' "$ROOT/sonix-packer/assets/R1/usr/bin/sonix_player.sh" ||
  fail "R1 startup script no longer launches the player"

grep -q 'ebookpage_init(cfg)' "$ROOT/sonix-player/src/gui/shell/gui.c" ||
  fail "built-in EPUB shelf is not initialized"
grep -q 'switch_screen(ebookpage_screen)' "$ROOT/sonix-player/src/gui/shell/gui.c" ||
  fail "InkOS does not start on the built-in EPUB shelf"
grep -q 'wifi_init();' "$ROOT/sonix-player/src/main.c" ||
  fail "Wi-Fi initialization missing from startup"
grep -q 'ota-repo' "$ROOT/sonix-packer/assets/R1/usr/resource/sonix/components/system-info.json" ||
  fail "OTA repository metadata missing"
grep -q 'r1_original.upt' "$ROOT/sonix-packer/sonix_firmware_packer.sh" ||
  fail "R1 stock-firmware input requirement missing"

printf 'PASS: InkOS source layout, EPUB reader, Wi-Fi, boot path, and OTA metadata are present.\n'
printf 'NOTE: This is a source audit only; it does not prove KOReader compatibility, build an image, or validate flashing.\n'
