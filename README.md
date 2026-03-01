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
- Label syntax: `annn 42.status` to edit/create the `status:` annotation
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
annn <id>                  New annotation (opens $EDITOR, prompts for label)
annn <id>.                 List annotations with index numbers
annn <id>.<N>              Edit annotation N by index
annn <id>.<label>          Edit/create annotation by label
annn -<id>.<N>             Remove annotation N (with confirmation)
annn -<id>.<label>         Remove annotation by label (with confirmation)
echo "text" | annn <id>    Annotate from pipe (no editor)
echo "text" | annn <id>.<label>  Pipe with label prefix
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

## Labels

An annotation label is a leading `word: ` prefix — a single word followed by
a colon and space at the start of the annotation text:

```
status: blocked waiting for vendor callback
link: https://ticket.example.com/TKT-42
reason: duplicate of task 17
```

Labels are entirely optional. Any annotation can have one, none are required,
and they can be added by `annn` or by any other means. The label is just part
of the annotation text — no UDAs or extra configuration needed.

**`note:` is reserved** for the tasknotes function and cannot be used as a
label in `annn`.

### Addressing by label

```bash
annn 42.status           # edit the "status:" annotation (create if absent)
annn 42.status text...   # set inline: saves as "status: text..."
echo "url" | annn 42.link  # pipe: saves as "link: url"
annn -42.status          # remove the "status:" annotation
```

If no `status:` annotation exists, `annn` opens the editor pre-populated with
`status: ` so the label is already in place.

If multiple annotations share the same label, `annn` lists them and prompts
for a selection before editing or removing.

### Label prompt on new annotations

When creating a new annotation interactively (`annn 42`), `annn` offers an
optional label prompt before opening the editor:

```
[annn] Task 42: Fix billing discrepancy (1 annotation)
[annn] Label (optional, e.g. status, link — Enter to skip):
```

Press Enter to skip; type a label name to pre-populate the editor with
`label: `.

### List display

Labels are highlighted in the annotation list:

```bash
annn 42.
# Task 42: Fix billing discrepancy
# ---
#   .1   [2026-02-17 12:52]
#        status: blocked waiting for vendor callback
#
#   .2   [2026-02-17 13:10]
#        link: https://ticket.example.com/TKT-42
#
#   .3   [2026-02-17 14:00]
#        general note without a label
```

---

## tw wrapper usage

When installed via awesome-taskwarrior, all `annn` commands are available
through tw:

```bash
tw 42 ann            # new annotation
tw 42 ann.           # list annotations
tw 42 ann.1          # edit annotation 1
tw 42 -ann.1         # remove annotation 1
tw 42 ann.status     # edit/create "status:" annotation
tw 42 -ann.status    # remove "status:" annotation
echo "note" | tw 42 ann         # pipe input
echo "url" | tw 42 ann.link     # pipe with label
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

- Version: 0.6.0
- License: MIT
- Language: Bash (CLI), Python (hook)
- Interface: CLI + `$EDITOR`
- Platforms: Linux
