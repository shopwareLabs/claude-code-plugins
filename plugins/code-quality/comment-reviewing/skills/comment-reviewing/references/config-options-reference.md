# Configuration Options: Detailed Reference

Complete reference for all comment-reviewing configuration options.

## Table of Contents

- [1. ignore_paths: Exclude Files from Review](#1-ignore_paths-exclude-files-from-review)
- [2. preserve_patterns: Protect Specific Comment Patterns](#2-preserve_patterns-protect-specific-comment-patterns)
- [3. ticket_format: Enforce TODO/FIXME Standards](#3-ticket_format-enforce-todofixme-standards)
- [4. conservative_paths: Extra Caution for Specific Files](#4-conservative_paths-extra-caution-for-specific-files)
- [5. exemption_markers: Skip Comments with Markers](#5-exemption_markers-skip-comments-with-markers)
- [6. domain_terms: Preserve Project Terminology](#6-domain_terms-preserve-project-terminology)

## 1. ignore_paths: Exclude Files from Review

**Type**: Array of glob patterns
**Purpose**: Files/directories to completely exclude from review - matched files are skipped entirely

### Use Cases
- Third-party dependencies (vendor/, node_modules/)
- Build artifacts (dist/, build/, out/)
- Minified files (*.min.js, *.min.css)
- Generated code (*.generated.*, auto-generated files)
- Lock files (package-lock.json, composer.lock)

### Example

```yaml
ignore_paths:
  - "vendor/**"
  - "node_modules/**"
  - "dist/**"
  - "build/**"
  - "*.min.js"
  - "*.min.css"
  - "*.generated.*"
  - "package-lock.json"
  - "composer.lock"
```

### Glob Pattern Syntax
- `**` - Matches any number of directories
- `*` - Matches any characters in a filename
- `?` - Matches single character
- Patterns are relative to project root

### Behavior
- Matched files are completely skipped - not analyzed at all
- No review results generated for ignored files
- More efficient than `conservative_paths` (no file reading needed)

### Comparison with Other Options
- **ignore_paths**: Files completely skipped (most restrictive)
- **exemption_markers**: Comments within files are skipped based on markers
- **conservative_paths**: Files are reviewed but changes handled carefully

## 2. preserve_patterns: Protect Specific Comment Patterns

**Type**: Array of regex patterns
**Purpose**: Comments matching these patterns are always preserved, never removed or modified

### Use Cases
- Project-specific annotations (`@internal`, `@shopware`, `@api`)
- Ticket reference formats (`JIRA-\d+`, `PLATFORM-\d+`)
- Company standards markers
- Legal/license headers

### Example

```yaml
preserve_patterns:
  - "@internal"
  - "@api"
  - "@deprecated"
  - "PLATFORM-\\d+"
  - "JIRA-[A-Z]+-\\d+"
  - "Copyright \\d{4}"
```

### Pattern Matching
- Patterns are matched against the comment content (without comment delimiters)
- Use proper regex escaping (`\\d` for digit, `\\w` for word character)
- Partial matches count (pattern found anywhere in comment)
- Case-sensitive by default

### Examples of Preserved Comments

```php
// @internal This method is used by the plugin system
// PLATFORM-1234: Workaround for cache invalidation
// Copyright 2025 ACME Corp
```

## 3. ticket_format: Enforce TODO/FIXME Standards

**Type**: String (regex pattern)
**Purpose**: Required format for TODO/FIXME comments. TODOs not matching will be flagged for human review

### Use Cases
- Enforce company TODO standards
- Require owner attribution
- Require ticket references
- Ensure actionable TODOs

### Common Formats

```yaml
# Format: TODO(owner): description - TICKET-123
ticket_format: "TODO\\(\\w+\\): .+ - [A-Z]+-\\d+"

# Format: TODO @owner: description (TICKET-123)
ticket_format: "TODO @\\w+: .+ \\([A-Z]+-\\d+\\)"

# Format: FIXME(owner, YYYY-MM-DD): description
ticket_format: "(TODO|FIXME)\\(\\w+, \\d{4}-\\d{2}-\\d{2}\\): .+"

# Format: TODO: description - https://github.com/user/repo/issues/123
ticket_format: "TODO: .+ - https://github\\.com/.+/issues/\\d+"
```

### Valid Examples (for first format)

```typescript
// TODO(alice): Refactor payment logic - JIRA-123
// FIXME(bob): Handle null case - PLATFORM-456
// TODO(charlie): Add validation - TICKET-789
```

### Invalid Examples (will be flagged)

```typescript
// TODO: fix this
// FIXME later
// TODO(alice): needs ticket reference
```

**Note**: If `ticket_format` is not specified, the skill uses default TODO/FIXME validation (requires owner and ticket reference in any format).

## 4. conservative_paths: Extra Caution for Specific Files

**Type**: Array of glob patterns
**Purpose**: Paths where the skill operates conservatively - comments are analyzed but not auto-removed

### Use Cases
- Legacy code that's sensitive to changes
- Vendor/third-party code
- Deprecated modules scheduled for removal
- Areas requiring extra caution

### Example

```yaml
conservative_paths:
  - "src/Legacy/**"
  - "deprecated/**"
  - "vendor/**"
  - "third-party/**"
  - "src/Core/Migration/**"
```

### Glob Pattern Syntax
- `**` - Matches any number of directories
- `*` - Matches any characters in a filename
- `?` - Matches single character
- Patterns are relative to project root

### Behavior in Conservative Paths
- Comments are still analyzed and reported
- Redundant comments are flagged but not auto-removed
- User receives report but must manually approve changes
- Preserves safety in sensitive code

### Comparison with ignore_paths
- **ignore_paths**: Files never read - completely skipped
- **conservative_paths**: Files read and analyzed, but changes require extra approval

## 5. exemption_markers: Skip Comments with Markers

**Type**: Array of strings
**Purpose**: Comments containing these markers are completely exempt from review

### Use Cases
- Generated code markers
- Tool-specific annotations
- License headers you don't want flagged
- Protected documentation

### Example

```yaml
exemption_markers:
  - "@generated"
  - "@noreviews"
  - "AUTO-GENERATED"
  - "DO NOT EDIT"
  - "eslint-disable"
  - "phpcs:disable"
```

### Matching
- Case-sensitive substring match
- If marker appears anywhere in comment, entire comment is skipped
- No regex - literal string matching only

### Exempt Comments

```javascript
// @generated by protocol buffer compiler - DO NOT EDIT
/* AUTO-GENERATED by schema builder */
// eslint-disable-next-line complexity
```

## 6. domain_terms: Preserve Project Terminology

**Type**: Array of objects with `term` and `why` properties
**Purpose**: Domain-specific terminology that might appear redundant but provides valuable context

### Use Cases
- Domain-Driven Design terms (aggregate root, bounded context)
- Industry-specific vocabulary
- Technical patterns (observer, singleton)
- Business domain language

### Example

```yaml
domain_terms:
  - term: "aggregate root"
    why: "DDD pattern indicating entity lifecycle boundaries"
  - term: "bounded context"
    why: "DDD architecture boundary"
  - term: "value object"
    why: "DDD immutable domain concept"
  - term: "saga"
    why: "Distributed transaction pattern"
  - term: "tenant"
    why: "Multi-tenancy isolation boundary"
```

### How It Works
- Comments containing these terms are evaluated carefully
- Prevents false positives on domain vocabulary
- `why` field documents the term's significance for team reference
- Terms are matched case-insensitively

### Example Protected Comments

```java
// This class is an aggregate root - manages order lifecycle
// Bounded context: Payment processing
// Value object ensuring immutability of addresses
```

## Related Documentation

- **Quick start and overview**: See `config-overview.md`
- **Common patterns and recipes**: See `config-recipes.md`
- **Template to copy**: See `reviewrc-template.md` in skill root directory
