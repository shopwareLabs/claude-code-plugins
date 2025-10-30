# Special Cases in Comment Review

Guidance for handling edge cases and special situations during comment review.

## Table of Contents

- [Legacy Code (Be Conservative)](#legacy-code)
- [Complex Algorithms (Keep Explanations)](#complex-algorithms)
- [Generated Code (Skip Entirely)](#generated-code)
- [Fall-through and Intentional No-ops (Always Preserve)](#fall-through-and-intentional-no-ops)
  - [Switch Statement Fall-through](#switch-statement-fall-through)
  - [Empty Catch Blocks](#empty-catch-blocks)
  - [Intentional No-ops and Seemingly Unnecessary Code](#intentional-no-ops-and-seemingly-unnecessary-code)
- [Deprecation Documentation (Preserve + Enhance)](#deprecation-documentation)
- [Class and Method Documentation](#class-and-method-documentation)
- [Summary Table](#summary)

## Legacy Code

### Approach
When reviewing old code with extensive comments, be **more conservative** with removal.

### Rationale
- Comments may document undocumented behaviors that aren't obvious from code
- Historical context may be valuable for understanding design decisions
- Over-aggressive cleanup could remove tribal knowledge

### Recommendation
- Check `git blame` to understand when comments were added
- Look for patterns indicating the comment explains non-obvious behavior
- When uncertain, mark for team review rather than removing
- Consider the comment's age: older comments more likely contain valuable context

### Example
```php
// This seems obvious but might be important legacy context
// Loop through users (added 5 years ago)
foreach ($users as $user) {
    // Custom validation needed for legacy data format
    if (!$this->validateLegacy($user)) {
        continue;
    }
}
```

**Action**: Keep the second comment (explains why), remove first comment only after verifying no special legacy behavior exists.

## Complex Algorithms

### Approach
Keep algorithmic comments **even if they seem somewhat obvious**.

### Rationale
- Algorithm choice is a design decision worth documenting
- Future maintainers benefit from understanding why specific algorithms were chosen
- Performance characteristics may not be obvious

### Examples to Keep
```python
# Good - explains algorithm choice and reasoning with complexity
# Dijkstra's algorithm chosen over A* because graph has no good heuristic
# and A* would degrade to Dijkstra anyway
# Time: O(E log V) with priority queue, Space: O(V)

# Good - documents performance trade-off with Big-O notation
# Using quicksort instead of mergesort: average O(n log n) but O(n²) worst case
# Acceptable here because input is typically random and n < 5,000

# Good - explains space-time trade-off
# Cache results in HashMap: O(1) lookup vs O(n) repeated calculation
# Memory cost: ~10MB for typical dataset size
```

### When to Remove
Only remove algorithmic comments if they simply restate the obvious without context:
```javascript
// Bad - no added value
// Sort the array
array.sort();
```

## Generated Code

### Approach
**Skip** auto-generated files entirely during review.

### Files to Skip
- Files with `@generated` markers in headers
- Build artifacts in `dist/`, `build/`, `vendor/`, `node_modules/`
- Lock files: `package-lock.json`, `composer.lock`, `yarn.lock`
- Generated API clients, database models, or schema files
- Compiled assets or minified code
- Auto-generated documentation

### Detection
Look for headers like:
```php
<?php
/**
 * @generated
 * This file is auto-generated. Do not edit manually.
 */
```

Or file paths matching common generated patterns:
- `*.generated.php`
- `*-compiled.js`
- `dist/*`, `build/*`, `vendor/*`

### Reasoning
- Generated code will be regenerated, losing any manual edits
- Comment style in generated code follows generator's conventions
- Reviewing generated code wastes time with no lasting benefit

## Fall-through and Intentional No-ops

### Approach
**ALWAYS preserve** comments that document intentional fall-through, empty blocks, or seemingly unnecessary code.

### Switch Statement Fall-through

```java
// Good - Keep these
switch (status) {
    case PENDING:
        notifyUser();
        // Fall through to ACTIVE case intentionally
    case ACTIVE:
        processOrder();
        break;
    case CANCELLED:
        refundPayment();
        break;
}
```

```javascript
// Good - Required by many style guides (Google, Airbnb)
switch (action) {
    case 'START':
        initialize();
        // Intentional fall-through
    case 'RESUME':
        run();
        break;
}
```

### Empty Catch Blocks

```python
# Good - Explains why exception is intentionally ignored
try:
    optional_cleanup()
except FileNotFoundError:
    # File may not exist on first run - this is expected
    pass
```

```java
// Good - Documents intentional suppression
try {
    cache.invalidate(key);
} catch (CacheException e) {
    // Cache invalidation failure is non-critical, continue processing
    // Main operation already succeeded
}
```

### Intentional No-ops and Seemingly Unnecessary Code

```typescript
// Good - Explains why code that appears unnecessary is actually required
if (DEBUG_MODE) {
    // Empty block required to prevent optimization that breaks debugging
}

// Side effect needed despite unused return value
// Don't remove: forces eager evaluation for cache warming
const _ = loadConfigurationSync();
```

```python
# Good - Documents why obvious "optimization" would be wrong
result = process(data)
# Don't combine into return statement - debugger breakpoint location
return result
```

### Rationale
- Many linters and style guides (Google, ESLint, Pylint) require these comments
- Without comments, fall-through appears to be a mistake
- Empty catch blocks look like error swallowing bugs
- Prevents well-intentioned "cleanups" that break functionality
- Documents that unusual code is intentional, not an oversight

### When Required
Always add/preserve these comments when:
- Switch case falls through to next case intentionally
- Exception is caught but not handled
- Block appears empty or unnecessary
- Code looks redundant but serves a purpose (debugging, side effects, etc.)

## Deprecation Documentation

### Approach
**Preserve and enhance** deprecation notices with migration guidance.

### Standard Deprecation Formats

```java
/**
 * @deprecated Use {@link #newMethod(String, int)} instead.
 * Will be removed in version 3.0 (Q2 2025).
 *
 * Migration: Replace oldMethod(x) with newMethod(x, 0)
 */
@Deprecated
public void oldMethod(String param) {
    // Implementation
}
```

```typescript
/**
 * @deprecated since v2.5.0, use `calculateTotalV2` instead
 * @see {@link calculateTotalV2}
 *
 * Removal planned: v3.0.0 (breaking change)
 * Migration guide: https://docs.example.com/migration/v3
 */
export function calculateTotal() {
    // Implementation
}
```

```python
def legacy_api(data):
    """
    Process data using legacy format.

    .. deprecated:: 2.1.0
       Use :func:`modern_api` instead. This function will be removed in 3.0.0.

    Migration:
        Replace legacy_api(data) with modern_api(data, format='json')
    """
    pass
```

### Required Information

Deprecation documentation should include:
1. **What to use instead** - Specific alternative method/class
2. **Removal timeline** - Version number and/or date
3. **Migration guidance** - How to update code
4. **Reason for deprecation** (optional but helpful) - Security, performance, better API

### Rationale
- Helps developers avoid deprecated features
- Provides clear migration path
- Prevents breaking changes from surprising users
- Documents removal timeline for planning purposes
- IDE tools can show deprecation warnings to developers

## Class and Method Documentation

For detailed guidance on reviewing API documentation (PHPDoc, JSDoc, JavaDoc, etc.), see:
**`api-docs-core-principles.md`**

### Quick Rules

- Make class/method docs concise (one sentence when possible)
- Add only vital non-obvious information (caching, performance, exceptions)
- Remove redundant parameter descriptions that restate names
- Document constraints not expressed in types

## Summary

| Situation | Approach | Key Principle |
|-----------|----------|---------------|
| **Legacy Code** | Conservative | Preserve context, verify before removing |
| **Complex Algorithms** | Keep explanations | Document why and complexity (Big-O) |
| **Generated Code** | Skip entirely | Don't review files that will be regenerated |
| **Fall-through/No-ops** | Always preserve | Document intentional unusual code |
| **Deprecation** | Preserve & enhance | Include migration path and timeline |
| **API Documentation** | Concise + vital | Remove redundancy, add non-obvious info |

When handling special cases, err on the side of caution and preservation rather than aggressive removal.
