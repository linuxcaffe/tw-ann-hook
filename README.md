- Project: https://github.com/linuxcaffe/tw-ann-hook
- Issues:  https://github.com/linuxcaffe/tw-ann-hook/issues

# annn

A compact annotation manager for Taskwarrior — create, list, edit, and remove
annotations from your terminal, with an optional hook for auto-prompting on
task completion or deletion.

---

## TL;DR

- Create and edit annotations in your editor, not inline
- Pipe annotations directly: `echo "quick note" | annn 42`
- List annotations with numbered indexes
- Remove annotations with confirmation
- Compact dot-syntax: `annn 42.1` to edit, `annn -42.1` to remove
- Optional hook: auto-prompt for annotation when completing or deleting `+ann` tasks
- Works standalone or as a tw wrapper: `tw 42 ann.1`
- Designed for Taskwarrior 2.6.2

---

## Why this exists

Taskwarrior's built-in `annotate` command works, but it's limited to a single
inline string. There's no way to edit an existing annotation, no way to pick
one by index, and writing anything longer than a sentence on the command line
is painful.

`annn` makes annotations a first-class workflow — open your editor, write what
you need, and get back to work. The companion hook ensures you never forget to
document why a task was completed or deleted.

---

## Three components

### 1. `annn` — CLI annotation manager

A standalone bash script for creating, listing, editing, and removing
annotations by index. Supports both interactive (editor) and non-interactive
(pipe) input.

### 2. `on-exit_annn.py` — Auto-annotation hook

A Taskwarrior on-exit hook that watches for tasks tagged `+ann`. When one is
completed or deleted, it opens your editor for a final annotation — a closing
note, a reason for deletion, or whatever context you want to preserve.

### 3. tw wrapper integration

When installed via awesome-taskwarrior, `annn` registers as a tw wrapper,
enabling `tw 42 ann.1` syntax. tw dispatches to `annn` automatically — no
changes to tw required.

Each component works independently. Use one, two, or all three.

---

## CLI usage

```
annn <id>                New annotation (opens $EDITOR)
annn <id>.               List annotations with index numbers
annn <id>.<N>            Edit annotation N
annn -<id>.<N>           Remove annotation N (with confirmation)
echo "text" | annn <id>  Annotate from pipe (no editor)
```

Space-separated form also works: `annn 42 .1` is the same as `annn 42.1`.

When opening the editor, `annn` shows the task context with annotation count:

```
[annn] Task 42: assemble realed expenses (3 annotations)
```

The editor opens a descriptively named temp file so you always know what
you're annotating:

```
/tmp/annn_42_assemble-realed-expenses.Xk9f3m.md
```

---

## CLI examples

Add a new annotation to task 42:

```bash
annn 42
# [annn] Task 42: assemble realed expenses (2 annotations)
# Editor opens — write your annotation, save, quit
# [annn] Annotation added to task 42
```

Pipe a quick note without opening the editor:

```bash
echo "called vendor, waiting for callback" | annn 42
# [annn] Annotation added to task 42
```

Pipe command output:

```bash
git log --oneline -1 | annn 42
date "+Started %Y-%m-%d %H:%M" | annn 42
```

List annotations on task 42:

```bash
annn 42.
# Task 42: assemble realed expenses
# ---
#   .1   [2026-02-17 12:52]
#        first annotation text
#
#   .2   [2026-02-17 13:10]
#        second annotation text
```

Edit the first annotation:

```bash
annn 42.1
# [annn] Task 42: assemble realed expenses (2 annotations)
# Editor opens with current text — edit, save, quit
# [annn] Annotation .1 updated on task 42
```

Remove the second annotation:

```bash
annn -42.2
# Task 42: assemble realed expenses
# ---
#   .2   [2026-02-17 13:10]
#        second annotation text
#
# Remove this annotation? [y/N]: y
# [annn] Annotation .2 removed from task 42
```

---

## tw wrapper usage

When installed via awesome-taskwarrior, all `annn` commands are available
through tw:

```bash
tw 42 ann          # new annotation
tw 42 ann.         # list annotations
tw 42 ann.1        # edit annotation 1
tw 42 -ann.1       # remove annotation 1
echo "note" | tw 42 ann   # pipe input
```

tw detects the `ann` keyword, translates the arguments, and dispatches to
`annn`. The wrapper registration happens automatically during installation.

---

## Hook usage

Tag any task with `+ann` to enable auto-annotation:

```bash
task add "Resolve billing dispute" +ann due:friday
```

When you complete or delete it, the hook opens your editor:

```bash
task 42 done
# [annn] Task 42: Resolve billing dispute
# [annn] Event: completed
# [annn] Opening editor for annotation...
#
# (editor opens — write your closing note, save, quit)
#
# [annn] Annotation saved.
```

The annotation is saved to the task after the editor closes. Empty saves
are skipped. The hook uses `rc.hooks=off` when saving to avoid re-triggering
itself.

---

## Configuration

The hook reads `annn.rc` for settings:

```ini
# Tag that triggers auto-annotation (default: ann)
annn.tag=ann

# Trigger on task completion (default: yes)
annn.on_complete=yes

# Trigger on task deletion (default: yes)
annn.on_delete=yes

# Editor override (leave empty for $EDITOR, defaults to vim)
annn.editor=
```

---

## Installation

### CLI only

Copy `annn` somewhere on your `$PATH`:

```bash
cp annn ~/.local/bin/
chmod +x ~/.local/bin/annn
```

### Hook

```bash
cp on-exit_annn.py ~/.task/hooks/
chmod +x ~/.task/hooks/on-exit_annn.py
cp annn.rc ~/.task/config/
echo 'include ~/.task/config/annn.rc' >> ~/.taskrc
```

### Via awesome-taskwarrior (recommended)

```bash
tw --install annn
```

This installs all components and registers the tw wrapper automatically.

**Requirements:**
- Taskwarrior 2.6.2
- Bash 4.0+ (CLI)
- Python 3.6+ (hook)
- A terminal editor (`$EDITOR` or vim)

---

## Debugging

Enable debug logging for the hook:

```bash
export DEBUG_ANNN=1
task 42 done
cat ~/.task/logs/debug/annn_debug.log
```

---

## Project status

Working and stable for daily use.

The annotation API in Taskwarrior 2.6.2 has some inherent limitations
(denotation matches by text content, not by index), but `annn` handles
these edge cases gracefully.

---

## Metadata

- Version: 0.5.0
- License: MIT
- Language: Bash (CLI), Python (hook)
- Interface: CLI + `$EDITOR`
- Platforms: Linux
