# Comment Reviewing

Code comment review skill for Claude Code. Identifies and removes redundant or misleading comments while preserving valuable documentation.

## "Why" Not "What"

Comments should explain:
- **Why** a decision was made
- **Why** this approach was chosen
- **Why** a workaround exists
- **Why** specific constraints matter

Comments should NOT explain:
- **What** the code does (code is self-documenting)
- **What** a function is named
- **What** obvious operations happen

## Quick Start

### Slash Commands (Recommended)

Two slash commands are available:

**`/comment-review [scope]`** - Review and improve comments (makes edits)

Automatically detects scope from arguments:
```bash
# Files and directories
/comment-review                          # Review current directory (recursive)
/comment-review src/Service/             # Review specific directory
/comment-review src/UserService.php      # Review specific file

# Git changes
/comment-review --git                    # Review staged/unstaged changes vs main

# Single commit
/comment-review HEAD                     # Review last commit
/comment-review abc123f                  # Review specific commit

# Commit range
/comment-review HEAD~5..HEAD             # Review last 5 commits
/comment-review main..feature            # Review feature branch changes

# Commit list (space-separated)
/comment-review abc123 def456 ghi789     # Review specific commits
```

**`/comment-check [scope]`** - Analyze comment quality (read-only, no edits)

Same scope detection, but won't make any changes:
```bash
# Files and directories
/comment-check                           # Check current directory
/comment-check src/                      # Check specific directory

# Git commits
/comment-check HEAD                      # Analyze last commit
/comment-check HEAD~4..HEAD              # Analyze last 5 commits
/comment-check main..feature             # Analyze feature branch
/comment-check abc123 def456             # Analyze specific commits
```

**Scope Detection:** Both commands use smart argument parsing to automatically detect:
- Empty → current directory (recursive)
- Contains `..` → commit range
- Matches commit patterns (HEAD*, sha1, branches) → git commits
- Contains `/` or exists as path → file/directory
- `--git` flag → working directory changes

### Natural Language (Alternative)

Alternatively, use natural language:

**Review a directory:**
```
Review comments in src/services/
```

**Review git changes:**
```
Cleanup comments in my branch vs main
```

**Review specific files:**
```
Fix redundant comments in UserService.php
```

## Project-Specific Configuration

Customize behavior using a `.reviewrc.md` configuration file:

```yaml
---
ignore_paths:
  - "vendor/**"
  - "node_modules/**"
preserve_patterns:
  - "@internal"
  - "JIRA-\\d+"
ticket_format: "TODO\\(\\w+\\): .+ - [A-Z]+-\\d+"
conservative_paths:
  - "src/Legacy/**"
exemption_markers:
  - "@no-review"
  - "AUTO-GENERATED"
---
```

**Features:**
- Exclude files/directories from review
- Preserve project-specific annotations
- Enforce custom TODO/FIXME formats
- Protect legacy code from changes
- Skip comments with exemption markers
- Define domain-specific terminology
- Configuration commits to git and shares with team

**Documentation:**
- Quick start template: `skills/comment-reviewing/reviewrc-template.md`
- Complete guide: `skills/comment-reviewing/references/configuration-guide.md`

Configuration is optional.

## Functionality

### Removes Redundant Comments
- Comments that state the obvious: `// Get user by ID`
- Function name restatements: `// Constructor`
- Trivial operations: `// Initialize variable`
- Empty comments: `//` or `// ----`

### Improves Vague Comments
- `// Process data` → `// Sanitize HTML to prevent XSS attacks per OWASP guidelines`
- `// Validate input` → `// Ensure amount doesn't exceed $10,000 per business rule BR-2019`
- `// Edge case test` → `// Regression test for bug #1234: null user ID caused NPE`

### Condenses Verbose Comments
- **Implementation comments** - Removes redundant phrasing while keeping the reasoning
- **API documentation** - Makes concise by removing implementation details and obvious parameter descriptions

Examples:
- Verbose implementation: `// Normalize path to match stored URL patterns. This ensures consistent matching regardless of how the client formats the path` → `// Normalize path to match stored URL patterns (leading slash, no trailing slash)`
- Verbose API doc: 15-line PHPDoc listing all pipeline phases → Brief purpose + vital constraints only

### Flags Inconsistent Comments
- Comments contradicting function names or behavior
- Return value mismatches
- TODO/FIXME without owner or ticket reference
- Outdated comments with temporal markers ("will", "soon", "temporary")
- Exception handling mismatches

### Preserves Valuable Comments
- External references (RFCs, specs, ticket numbers)
- Complex algorithms and performance notes
- Security warnings (PCI-DSS, OWASP)
- Workarounds with bug numbers
- TODO/FIXME with owner and timeline
- Design decisions and trade-offs

## Supported Languages

Supports:
- `//` and `/* */` - JavaScript, TypeScript, Java, C++, PHP, Go, Rust, Swift, Kotlin
- `#` - Python, Ruby, Shell, YAML
- `<!-- -->` - HTML, XML, Markdown
- `{# #}` - Twig, Jinja templates
- `--` - SQL, Lua

## Example Output

```markdown
## Comment Review Results

### Files Reviewed: src/services/UserService.php

**src/services/UserService.php**
- Line 23: Removed "// Get user by ID" (obvious from method name)
- Line 45: Improved "// Process data" → "// Sanitize HTML to prevent XSS per OWASP"
- Line 56: FLAGGED "// TODO: fix this" missing owner and ticket reference
- Line 67: KEPT "// Implements RFC 6749 OAuth 2.0" (external reference)
- Line 89: CONDENSED verbose implementation comment → concise version preserving WHY
- Line 112: KEPT "// Workaround for MySQL bug #4521" (important context)
- Line 134: CONDENSED PHPDoc from 12 lines → brief purpose + vital info only

### Summary
- Removed: 2 redundant comments
- Improved: 1 vague comment
- Condensed: 2 verbose comments (1 implementation, 1 API doc)
- Flagged: 1 comment requiring verification
- Kept: 2 valuable comments

### Flagged Comments Requiring Attention
1. **UserService.php:56** - TODO missing owner and ticket - suggest: `TODO(name): specific action - TICKET-XXX`
```
