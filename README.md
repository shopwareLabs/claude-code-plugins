# Shopware Claude Code Plugins

Claude Code plugins for Shopware development. Supports all plugin types: commands, agents, skills, hooks, and MCP servers.

## Quick Start

For detailed information about using marketplaces, see the [official Claude Code marketplace documentation](https://docs.claude.com/en/docs/claude-code/plugins).

Add this marketplace to your Claude Code installation:

```bash
/plugin marketplace add shopwareLabs/claude-code-plugins
```

## Available Plugins

### comment-review (v1.1.1)

Reviews and improves code comments, focusing on explaining reasoning rather than restating code. Provides slash commands and a skill for model invocation. See [documentation](./plugins/code-quality/comment-review/README.md) for details.

```bash
/plugin install comment-review@shopware-plugins
```

**Commands:**
- `/comment-review [scope]` - Review and improve comments (makes edits)
  - Supports: files, directories, `--git` flag, commits/ranges/lists
  - Examples: `/comment-review src/`, `/comment-review --git`, `/comment-review HEAD~5..HEAD`
- `/comment-check [scope]` - Analyze comment quality (read-only, no edits)
  - Supports: files, directories, commits/ranges/lists
  - Examples: `/comment-check src/`, `/comment-check HEAD`, `/comment-check main..feature`

### codex-debugger (v1.0.0)

Escalation protocol plugin that automatically consults OpenAI Codex (GPT-5) when stuck after three failed attempts. Provides fresh analytical perspective to break out of debugging loops. See [documentation](./plugins/debugging/codex-debugger/README.md) for details.

```bash
/plugin install codex-debugger@shopware-plugins
```

**Prerequisites:**
- OpenAI Codex CLI installed (`npm install -g @openai/codex`)
- OpenAI account with Codex access (ChatGPT Plus/Pro/Team)
- Authenticated via `codex login`
- **Restart Claude Code** after installation (required for MCP server)

**Features:**
- Automatic detection of "running in circles" patterns
- Consults GPT-5 with high reasoning effort
- Gathers complete context (goal, attempts, errors, code)
- Implements Codex recommendations
- Progressive escalation (Codex → User)

**Command:**
- `/codex-check` - Verify Codex setup and availability (diagnostics)

**Agent:**
- `codex-escalation` - Invoked automatically when stuck after 3 failed attempts

## License

This marketplace structure is open source. Individual plugins have their own licenses.
