# 0006 — Beacon only uses `i` / `a` / `c` to start the kmacro. Not `I` / `A`.

**Date:** 2026-06-18
**Status:** Accepted
**Discovered during:** Lesson 0003 beacon "add @spec above every def" drill.

## What Rock reported

> "Press I (your meow-open-above) — doesn't work. It looks like in beacon mode it's
> different bindings, and they might be wrong. I see duplicate bindings."

## Root cause

Meow's official state diagram (from TUTORIAL.org):

```
NORMAL ──enter secondary selection──▶ BEACON
BEACON ──i/a/c──▶ INSERT
```

The transition arrow is **explicitly `i/a/c`**, not `i/a/c/I/A`. Only these three
commands enter INSERT state from BEACON with kmacro recording enabled:

- <kbd>i</kbd> `meow-insert`
- <kbd>a</kbd> `meow-append`
- <kbd>c</kbd> `meow-change`

<kbd>I</kbd> (`meow-open-above`) and <kbd>A</kbd> (`meow-open-below`) do enter INSERT
from NORMAL, but they aren't part of the beacon-to-insert transition. When Rock
pressed `I` in BEACON, it likely either (a) did nothing coherent at the fake cursors,
or (b) triggered the NORMAL-state binding without setting up the kmacro replay.

The "duplicate bindings" he saw is a real observation, not a bug: `I` is bound in
NORMAL state to `meow-open-above`; in BEACON state it may resolve differently or fall
through. Meow states each have their own keymap, and BEACON's keymap doesn't
include `I` as a kmacro-starter.

## Decision

**Teach the beacon workflow using only `i`, `a`, `c`.** For workflows that would
naturally want "open a new line above", teach the workaround:

- Move cursor to start-of-line first (with meow motion, still in BEACON).
- Press <kbd>i</kbd> to start recording.
- Type the content, then a newline character.
- <kbd>ESC</kbd>.

Or use the general kmacro path (F3 / F4) which the tutorial mentions as the "generally"
option and which supports any command sequence.

## Fix to Lesson 0003

The "add @spec above every def" drill is wrong as written. Replace with either:

**Option A** — record from line start:
1. Grab 4 lines as secondary. Move cursor in. Beacon active.
2. Move cursor to start of one of the def lines (`.l` or just `h` to column 0).
3. `e` — fake regions per line.
4. `i` — enter insert (at start of line for line-selections).
5. Type `@spec todo\n`. ESC.

**Option B** — use the general F3/F4 workflow:
1. Grab, move in, `e` for fake regions.
2. `F3` — start kmacro.
3. Do the edit however: `I` (open-above) works here because the recording captures
   the keystrokes, and F3 explicitly puts you in "capture mode".
4. `F4` — end and apply.

I'll go with Option A in the lesson because it stays inside meow's own state model.
Mention Option B as a footnote for when you want more freedom.

## Broader lesson for me (the teacher)

I assumed the normal-state keymap was fully available in BEACON. It isn't. States in
meow have their own keymaps, and BEACON is designed narrowly around the kmacro
workflow. When teaching a state, I need to check its keymap explicitly, not assume it
inherits from NORMAL.

Same likely applies to MOTION state and KEYPAD — different keymaps, different verbs
available. Worth checking before teaching them.

## Open question

Should I test the fix in a real Emacs session before writing it up? Yes ideally, but
I can't run Emacs here. I'll document Option A conservatively and ask Rock to verify.
If Option A also has quirks, I'll adjust based on his report.
