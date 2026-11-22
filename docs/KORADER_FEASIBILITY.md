# KOReader feasibility for HiBy R1

**Status: not yet demonstrated; treat as an experimental port, not a supported target.**

The current Sonix Player build describes the HiBy R1 target as:
- little-endian MIPS32 Release 2 (MIPS32r2), o32 ABI;
- a userspace based on glibc 2.22;
- a custom framebuffer/LVGL UI and device-specific input, display, and power integration.

KOReader's upstream project supports several embedded readers and Linux/Android targets, but its published target list/build instructions do not provide a ready-made HiBy R1 or generic MIPS32r2 firmware target. Its build system and native dependencies would need to be ported and linked against the R1's ABI and available system interfaces. See the [upstream KOReader README](https://github.com/koreader/koreader) and [build-target documentation](https://github.com/koreader/koreader/blob/master/doc/Building_targets.md).

## Required proof before switching the boot UI

1. Build a minimal KOReader runtime for the exact R1 userspace ABI, without assuming a desktop Linux package will run on it.
2. Confirm all required native libraries can be built for MIPS32r2 and glibc 2.22, or bundled with compatible licensing and startup paths.
3. Connect KOReader to the device's framebuffer, buttons/touch input, storage paths, and power/suspend behavior.
4. Launch it manually from the existing Sonix environment while retaining a way to return to the existing UI.
5. Test EPUB/PDF rendering, fonts, page turns, sleep/wake, Wi-Fi transfer, and OTA update/recovery.
6. Only then change the default launcher.

## Safe fallback

The imported source already contains a native EPUB reader and its own reader UI. Keep it intact as a fallback while KOReader is being evaluated. This is preferable to removing the existing reader or changing the boot script before KOReader has been proven on the device.

## Firmware packaging blocker

The packer is designed to start from a legitimate stock R1 firmware file named `r1_original.upt`. That file is not present in the repository. A source build alone cannot produce a verified, recoverable R1 firmware image. Do not commit proprietary firmware dumps to a public repository; provide the file locally to a trusted build environment when packaging is ready.
