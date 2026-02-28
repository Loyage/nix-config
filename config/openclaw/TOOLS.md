# Tools

This document describes the tools available to the AI assistant.

## Available Tools

### System Tools

- **screenshot** - Capture screen content
- **clipboard** - Read/write clipboard
- **notify** - Send system notifications

### Communication

- **telegram** - Send messages via Telegram

## Usage Guidelines

1. Only use tools when necessary
2. Confirm destructive actions with the user
3. Handle tool errors gracefully
4. Report tool results clearly

## Adding New Tools

Tools can be added via plugins in the flake.nix configuration.
