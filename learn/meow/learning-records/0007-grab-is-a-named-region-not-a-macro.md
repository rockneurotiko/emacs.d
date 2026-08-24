# 0007 — Grab (`G`) is a named region, not a macro

**Date:** 2026-07-03
**Status:** Accepted
**Introduced in:** Lesson 0004 (Grab, Swap, Sync)

## What this lesson teaches

The `G` / `R` / `X` trio (`meow-grab`, `meow-swap-grab`, `meow-sync-grab`) and
`meow-replace` (`;`). These give the user a "second clipboard" that lives in the
secondary selection — separate from the kill-ring.

## Why now

Learning-record 0004 established that Rock's verb vocabulary is weak. He has the
selection side (things, expansion, beacon) but doesn't compose with less-obvious verbs.
`R` (swap-grab) is the clearest example: it does something vanilla Emacs can't do
without a macro (`M-w` + nav + `C-w` + nav + `C-y`), and it directly maps to a daily
Elixir editing pattern (swap two function arguments).

## The mental model

`G` = "set the secondary selection at this region."
`R` = "exchange my current region with the secondary selection." (both regions change)
`X` = "overwrite the secondary selection's text with my current region's text." (current region is the source of truth, secondary gets updated)
`;` = "replace my current region with the kill-ring top." (no secondary selection needed)

These form a 2×2:
- **Source = secondary selection + kill-ring free:** `R` (swap), `X` (push-to-secondary)
- **Source = kill-ring:** `;` (replace)

## Calibration notes

- Rock already knows the selection side well. The lesson deliberately kept knowledge
  short and spent most space on three concrete patterns with before/after code.
- All examples are Elixir-native (Map.put arguments, module aliases).
- `meow-pop-grab` (cancel secondary selection) was mentioned in COMMANDS.org but not
  taught here — it's a footnote. It's relevant when a `G` grab is orphaned and the
  highlight becomes distracting.

## Next lesson options

1. **`j` (join) + `u` (pop-selection) + `Z` (undo-in-selection):** the three "edit
   within a selection" verbs he's never reached for. Highly composable with things.
2. **`'` (repeat):** he has this bound but probably doesn't use it. It replays the
   last motion, which chains beautifully with things and expansion.
3. **Leader key + SPC workflow:** he has a leader bound but the lesson hasn't touched
   SPC-prefixed navigation (`SPC b`, `SPC f`, `SPC o`). May not need teaching.
4. **meow-tree-sitter selectors:** the "unlock" the mission talks about. Function/class
   selection in Elixir files. Prerequisite: the four-selection-families model is solid
   (which it now is after four lessons).

**Recommended next:** meow-tree-sitter selectors — it's the highest-value payoff
directly tied to the Elixir mission, and he now has enough selection vocabulary to
appreciate what the tree-sitter things give him.
