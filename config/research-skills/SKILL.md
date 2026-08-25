---
name: research-skills
description: Manual entry point for the research skill collection. Use this only when the user explicitly asks to activate the research toolkit for the current task.
disable-model-invocation: true
---

# Research Skills Collection

This is the manual entry point for all skills in the sibling directories of
this file.

When this skill is invoked, inspect the immediate subdirectories under this
directory, identify the skills relevant to the user's request, and read their
`SKILL.md` files before proceeding. Follow the selected skills' instructions,
including their references, assets, and scripts.

Do not load or invoke the research skills automatically before this entry point
is manually selected.
