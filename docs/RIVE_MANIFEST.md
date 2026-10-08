# Rive Asset Manifest

This document tracks the canonical mapping of Rive `.riv` files to characters in the NOVA project.

## Authoritative Characters

1. **NOVA (`assets/riv-assets/nova.riv`)**
   - The primary robot/star companion character.
   - Used for interactive lessons and generic mascot displays.

2. **Chintu (`assets/riv-assets/kid.riv`)**
   - The primary student/learner character.
   - Do not use `chintu.riv` as it does not exist; `kid.riv` is the canonical file.
   - *Note: There is also a file named `kid` without an extension which appears to be a duplicate. We use `kid.riv`.*

## Rules
- These assets are authoritative and must not be renamed, modified, redrawn, replaced, converted, or regenerated.
- Flutter/vector fallbacks may only be used for missing environmental objects, never as a replacement for Chintu or NOVA.
