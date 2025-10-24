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
   - Add entry to `plugins` array with required fields: `name`, `source`
   - Set `source` to relative path starting with `./`
   - Add recommended fields: `description`, `version`, `author`, `license`, `keywords`, `repository`
4. **Update README.md**: Add to "Available Plugins" section
5. **Validate**: `claude plugin validate .`

### Version Management

- Plugin versions: Individual `version` field in plugin entries
- Follow semantic versioning (e.g., "1.0.0", "2.1.3")
- Bump versions when releasing updates or breaking changes

## Testing & Validation

### Local Testing
```bash
# Validate marketplace structure
claude plugin validate .

# Test locally before publishing
/plugin marketplace add /path/to/claude-code-plugins
```

### Pre-release Checklist
- [ ] `claude plugin validate .` passes
- [ ] All plugin versions updated in marketplace.json
- [ ] README.md "Available Plugins" section current

## Distribution

Repository must be public with `.claude-plugin/marketplace.json` in root for GitHub distribution.
