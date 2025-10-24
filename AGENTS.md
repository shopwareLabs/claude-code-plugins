@README.md

# Shopware Claude Code Plugin Marketplace - Technical Reference

## Marketplace Architecture

### Structure
```
.claude-plugin/marketplace.json  # Main catalog
plugins/
  [category]/
    [plugin-name]/              # Plugin source directory
```

### marketplace.json Schema

The marketplace configuration follows the official Claude Code marketplace schema. See [docs/marketplace-schema.json](../docs/marketplace-schema.json) for the complete JSON Schema definition.

**Required fields:**
- `name` - Marketplace identifier in kebab-case
- `owner` - Object with at least `name` property (optionally `email`, `url`)
- `plugins` - Array of plugin definitions

**Plugin object structure:**
- `name` (required) - Plugin identifier in kebab-case
- `source` (required) - Relative path starting with `./`
- `description` - Brief description of functionality
- `version` - Semantic version string
- `author` - Object with `name`, optionally `email` and `url`
- `license` - SPDX license identifier (e.g., "MIT", "Apache-2.0")
- `keywords` - Array of tags for discovery
- `homepage` - Documentation URL
- `repository` - Source code repository URL

### Key Technical Details

- **`strict: false`**: Plugin metadata lives entirely in marketplace.json, no `plugin.json` required
- **Relative paths**: Must start with `./` from marketplace root
- **Component locations**: All component files (commands/, agents/, skills/, hooks/, .mcp.json) live at plugin root, not in `.claude-plugin/`

## Plugin Component Types

Claude Code plugins can include any combination of these components:

- **Commands** - Custom slash commands (markdown files in `commands/`)
- **Agents** - Specialized subagents (markdown files in `agents/`)
- **Skills** - Model-invoked capabilities (`skills/[skill-name]/SKILL.md`)
- **Hooks** - Event handlers (configured via `hooks/hooks.json`)
- **MCP Servers** - External tool integration (`.mcp.json` configuration)

### Skills Directory Structure

Skills follow this pattern:
```
plugin-root/
└── skills/
    └── skill-name/
        └── SKILL.md
```

Example: `plugins/code-quality/comment-reviewing/skills/comment-reviewing/SKILL.md`

## Development Workflow

### Adding a New Plugin

1. **Create plugin directory**: `plugins/[category]/[plugin-name]/`
2. **Add component files** (choose any combination):
   - `commands/` - Custom slash commands
   - `agents/` - Specialized agents
   - `skills/[skill-name]/SKILL.md` - Model-invoked skills
   - `hooks/` - Event handlers (hooks.json)
   - `.mcp.json` - MCP server configuration
3. **Update marketplace.json**:
   - Add entry to `plugins` array
   - Set `source` to relative path
   - Set `strict: false` if no plugin.json needed
   - Specify component paths (commands, agents, skills, hooks, mcpServers)
4. **Update README.md**: Add to "Available Plugins" section
5. **Validate**: `claude plugin validate .`

### Version Management

- Marketplace version: `.metadata.version` (overall catalog)
- Plugin versions: Individual `version` in plugin entries
- Bump both when making breaking changes

## Testing & Validation

### Local Testing
```bash
# Validate marketplace structure
claude plugin validate .

# Test locally before publishing
/plugin marketplace add /path/to/claude-code-plugin-marketplace
```

### Pre-release Checklist
- [ ] `claude plugin validate .` passes
- [ ] All plugin versions updated
- [ ] README.md "Available Plugins" section current
- [ ] marketplace.json metadata.version bumped if needed

## Distribution

Repository must be public with `.claude-plugin/marketplace.json` in root for GitHub distribution.
