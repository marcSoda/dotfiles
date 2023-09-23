#!/usr/bin/env python3

import sys
import json

# Load the task from stdin
task = json.load(sys.stdin)

# Check if "description" contains % and replace it with 'pro:'
if "%" in task["description"]:
    parts = task["description"].split(" ")
    for i, part in enumerate(parts):
        if part.startswith("%"):
            task["project"] = part[1:]
            parts[i] = ""
    task["description"] = " ".join(parts).strip()

# Print the modified task
print(json.dumps(task))
