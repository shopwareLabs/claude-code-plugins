# Comment Reviewing Configuration: Quick Start

Quick start guide for customizing the comment-reviewing skill with `.reviewrc.md` configuration.

## Table of Contents

- [Overview](#overview)
- [Configuration File Location](#configuration-file-location)
- [Configuration Format](#configuration-format)
- [Configuration Options Summary](#configuration-options-summary)
- [Complete Configuration Example](#complete-configuration-example)
- [Testing Your Configuration](#testing-your-configuration)

## Overview

The comment-reviewing skill can be customized using a `.reviewrc.md` configuration file. This allows you to:

- Exclude files/directories from review entirely
- Preserve project-specific annotations and markers
- Enforce custom TODO/FIXME formats
- Protect legacy code from automatic changes
- Define domain-specific terminology
- Exempt generated code from review

**Configuration is completely optional.** The skill works perfectly without any configuration using sensible defaults.

## Configuration File Location

The skill searches for configuration in this order (first found wins):

1. **Project root**: `.reviewrc.md`
   - Best for team-shared configuration
   - Committed to git and shared with all team members
   - Easy to discover and edit

2. **Claude directory**: `.claude/comment-reviewing-config.md`
   - Alternative if you prefer centralizing Claude configs
   - Also committed to git

3. **User home**: `~/.claude/skills/comment-reviewing/user-config.md`
   - Personal overrides (not shared with team)
   - Use sparingly - prefer project-level config

4. **Defaults**: Built-in skill behavior if no config found

**Recommendation**: Use `.reviewrc.md` in your project root for team-shared standards.

## Configuration Format

The configuration file uses Markdown with YAML frontmatter:

```yaml
---
ignore_paths: [...]
preserve_patterns: [...]
ticket_format: "..."
conservative_paths: [...]
exemption_markers: [...]
domain_terms: [...]
---

# Optional markdown documentation
Your team's comment standards and examples go here...
```

## Configuration Options Summary

### 1. ignore_paths
**Type**: Array of glob patterns
**Purpose**: Files/directories to completely exclude from review

```yaml
ignore_paths:
  - "vendor/**"
  - "node_modules/**"
  - "*.min.js"
```

### 2. preserve_patterns
**Type**: Array of regex patterns
**Purpose**: Comments matching these patterns are never removed or modified

```yaml
preserve_patterns:
  - "@internal"
  - "JIRA-\\d+"
  - "Copyright \\d{4}"
```

### 3. ticket_format
**Type**: String (regex pattern)
**Purpose**: Required format for TODO/FIXME comments

```yaml
ticket_format: "TODO\\(\\w+\\): .+ - [A-Z]+-\\d+"
```

### 4. conservative_paths
**Type**: Array of glob patterns
**Purpose**: Paths where changes require extra approval

```yaml
conservative_paths:
  - "src/Legacy/**"
  - "deprecated/**"
```

### 5. exemption_markers
**Type**: Array of strings
**Purpose**: Comments containing these markers are exempt from review

```yaml
exemption_markers:
  - "@generated"
  - "DO NOT EDIT"
```

### 6. domain_terms
**Type**: Array of objects with `term` and `why` properties
**Purpose**: Domain-specific terminology to preserve

```yaml
domain_terms:
  - term: "aggregate root"
    why: "DDD pattern indicating entity lifecycle boundaries"
```

For detailed documentation of each option, see `config-options-reference.md`.

## Complete Configuration Example

Here's a real-world configuration for a Shopware plugin:

```yaml
---
ignore_paths:
  - "vendor/**"
  - "node_modules/**"
  - "public/bundles/**"
  - "var/**"
  - "*.min.js"
  - "*.min.css"

preserve_patterns:
  - "@internal"
  - "@api"
  - "@experimental"
  - "PLATFORM-\\d+"
  - "NEXT-\\d+"
  - "@see https://"

ticket_format: "TODO\\(\\w+\\): .+ - (PLATFORM|NEXT)-\\d+"

conservative_paths:
  - "src/Core/Migration/**"
  - "src/Legacy/**"

exemption_markers:
  - "@generated"
  - "AUTO-GENERATED"
  - "DO NOT EDIT"

domain_terms:
  - term: "aggregate root"
    why: "DDD pattern - entity managing its lifecycle"
  - term: "entity"
    why: "Shopware data model with identity"
  - term: "repository"
    why: "Data access layer abstraction"
  - term: "context"
    why: "Shopware request context with permissions"
---

# Shopware Plugin Comment Standards

## Philosophy
Comments explain WHY, not WHAT. Code is self-documenting for the "what".

## Required TODO Format
```php
// TODO(username): Specific action - PLATFORM-12345
```

## Protected Annotations
- `@internal` - Plugin system internals
- `@api` - Public API markers for BC guarantees
- `@experimental` - Features in development
```

## Testing Your Configuration

After creating `.reviewrc.md`:

1. **Run the skill**: `Review comments in [your-file]`
2. **Check the report header** for configuration status:
   ```
   Configuration: Loaded from .reviewrc.md (3 preserve patterns, 1 ticket format, 2 conservative paths)
   ```
3. **Verify patterns work**: Test with comments matching your patterns
4. **Adjust as needed**: Iterate on patterns based on results

### Validation Checklist

- [ ] Regex patterns are properly escaped (`\\d` not `\d`)
- [ ] Glob paths are relative to project root
- [ ] Ticket format matches your team's standard
- [ ] Domain terms cover your vocabulary
- [ ] Conservative paths protect sensitive code

## Error Handling

The skill handles configuration errors gracefully:

### Missing Config File
- **Behavior**: Uses default rules silently
- **No error message** - skill works normally

### Invalid YAML Syntax
- **Behavior**: Warns user, continues with defaults
- **Message**: "Warning: Could not parse .reviewrc.md - using default rules"

### Invalid Regex Pattern
- **Behavior**: Warns about specific pattern, skips it
- **Message**: "Warning: Invalid regex in preserve_patterns: '@internal[' - skipping"
- **Other patterns**: Continue working normally

### Invalid Glob Pattern
- **Behavior**: Warns about specific path, skips it
- **Message**: "Warning: Invalid glob in conservative_paths: 'src/[' - skipping"

## Next Steps

- **Detailed option documentation**: See `config-options-reference.md`
- **Common patterns and recipes**: See `config-recipes.md`
- **Quick template**: See `reviewrc-template.md` in skill root directory
