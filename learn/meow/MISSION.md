# Mission: Meow Mastery

## Why
Rock already uses Emacs + meow daily (Dvorak layout, Elixir work) but operates well below
meow's ceiling. The goal is to edit code noticeably faster day-to-day and unlock the
advanced features (expansion, things, beacon, kmacros, tree-sitter selection) that meow
ships with but he doesn't reach for.

## Success looks like
- Expansion (`1`–`9`) and thing-based selection (`,` `.` `<` `>`) feel reflexive — no thinking about which key.
- Can execute a real refactor (rename / move / duplicate / comment across a buffer) entirely from normal state, using selection + kmacro / beacon, without dropping into insert and typing manually.

## Constraints
- Dvorak physical layout; bindings already customised (see `settings/meow-settings.el`).
- Variable time budget per session — lessons must be self-contained and short enough
  for a 5-minute window, but extensible for a 30-minute window.
- Real Emacs is the practice ground. Lessons should be runnable against actual buffers,
  not just read.

## Out of scope
- Re-learning vim/evil. Not a vim refugee — no translation lessons needed.
- Rebinding keys. Current bindings are good; teach the bindings he already has.
- General Emacs configuration. This workspace is meow-only.
