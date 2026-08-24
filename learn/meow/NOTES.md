# Notes

## Setup observed from `settings/meow-settings.el`
- **Layout:** Dvorak (`meow-cheatsheet-layout-dvorak`, `meow-cheatsheet-physical-layout-iso`).
- **Movement keys** (Dvorak home row):
  - `h` left, `t` right, `n` next (down), `p` prev (up)
  - Capitalised versions extend selection: `H T N P`
- **Word / symbol motion:** `w` next-word, `W` next-symbol, `b` back-word, `B` back-symbol.
- **Selection primitives:**
  - `m`/`M` mark word / mark symbol
  - `e` line, `E` goto-line
  - `o` block, `O` to-block
  - `,` inner-of-thing, `.` bounds-of-thing, `<` beginning-of-thing, `>` end-of-thing
- **Expansion digits:** `1`–`9` expand, `0` expand-0, `:` reverse direction.
- **Insert transitions:** `i` insert, `a` append, `I` open-above, `A` open-below.
- **Edit ops:** `c` change, `d` delete, `D` backward-delete, `k` kill, `r` replace, `j` join.
- **Clipboard:** `x` save, `y` yank, `G` grab, `R` swap-grab, `X` sync-grab, `u` pop-selection.
- **Search/visit:** `s` search, `v` visit, `f` find, `l` till.
- **Custom:**
  - `/` → `rock--meow-duplicate` (duplicate region or char)
  - `?` → `rock--meow-duplicate-and-comment`
  - `;` → meow-comment
  - `'` → repeat
  - `z` undo, `Z` undo-in-selection
- **Leader (`SPC`):** `b` buffer, `f` find-file, `s` save, `o` other-window, `0/1/2/3` window ops, `/` describe-key, `?` cheatsheet.
- **meow-tree-sitter** is enabled with defaults — thing-based selection should work on tree-sitter nodes.

## Teaching preferences
- Mixed session length; lessons must work as 5-min micro or 20-min deep dive.
- Real Emacs is the practice ground — every lesson ends with "try this in a real buffer."
- Lesson HTML should open with a single CLI command. **`xdg-open` works on his system**; `open` / `zen` do not.

## Background (confirmed in session 1)
- **10+ years of standard Emacs bindings** before meow. **Not** a vim refugee.
- Anchor explanations to Emacs primitives (`C-w`, `M-w`, `C-SPC`, `M-h`, `kill-ring`).
- **Does NOT use `mark-word`, `mark-paragraph`, `mark-defun`, expand-region.** Builds
  regions manually with `C-SPC` then movement. **This is the biggest leverage point**
  — thing-based selection (`,` `.` `<` `>`) will change his daily editing more than
  any other lesson.
- For structural edits today: **query-replace + multiple-cursors**. Meow's beacon mode
  replaces multiple-cursors cleanly; teach this as Lesson 0003.
- See learning-record 0003.

## Open questions for future sessions
- Does the user know about `M-x meow-cheatsheet` already? Worth confirming early.
- Beacon mode (multi-cursor-ish) is high-value but unknown skill level.
- kmacro integration with meow selections — likely a later lesson.
