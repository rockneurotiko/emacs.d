# 0003 — Emacs-native background, not a vim refugee

**Date:** 2026-06-18
**Status:** Accepted

## Context

Rock confirmed: 10+ years of standard Emacs bindings before meow. **Not** coming from
vim/evil. No muscle memory for `dw`, `ciw`, `3dd` etc.

## What this changes

### 1. The reference frame is Emacs, not vim.

When explaining meow concepts I should anchor to the Emacs primitive he already knows,
not to vim's verb-object grammar. Examples:

- **Don't say** "meow is like `dw` but you select first."
- **Do say** "remember `M-d` (`kill-word`) and `C-k` (`kill-line`)? Meow's <kbd>k</kbd>
  is the same family — it's `kill-region` with smart fallbacks. The selection is
  literally the Emacs region."

### 2. Reuse his Emacs knowledge of *region* and *kill-ring*.

Meow's selection model **is** Emacs's region with a richer overlay. Things he already
knows that transfer directly:

| Emacs concept he knows                | Meow surface                       |
|---------------------------------------|------------------------------------|
| `C-SPC` to start a region             | meow motions build the region for you |
| `region-active-p` / transient-mark    | exactly what `d`/`k`/`c` check     |
| `kill-region` (`C-w`)                 | <kbd>k</kbd> (`meow-kill`)         |
| `kill-ring-save` (`M-w`)              | <kbd>x</kbd> (`meow-save`)         |
| `yank` (`C-y`)                        | <kbd>y</kbd> (`meow-yank`)         |
| `kill-word` (`M-d`)                   | <kbd>w</kbd><kbd>1</kbd><kbd>k</kbd> |
| `mark-paragraph` (`M-h`)              | <kbd>.</kbd> (`meow-bounds-of-thing`) on paragraph |
| `C-x C-x` exchange point and mark     | <kbd>:</kbd> (`meow-reverse`)      |

### 3. The kill-vs-delete confusion makes more sense now.

In standard Emacs, `kill-*` family puts on the kill-ring, `delete-*` family doesn't.
Rock already understands this distinction at the Emacs level. Meow just inherits it:

- <kbd>k</kbd> `meow-kill` → kill-ring ✓ (like `C-w`)
- <kbd>d</kbd> `meow-delete` → falls back to `delete-char`, no kill-ring (like `C-d`)

This is **the same distinction he already lives with**. The new bit is just that `k`
needs the region to be active, where `C-w` always does.

### 4. Things to skip or de-emphasise.

- "Modal editing concepts" lectures — he gets it.
- Comparisons to vim — irrelevant, possibly distracting.
- Justifying why selection-first is good — he's bought in; just deliver the skills.

### 5. Things to emphasise.

- **The bridge between meow's selection world and Emacs's region world.** Where they
  meet (e.g. `e` selects a real region, `w` may not) is where the foot-guns live.
- **Where meow gives him strictly more power than vanilla Emacs:** expansion digits,
  things, beacon mode, tree-sitter selection. These are net-new capabilities, not
  re-skinned `M-d` / `M-f`.
- **Leader key + keypad mode.** A 10-year Emacs user has C-x and M-x reflexes already;
  meow's <kbd>SPC</kbd> leader and `C-c` keypad mode are how he keeps using them
  without leaving normal state.

## Open question for next session

Does he use `C-x C-x` (`exchange-point-and-mark`) in vanilla Emacs? If yes, <kbd>:</kbd>
(`meow-reverse`) maps directly onto that mental model and is a one-second teach.
