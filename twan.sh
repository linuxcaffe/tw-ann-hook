#!/usr/bin/env bash
#
# Helper for adding annotations to TaskWarrior tasks.
# Features:
# - Add multi-line annotations to your tasks using your preferred editor.
# - Add single-line annotations as always (via cli arguments) or using the editor.
#
# Copyright (C) 2021 Rafael Cavalcanti - rafaelc.org
# Copyright (C) 2016 djp <djp@cutter>
#
# Distributed under terms of the MIT license.
#

# Constants
readonly script_name="$(basename "$0")"
readonly editor="${EDITOR:-vi}"

# Read arguments
readonly id="${1:-}"
shift
annot="$*"

# Check arguments
if [[ ! $id =~ ^[0-9a-f]+$ ]]; then
    echo "Usage: $script_name task_id [annotation]"
    exit 1
fi

# Use annotation from CLI if provided
if [[ -n "$annot" ]]; then
    task "$id" annotate "$annot"
    exit 0
fi

# Use annotation from editor
readonly annot_file="$(mktemp)"
$editor "$annot_file"

if [[ "$(wc -l "$annot_file" | cut -d ' ' -f 1)" -gt 1 ]]; then
    annot="\n$(cat "$annot_file")"
else
    annot="$(cat "$annot_file")"
fi

task "$id" annotate "$annot"

rm "$annot_file"

