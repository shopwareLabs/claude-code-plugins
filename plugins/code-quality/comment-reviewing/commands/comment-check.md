---
description: Analyze comment quality without making changes (read-only)
argument-hint: "[scope: file/dir/commit(s)]"
allowed-tools: Skill
---

# Comment Quality Check (Read-Only)

Analyze code comments for quality issues without making any changes. Perfect for CI/CD pipelines and pre-commit hooks.

## Task

Invoke the **comment-reviewing** skill to analyze comments in read-only mode.

**Scope to analyze**: $ARGUMENTS

**Mode**: READ-ONLY (no edits will be made)

### Scope Detection (Smart Parsing)

Parse the arguments to automatically detect the analysis scope:

**1. Empty arguments** → Analyze current working directory recursively

**2. File/directory paths** → Analyze specified location
   - Examples: `src/Service/`, `src/UserService.php`

**3. Git commits** (auto-detected):
   - **Single commit**: `HEAD`, `abc123f`, `HEAD~3`, `main`
   - **Commit range**: `HEAD~5..HEAD`, `main..feature`, `abc123..def456` (contains `..`)
   - **Commit list**: `abc123 def456 ghi789` (multiple space-separated commits)

Detection pattern:
- Contains `..` → commit range
- Matches commit patterns (HEAD*, sha1-like, branch names) → commit(s)
- Contains `/` or is existing path → file/directory
- Otherwise → current directory

Use the Skill tool to invoke the "comment-reviewing" skill with the detected scope in read-only mode.

## Examples

```bash
# Files and directories
/comment-check                          # Check current directory
/comment-check src/Service/             # Check specific directory
/comment-check src/UserService.php      # Check specific file

# Single commit
/comment-check HEAD                     # Check last commit
/comment-check abc123f                  # Check specific commit

# Commit range
/comment-check HEAD~5..HEAD             # Check last 5 commits
/comment-check main..feature            # Check branch changes

# Commit list
/comment-check HEAD~3 HEAD~1 HEAD       # Check specific commits
```
