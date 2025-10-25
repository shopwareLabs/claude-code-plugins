# Comment Improvement Examples

Examples of transforming vague comments into specific, valuable documentation.

## Before and After Transformations

### Data Processing

```php
// Before: Process data
// After: Sanitize HTML to prevent XSS attacks per OWASP guidelines
```

### Input Validation

```php
// Before: Validate input
// After: Ensure amount doesn't exceed $10,000 per business rule BR-2019
```

### Special Handling

```php
// Before: Special handling
// After: Handle pre-v3.0 legacy format for backward compatibility
```

### Test Cases

```php
// Before: Test error handling
// After: Verifies graceful recovery from network timeouts (SLA: 30s max)
```

### Edge Cases

```php
// Before: Edge case test
// After: Regression test for bug #1234: null user ID caused NPE in production
```

## Improvement Principles

When improving vague comments, make them specific by:

1. **Adding Context**: Explain why this code exists, not just what it does
2. **Referencing Standards**: Cite business rules, RFCs, specifications, or ticket numbers
3. **Stating Constraints**: Mention performance requirements, limits, or thresholds
4. **Documenting History**: Explain backward compatibility or regression fixes
5. **Including Metrics**: Add SLAs, timeouts, or quantitative requirements

## What Makes a Comment Valuable

A valuable comment answers:
- **Why** was this approach chosen over alternatives?
- **Why** does this constraint exist?
- **Why** is this workaround necessary?
- **What** specific external requirement drives this?
- **What** bug or issue does this prevent?

Always transform generic verbs ("process", "handle", "validate", "test") into specific actions with measurable outcomes or clear business purposes.
