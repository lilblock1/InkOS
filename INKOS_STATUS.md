# InkOS status and porting plan

InkOS is the HiBy R1 reading-focused firmware project based on the Sonix Player source tree imported from [Tartarus6/sonix-player](https://github.com/Tartarus6/sonix-player).

## Current direction

**Use the built-in Sonix EPUB reader. KOReader is out of scope for now.** Do not spend build time on a KOReader port unless the user asks to revisit it.

## Non-negotiable goals

- Make the built-in reader the primary and, eventually, the only normal user interface.
- Keep Wi-Fi connectivity and a supported over-the-air update path.
- Preserve the stock-firmware recovery route; do not publish an image as safe or flashable until it has been built and checked against a legitimate R1 stock firmware image.
- Remove music, streaming, games, and unrelated player UI only after confirming they are not required by boot, power management, storage, Wi-Fi, USB, or updating.
- Do not replace the boot launcher until the reader-first path has been validated on target hardware.

## What is in the imported base

- Device-specific HiBy R1 firmware packer and R1 root-filesystem overlay: `sonix-packer/`
- Native MIPS player and GUI source: `sonix-player/`
- Built-in EPUB parsing/rendering code: `sonix-player/src/system/ebook/`
- Reader UI: `sonix-player/src/gui/ebook/ebookreader.c`
- Wi-Fi management and file transfer code: `sonix-player/src/system/net/wifi.c` and `wifitransfer.c`
- The firmware updater is integrated with the HiBy `.upt` packaging and OTA chunk format in the packer. The current overlay points its update metadata at the upstream Sonix repository; do not change that to InkOS until InkOS has a compatible published release feed.

## Porting sequence

1. **Source audit** — map the built-in reader entry points, UI navigation, book storage, bookmarks/reading position, fonts, and required dependencies.
2. **Reader-first UI** — make the built-in EPUB library/reader the normal starting experience using existing code, while preserving a recoverable route to the original UI during development.
3. **Dependency-aware trimming** — disable/remove unrelated music, streaming, game, and player screens in small, build-checked steps. Keep Wi-Fi, storage, battery/power, USB, updater, and recovery components.
4. **Build validation** — use the R1 MIPS32r2/o32 toolchain and verify the native player build. Do not treat source audits as a successful device build.
5. **Firmware packaging** — obtain a legitimate stock R1 firmware `.upt` locally for the packer. Do not commit proprietary firmware dumps to the public repository.
6. **Hardware testing** — verify cold boot, library scan, EPUB reading, bookmarks/resume, sleep/wake, charging, Wi-Fi transfer, OTA update, and stock recovery.
7. **Test release** — publish a clearly marked prerelease only after the image is actually built. Do not claim it has booted unless it has been tested on an R1.

## Current limitations

The source import and repository audit are complete. The user has supplied a local stock R1 OTA candidate (`r1.upt`; SHA-256 `0fec88bb3ad0baa55a703e4e2b1038560d4a526f0dd024d2ed037f1560ed09f9`). Its ISO9660 OTA layout advertises compatibility `hiby_r1_x1600_auto_rf_auto`, with an `xImage` kernel and `rootfs.squashfs` payload. The firmware is intentionally kept out of public GitHub. Packer extraction compatibility and the expected root filesystem paths still need to be verified. No target binary or flashable InkOS image has been built, and no hardware boot has been verified. Next steps are a real MIPS target build, packaging, and then physical R1 testing; do not label the image bootable until those checks pass.
