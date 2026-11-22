# InkOS status and porting plan

InkOS is the HiBy R1 reading-focused firmware project based on the Sonix Player source tree imported from [Tartarus6/sonix-player](https://github.com/Tartarus6/sonix-player).

## Non-negotiable goals

- Make reading the primary and, eventually, only normal user interface.
- Keep Wi-Fi connectivity and a supported over-the-air update path.
- Preserve the stock-firmware recovery route; do not publish an image as safe or flashable until it has been built and checked against an R1 stock firmware image.
- Remove music, streaming, games, and unrelated player UI only after confirming they are not required by boot, power management, storage, Wi-Fi, or updating.
- Do not claim KOReader is running on the R1 until a real target build boots and has been tested on hardware.

## What is in the imported base

- Device-specific HiBy R1 firmware packer and R1 root-filesystem overlay: `sonix-packer/`
- Native MIPS player and GUI source: `sonix-player/`
- An existing lightweight EPUB renderer and reader UI: `sonix-player/src/system/ebook/` and the related GUI reader.
- Wi-Fi management and file transfer code: `sonix-player/src/system/net/wifi.c` and `wifitransfer.c`.
- The firmware updater is integrated with the HiBy `.upt` packaging and OTA chunk format in the packer. The current overlay points its update metadata at the upstream Sonix repository; do not change that to InkOS until InkOS has a compatible published release feed.

## Porting sequence

1. **Baseline and safety audit** — preserve the R1 device overlay, boot path, Wi-Fi initialization, and recovery/update packaging. Record required stock firmware inputs.
2. **Reader-first boot** — change the normal UI entry point only after a minimal reader startup path exists and can return safely to recovery. Avoid replacing boot scripts with a reader binary that has not been tested on the device.
3. **KOReader feasibility/build** — verify the R1's MIPS userspace ABI, libc, framebuffer/input interfaces, and available graphics/font libraries against KOReader's actual supported targets. If the required runtime cannot be built for this device, keep the existing native EPUB reader as a working fallback while documenting the limitation.
4. **Trim features in dependency-aware steps** — remove music/streaming/game screens and their code only after checking references and build/link dependencies. Keep Wi-Fi, clock/time, storage, battery/power, USB access, updater, and recovery functions.
5. **Build and validation** — build with the correct R1 toolchain and a user-supplied legitimate R1 stock firmware image; inspect the generated `.upt`, run static checks, then test boot, reading, sleep/wake, Wi-Fi, update, and stock recovery on hardware.
6. **Test release** — publish a clearly marked prerelease only after the build completes. Do not describe it as personally tested on the R1 unless it has actually been booted on an R1.

## Current limitations

The repository import is complete, but that is not a bootable InkOS image. This repository does not contain the user's stock R1 firmware input, and a GitHub-hosted source import alone cannot validate a device flash. A CI audit can protect important source paths; it cannot replace hardware testing.
