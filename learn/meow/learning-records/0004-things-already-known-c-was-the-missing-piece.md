# 0004 — Things already known; `c` (change) was the missing piece

**Date:** 2026-06-18
**Status:** Accepted
**Discovered during:** Lesson 0002 (things).

## What Rock reported

> "I was already using `.` and `,` for strings, curly, ... I didn't remember the `c`
> to change the contents, great lesson."

## Recalibration

**He already has thing-based selection in his hands** for at least: strings (`g`),
curly (`c`), and by implication likely round (`r`) and square (`s`) too. The "use
things instead of `C-SPC`+move" leverage point was overstated — he's *partially* there
already.

**The actual missing piece was the verb side of the equation:** he selects with
things, but then doesn't follow up with <kbd>c</kbd> (`meow-change`) to perform the
edit in one go. The structural-selection side was solid; the **selection-as-argument
follow-through** was the gap.

This is consistent with what learning-record 0001 hypothesised: the mental model that
ties selection + verb together wasn't yet reflexive. Lesson 0001 introduced it via
expansion; Lesson 0002 introduced thing-selection; Lesson 0002's "Apply" drill
(<kbd>,</kbd><kbd>g</kbd><kbd>c</kbd>) is where it clicked.

## What this tells me about his level

- **Selection vocabulary:** strong (better than I assumed). Things are partly
  internalised.
- **Verb vocabulary:** weak. He knows verbs exist (<kbd>k</kbd>, <kbd>c</kbd>,
  <kbd>;</kbd>, <kbd>/</kbd>, <kbd>?</kbd>) but doesn't chain them onto selections by
  default.
- **The compose habit:** developing. He's now noticing the pattern.

## Adjustment for upcoming lessons

- **Don't dwell on "things are great" content.** He already knows.
- **Spend more time on the verb side and on composition patterns.** Lessons should
  show flows like:
  - <kbd>,</kbd><kbd>g</kbd><kbd>c</kbd> — change the inside of a string
  - <kbd>.</kbd><kbd>d</kbd><kbd>k</kbd> — kill a whole function
  - <kbd>.</kbd><kbd>p</kbd><kbd>;</kbd> — comment a paragraph
  - <kbd>.</kbd><kbd>l</kbd><kbd>3</kbd><kbd>/</kbd> — duplicate 3 lines (his custom)
  - <kbd>,</kbd><kbd>r</kbd><kbd>x</kbd> — copy what's inside the parens
- **Push him toward less-obvious verbs.** He doesn't reach for <kbd>R</kbd>
  (`meow-swap-grab`), <kbd>X</kbd> (`meow-sync-grab`), <kbd>j</kbd> (`meow-join`),
  <kbd>u</kbd> (`meow-pop-selection`). These could each be 5-minute lessons.

## Lesson 0003 implication

Original plan was beacon mode. That's still right — beacon is a *new* selection type
(secondary selection) that he doesn't have at all. But the framing should lean on the
selection+verb composition habit, which is now within his reach, not on "here's
multi-cursor."

The shape: secondary selection IS the same selection-first model, just doubled.
Beacon = "do my next edit at every cursor in this secondary selection."
