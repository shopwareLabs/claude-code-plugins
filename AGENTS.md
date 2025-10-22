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

```json
{
  "name": "marketplace-name",           // Kebab-case identifier
  "owner": { "name", "email", "url" },  // Maintainer info
  "metadata": {
    "description": "...",               // Brief overview
    "version": "1.0.0"                  // Marketplace version
  },
  "plugins": [
    {
      "name": "plugin-name",            // Required
      "source": "./plugins/path",       // Required: relative path
      "description": "...",             // Recommended
      "version": "1.0.0",               // Plugin version
      "category": "code-quality",       // Organization tag
      "strict": false,                  // If true, requires plugin.json
      // Component paths (specify which components this plugin provides):
      "commands": "commands/",          // Custom slash commands
      "agents": "agents/",              // Specialized agents
      "skills": ["skill-name"],         // Model-invoked skills
      "hooks": "hooks/",                // Event handlers
      "mcpServers": ".mcp.json",        // MCP server configuration
      // Optional metadata:
      "author", "license", "keywords", "homepage", "repository"
    }
  ]
}
```

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
