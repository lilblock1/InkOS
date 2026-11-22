# KOReader decision for InkOS

**Decision: KOReader is out of scope for the current InkOS effort. Use the built-in Sonix EPUB reader instead.**

The existing source contains EPUB parsing/rendering code in `sonix-player/src/system/ebook/` and a reader UI in `sonix-player/src/gui/ebook/ebookreader.c`. The immediate goal is to make that reader the primary interface and remove unrelated features carefully, while preserving Wi-Fi, updates, and recovery.

No KOReader runtime or target port is required for the current plan. Revisit this decision only if the user explicitly asks.

## Safety and packaging note

The R1 packer requires a legitimate stock firmware file named `r1_original.upt` as its input. It is not present in the repository. Source-code work and CI audits can continue without it, but a verified, flashable firmware image cannot be produced by this packer until a suitable stock input is available. Do not commit proprietary firmware dumps to a public repository.
