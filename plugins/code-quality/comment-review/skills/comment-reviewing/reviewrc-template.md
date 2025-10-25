---
# Comment Reviewing Configuration Template
# Copy this file to your project root as .reviewrc.md or .claude/comment-reviewing-config.md

# Files/directories to completely exclude from review
# Use glob patterns - matched files are skipped entirely
ignore_paths:
  - "vendor/**"           # Third-party dependencies
  - "node_modules/**"     # NPM packages
  - "dist/**"             # Build outputs
  - "build/**"
  - "*.min.js"            # Minified files
  - "*.min.css"
  - "*.generated.*"       # Generated files
  - "package-lock.json"   # Lock files
  - "composer.lock"
  # Add your patterns here

# Comments matching these patterns will always be preserved
# Use regex patterns - they will be matched against the comment content
preserve_patterns:
  - "@internal"           # Company/project internal annotations
  - "@api"                # Public API markers
  - "@deprecated"         # Deprecation notices
  - "PLATFORM-\\d+"       # Ticket references (adjust to your format)
  # Add your patterns here

# Required format for TODO/FIXME comments
# If specified, TODOs/FIXMEs not matching this pattern will be flagged
# Use regex with proper escaping
ticket_format: "TODO\\(\\w+\\): .+ - [A-Z]+-\\d+"
# Examples of valid formats this matches:
#   TODO(john): Refactor payment logic - JIRA-123
#   FIXME(sarah): Handle edge case - PLATFORM-456

# Paths to handle conservatively (won't auto-remove comments)
# Use glob patterns relative to project root
conservative_paths:
  - "src/Legacy/**"
  - "deprecated/**"
  - "vendor/**"
  # Add paths containing sensitive or legacy code

# Markers that exempt comments from any review
# Comments containing these strings won't be analyzed at all
exemption_markers:
  - "@generated"
  - "@noreviews"
  - "AUTO-GENERATED"
  # Add markers for generated or protected code

# Domain-specific terms that might appear redundant but provide value
# Helps prevent false positives when technical terms appear in comments
domain_terms:
  - term: "aggregate root"
    why: "DDD pattern - indicates entity lifecycle boundaries"
  - term: "bounded context"
    why: "DDD architecture - important for understanding boundaries"
  - term: "value object"
    why: "DDD pattern - immutable domain concept"
  # Add your domain vocabulary here

---

# Project Comment Review Standards

This file customizes the comment-reviewing skill for this project's specific needs.

## Our Comment Philosophy

[Describe your project's approach to code comments]

## Examples

### Ignore Paths

Files/directories completely excluded from review:
```
vendor/          # All vendor dependencies
dist/bundle.js   # Build artifacts
src/Generated/   # Generated code
```

Difference from `conservative_paths`:
- **ignore_paths**: Files are completely skipped (not reviewed at all)
- **conservative_paths**: Files are reviewed but changes require extra caution

### Preserve Pattern Examples

Comments we always keep:
```php
// @internal This method is used by the plugin system
// PLATFORM-1234: Temporary workaround for cache invalidation bug
```

### TODO Format

Valid TODO format for this project:
```typescript
// TODO(username): Specific action item - TICKET-123
```

Invalid (will be flagged):
```typescript
// TODO: fix this
```

### Domain Terms

Terms that provide context in our domain:
```python
# This is an aggregate root - manages order lifecycle
# Bounded context: Payment processing
```

## Configuration Notes

- **ignore_paths** uses glob patterns (**/ for recursive)
- **preserve_patterns** uses regex syntax
- **conservative_paths** uses glob patterns
- Configuration is optional - defaults work without this file
- Changes take effect on next skill activation
