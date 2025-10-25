---
description: Review and improve code comments following "why not what" principle
argument-hint: "[scope: file/dir/--git/commit(s)]"
allowed-tools: Skill
---

# Review Code Comments

Review and improve code comments following the "why not what" principle.

## Task

Invoke the **comment-reviewing** skill to review and improve comments with the following scope:

**Scope**: $ARGUMENTS

### Scope Detection (Smart Parsing)

Parse the arguments to automatically detect the review scope:

**1. Empty arguments** → Review current working directory recursively

**2. `--git` flag** → Review git changes (staged/unstaged vs main branch)

**3. File/directory paths** → Review specified location
   - Examples: `src/Service/`, `src/UserService.php`

**4. Git commits** (auto-detected):
   - **Single commit**: `HEAD`, `abc123f`, `HEAD~3`, `main`
   - **Commit range**: `HEAD~5..HEAD`, `main..feature`, `abc123..def456` (contains `..`)
   - **Commit list**: `abc123 def456 ghi789` (multiple space-separated commits)

Detection pattern:
- Contains `..` → commit range
- Matches commit patterns (HEAD*, sha1-like, branch names) → commit(s)
- Contains `/` or is existing path → file/directory
- Otherwise → current directory

Use the Skill tool to invoke the "comment-reviewing" skill with the detected scope.

## Examples

```bash
# Files and directories
/comment-review                          # Review current directory
/comment-review src/Service/             # Review specific directory
/comment-review src/UserService.php      # Review specific file

# Git changes
/comment-review --git                    # Review staged/unstaged changes

# Single commit
/comment-review HEAD                     # Review last commit
/comment-review abc123f                  # Review specific commit

# Commit range
/comment-review HEAD~5..HEAD             # Review last 5 commits
/comment-review main..feature            # Review branch changes

# Commit list
/comment-review HEAD~3 HEAD~1 HEAD       # Review specific commits
```
