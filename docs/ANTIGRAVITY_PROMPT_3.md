# Prompt 3 for Antigravity (paste as is)

Branch: create `task/consolidate-steps-1-4` from `nova`. Do not push to main.

Read `docs/HANDOVER.md` (section 0 rules) and `consolidation_plan.md`.
Carry out Steps 1 to 4 of the consolidation plan ONLY: move the shared widgets, utilities, accessibility screens and demo tools out of `lib/nova_main/` into the main app (`lib/main.dart` shell: Riverpod + Drift).

Rules
- Do NOT delete anything from `lib/nova_main/` yet; copy/move with imports fixed, leaving no duplicate filenames that clash.
- `flutter analyze` must pass after EACH step; commit once per step with the step number in the message.
- Do not touch `lib/features/duel/` and do not change the JSON contract (`contracts/level_v2.schema.json`).
- No API keys, no new features, no UI redesign.
- If something in the plan is ambiguous or a step cannot build, stop and report instead of guessing.
- At the end: list files moved, analyzer output, anything you could not run.
