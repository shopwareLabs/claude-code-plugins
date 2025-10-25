# Workflow Examples

Complete examples demonstrating the comment reviewing workflow in different scenarios.

## Table of Contents

- [Example 1: Specific File Review](#example-1-specific-file-review)
- [Example 2: Directory Review](#example-2-directory-review)
- [Example 3: Git Changes](#example-3-git-changes)
- [Example 4: Git Commit Review](#example-4-git-commit-review)
- [Example 5: Multiple Commits Review](#example-5-multiple-commits-review)

## Example 1: Specific File Review
```
User: "Review comments in UserService.php"

Response:
## Comment Review Results

### Configuration
Loaded from .reviewrc.md (3 ignore paths, 2 preserve patterns, 1 ticket format)

### Files Reviewed: UserService.php

**src/services/UserService.php**
- Line 23: Removed "// Get user by ID" (obvious from method name)
- Line 45: Improved "// Process data" → "// Sanitize HTML to prevent XSS per OWASP"
- Line 67: PRESERVED "// Implements RFC 6749 OAuth 2.0" (external reference)
- Line 78: FLAGGED "// TODO: refactor this" missing owner and ticket reference
- Line 89: Removed "// Constructor" (obvious)
- Line 112: PRESERVED "// Workaround for MySQL bug #4521 - remove after v6.7" (important context)

### Summary
- Removed: 2 redundant comments
- Improved: 1 vague comment
- Flagged: 1 comment requiring verification
- Preserved:2 valuable comments
- Files changed: 1

### Flagged Comments Requiring Attention
1. **UserService.php:78** - TODO missing owner and ticket - suggest: `TODO(name): specific refactoring action - TICKET-XXX`
```

## Example 2: Directory Review
```
User: "Review comments in src/services/"

Response:
## Comment Review Results
### Files Reviewed: src/services/ (recursive scan)

**src/services/UserService.php**
- Line 23: Removed "// Get user" (obvious)
- Line 45: Improved "// Validate" → "// Ensure amount doesn't exceed $10,000 per BR-2019"

**src/services/AuthService.php**
- Line 34: Removed "// Login function" (restates name)
- Line 78: PRESERVED "// SECURITY: Never log raw credentials - PCI-DSS" (critical warning)

### Summary
- Removed: 2 redundant comments
- Improved: 1 vague comment
- Preserved:1 valuable comment
- Files changed: 2
```

## Example 3: Git Changes
```
User: "Cleanup comments vs main"

Response:
Detected main branch: main

## Comment Review Results
### Files Reviewed: git diff main...HEAD (3 files changed)

**src/controllers/CheckoutController.php**
- Line 56: Removed "// Process payment" (obvious)
- Line 78: PRESERVED "// Retry logic for AWS Lambda cold start race condition" (explains workaround)

**tests/CheckoutControllerTest.php**
- Line 23: Removed "// Test case" (redundant test boilerplate)
- Line 67: Improved "// Test error" → "// Regression test for bug #1234: null payment ID caused NPE"

### Summary
- Removed: 2 redundant comments
- Improved: 1 vague comment
- Preserved:1 valuable comment
- Files changed: 2
```

## Example 4: Git Commit Review
```
User: "Review comments in commit abc123"

Response:
Validating commit: abc123

## Comment Review Results
### Files Reviewed: git commit abc123 (2 files changed, 45 lines added)

**src/services/PaymentService.php**
- Line 123 (added): Removed "// Calculate total" (obvious from method name)
- Line 145 (added): Improved "// Check payment" → "// Verify payment doesn't exceed account balance per BR-5678"
- Line 167 (added): PRESERVED "// Implements PCI-DSS 3.2.1 tokenization" (external standard reference)

**tests/PaymentServiceTest.php**
- Line 34 (added): Removed "// Test payment processing" (redundant test description)
- Line 56 (added): FLAGGED "// TODO: add edge cases" missing owner and ticket reference

### Summary
- Removed: 2 redundant comments
- Improved: 1 vague comment
- Flagged: 1 comment requiring verification
- Preserved:1 valuable comment
- Files changed: 2
- Commit reviewed: abc123

### Flagged Comments Requiring Attention
1. **PaymentServiceTest.php:56** - TODO missing owner and ticket - suggest: `TODO(name): specific edge cases to add - TICKET-XXX`
```

## Example 5: Multiple Commits Review
```
User: "Review comments in the last 3 commits"

Response:
Analyzing commits: HEAD~2..HEAD (commits: def456, ghi789, abc123)

## Comment Review Results
### Files Reviewed: git commits HEAD~2..HEAD (4 files changed, 89 lines added)

**src/models/User.php**
- Line 45 (commit def456): Removed "// Constructor" (obvious)
- Line 78 (commit ghi789): PRESERVED "// Workaround for PHP 8.1 bug #12345" (important context)

**src/services/UserService.php**
- Line 23 (commit abc123): Removed "// Get user" (obvious)
- Line 67 (commit abc123): Improved "// Validate input" → "// Ensure email format matches RFC 5322"

**tests/UserTest.php**
- Line 34 (commit ghi789): Removed "// Arrange" (redundant AAA label)

### Summary
- Removed: 3 redundant comments
- Improved: 1 vague comment
- Preserved:1 valuable comment
- Files changed: 3
- Commits reviewed: 3 (HEAD~2..HEAD)
```
