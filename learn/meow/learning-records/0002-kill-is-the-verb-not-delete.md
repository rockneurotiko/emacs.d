# 0002 — `k` (kill) is the verb, `d` (delete) is not

**Date:** 2026-06-18
**Status:** Accepted
**Discovered during:** Lesson 0001 practice.

## What Rock observed

After <kbd>w</kbd> <kbd>3</kbd> (select 3 words), pressing <kbd>d</kbd> deleted only
the next *character*, not the selection.

## Root cause

Meow distinguishes between **selection** (its own concept, with expansion hints) and
**active region** (Emacs's `region-active-p`). Most word/char motions
(<code>meow-next-word</code>, <code>meow-next-symbol</code>, <code>meow-find</code>,
etc.) leave a selection but **not** an active region by default.

`meow-delete` (bound to <kbd>d</kbd>) is documented to "support fallback behaviour" —
when there is no active region, it falls back to deleting one char forward.

`meow-kill` (bound to <kbd>k</kbd>) is the canonical "act on the current selection"
verb. It treats the selection as the argument and kills it.

Source: <https://raw.githubusercontent.com/meow-edit/meow/master/COMMANDS.org>

> *** meow-kill
> Kill current region.
> This command supports fallback behaviour. Default to `meow-C-k`.

> *** meow-change
> Delete current region and switch to INSERT state.
> This command support fallback behaviour, default to `meow-change-char`.

## Decision

Teach <kbd>k</kbd> as the default "remove the selection" verb, not <kbd>d</kbd>. Frame
<kbd>d</kbd> as "single-char delete with a smart fallback" — useful for
<kbd>d</kbd><kbd>d</kbd><kbd>d</kbd>-style char-deletes, not for selection ops.

This same trap applies to <kbd>x</kbd> (<code>meow-save</code> / copy) and <kbd>c</kbd>
(<code>meow-change</code>). The pattern is universal in meow:

| Verb after a meow selection | Use this | Don't use this |
|---|---|---|
| delete | <kbd>k</kbd> meow-kill | <kbd>d</kbd> meow-delete |
| copy | <kbd>x</kbd> meow-save | — |
| change | <kbd>c</kbd> meow-change | — |

(<kbd>x</kbd> and <kbd>c</kbd> work because they're paired with capital open-line forms;
their fallback is fine in practice. <kbd>d</kbd> is the only real foot-gun.)

## Consequence

- Update **Lesson 0001** drill instructions to use <kbd>k</kbd>, not <kbd>d</kbd>.
- Create **reference/kill-vs-delete.html** — a permanent cheat card for this
  distinction, since it will trip Rock up again later (and trips up everyone).
- In Lesson 0002 (things), be explicit: "any time the lesson says 'delete' it means
  <kbd>k</kbd>."

## Open question

Is it worth rebinding <kbd>d</kbd> to <kbd>meow-kill</kbd> in his config to remove the
trap? — No. Keeping the meow defaults pays off when reading the docs, the official
cheatsheet, and other people's meow content. Better to internalise the distinction.
