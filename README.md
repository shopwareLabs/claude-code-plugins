# Shopware Claude Code Plugins

A curated collection of Claude Code plugins for Shopware development. Supports all plugin types: commands, agents, skills, hooks, and MCP servers.

## Quick Start

For detailed information about using marketplaces, see the [official Claude Code marketplace documentation](https://docs.claude.com/en/docs/claude-code/plugins).

Add this marketplace to your Claude Code installation:

```bash
/plugin marketplace add shopware/claude-code-plugins
```

## Available Plugins

### comment-reviewing (v1.0.0)

Expert at reviewing and improving code comments following the "why not what" principle. Provides slash commands and a skill for model invocation. See [documentation](./plugins/code-quality/comment-reviewing/README.md) for details.

```bash
/plugin install comment-reviewing@shopware-plugins
```

**Commands:**
- `/comment-review [scope]` - Review and improve comments (makes edits)
  - Supports: files, directories, `--git` flag, commits/ranges/lists
  - Examples: `/comment-review src/`, `/comment-review --git`, `/comment-review HEAD~5..HEAD`
- `/comment-check [scope]` - Analyze comment quality (read-only, no edits)
  - Supports: files, directories, commits/ranges/lists
  - Examples: `/comment-check src/`, `/comment-check HEAD`, `/comment-check main..feature`

## License

This marketplace structure is open source. Individual plugins have their own licenses.
