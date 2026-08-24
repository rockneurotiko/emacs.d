# 0005 — `e4` selects 4 lines, `.l4` doesn't (necessarily)

**Date:** 2026-06-18
**Status:** Accepted
**Discovered during:** Lesson 0003 beacon drill.

## What Rock reported

> ".l4 don't work for me, I have to do e4"

## Root cause

There are two ways to "select this line" in meow, with different selection types:

- <kbd>e</kbd> (`meow-line`) — **selection type: `expand line`**. Digits after it
  expand the line-count. This is the canonical form.
- <kbd>.</kbd><kbd>l</kbd> (`meow-bounds-of-thing` on `line`) — selects the current
  line as a *thing*. Not an `expand`-type selection. Digit expansion behaviour
  differs.

From `COMMANDS.org`:

> *** meow-line
> Selection type: `expand line`
> Select current line.

Thing-selection (`,` `.` `<` `>`) is a different category from the `expand *`
selection types. The digit-expansion overlay hooks into `expand *` selections.

## Decision

**Teach <kbd>e</kbd> as THE way to grab lines.** Reserve <kbd>.</kbd><kbd>l</kbd> for
cases where the "line as a thing" semantics are actually needed (which is rare — I
can't think of a case where I'd prefer it over `e`).

Update lesson 0003 and reference cards to only show `eN`, not `.lN`.

## Broader lesson for me (the teacher)

I conflated "thing-selection" with "the general way to select structural units". They
overlap but they're not identical. Meow has multiple orthogonal selection systems:

1. **Char/word cursor motions** (`h t n p w b f l`) — often produce a "soft" selection
   that isn't `region-active-p`. See learning-record 0002.
2. **Expand-* selections** (`e` line, `o` block, `m` word, `M` symbol, capital H/T/N/P).
   These are the real "grow this and act on it" family. Digits expand cleanly.
3. **Things** (`,` `.` `<` `>` + second key). Structural, but a different beast.
4. **Secondary selection** (`G` grab). For beacon.

When a lesson needs "select N of X", the answer is usually in family 2 (expand-*), not
family 3 (things). Things shine for "the inside of this string" and "the whole
paragraph" — one-shot structural grabs, not repeated-unit grabs.

I owe Rock a reference card that lays out these four families side by side.
