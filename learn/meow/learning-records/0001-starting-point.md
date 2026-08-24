# 0001 — Starting point

**Date:** 2026-06-18
**Status:** Accepted

## Context

First session. Rock is a daily Emacs + meow user on Dvorak with a customised binding set
(see `settings/meow-settings.el`). He says he doesn't use meow to its full potential and
wants two things: edit code faster day-to-day, and unlock advanced features (expansion,
things, beacon, kmacros, tree-sitter selection).

## What I'm assuming about his current level

Inferred from the fact he wrote and maintains the meow config himself:

- **Knows:** the movement layer (`h t n p` and capitals), basic verbs (`c d k r`),
  insert transitions (`i a I A`), undo (`z`), save/yank (`x y`), leader key (`SPC`),
  custom duplication on `/` and `?`.
- **Probably weak on:** the *mental model* that ties expansion, things, reverse, and
  motion-then-verb into one idea. The bindings are configured but he says they feel
  unused.
- **Almost certainly hasn't drilled:** expansion digits (`1`–`9`), `:` reverse,
  thing-based selection (`,` `.` `<` `>`), beacon mode (secondary selection), kmacros
  over selections, meow-tree-sitter selectors.

## Decision

Start at the conceptual root, not at a flashy feature. Lesson 0001 teaches
**selection-as-argument** through the smallest possible mechanic: expansion as a
prefix-argument-after-the-motion. Two reasons:

1. Every advanced feature he wants (things, beacon, tree-sitter selection) is just
   another way to *shape a selection*. If the selection-first idea isn't reflexive,
   advanced features will feel like 50 disconnected bindings.
2. Expansion is a quick win — visible payoff in 5 minutes, runnable on a real buffer,
   no setup.

## Consequence

- Lesson 0002 will be **things** (`,` `.` `<` `>`), keeping the same selection-first
  shape. After that, beacon mode is the natural next step (selection → secondary
  selection → multi-edit).
- I have not yet confirmed Rock has used `M-x meow-cheatsheet` — worth checking at
  start of next session, since it's the single best self-service reference for his
  exact bindings.
- meow-tree-sitter is installed; thing-based selection should give him function/class
  selection "for free" once we get to lesson 0002. That's a hook into a tangible Elixir
  win.

## Open question

Does he know the difference between `,` (inner-of-thing) and `.` (bounds-of-thing)?
This is the most common confusion meow newcomers carry forever. Worth a directed
question in lesson 0002.
