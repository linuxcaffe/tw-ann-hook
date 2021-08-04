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

set -euo pipefail

trap 'echo An error ocurred.' ERR
trap '[[ -n ${annot_file:-} ]] && rm -f "$annot_file"' EXIT

# Constants
readonly script_name="$(basename "$0")"
readonly editor="${EDITOR:-vi}"

usage() {
    echo "Usage: $script_name filter [annotation]"
    echo "Filter must be provided in only one argument, quote if needed."
    exit 1
}

# Read arguments
[[ $# -eq 0 ]] && usage
readonly filter="$1"
shift
annot="$*"

# Check if any task exists
if ! task info "$filter" > /dev/null 2>&1; then
    echo "No tasks found."
    exit 1
fi

# Use annotation from CLI if provided
if [[ -n "$annot" ]]; then
    task $filter annotate "$annot"
    exit 0
fi

# Use annotation from editor
# Add file extension to get syntax highlighting
readonly annot_file="$(mktemp).md"
$editor "$annot_file"

if [[ "$(wc -l "$annot_file" | cut -d ' ' -f 1)" -gt 1 ]]; then
    annot="\n$(cat "$annot_file")"
else
    annot="$(cat "$annot_file")"
fi

# Print annotation if error saving, otherwise the user will lose it
if ! task $filter annotate "$annot"; then
    echo "Error annotating task. Here is your annotation:"
    echo
    echo "$annot"
fi

