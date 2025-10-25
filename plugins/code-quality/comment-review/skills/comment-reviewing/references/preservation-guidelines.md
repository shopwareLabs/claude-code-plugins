# Comment Preservation Guidelines

Comments that should ALWAYS be preserved during review because they provide essential context and value.

## Table of Contents

- [0. License, Copyright, and Legal Compliance Headers](#0-license-copyright-and-legal-compliance-headers)
- [1. External References (RFCs, Specs, Standards, Tickets)](#1-external-references)
- [2. Complex Algorithms and Complexity Analysis](#2-complex-algorithms-and-complexity-analysis)
- [2a. Regular Expression (Regex) Documentation](#2a-regular-expression-regex-documentation)
- [3. Workarounds with References](#3-workarounds-with-references)
- [4. Security, Performance, and Concurrency Warnings](#4-security-performance-and-concurrency-warnings)
- [6. TODO/FIXME with Specific Action Items](#6-todofixme-with-specific-action-items)
- [7. Test Rationale and Special Conditions](#7-test-rationale-and-special-conditions)
- [8. Design Decisions and Architecture Choices](#8-design-decisions-and-architecture-choices)
- [Preservation Checklist](#preservation-checklist)
- [When in Doubt](#when-in-doubt)

## 0. License, Copyright, and Legal Compliance Headers

```javascript
// Good - Keep these (ALWAYS)
/**
 * Copyright (c) 2024 Example Corp.
 * Licensed under the MIT License
 */

// SPDX-License-Identifier: Apache-2.0
```

```python
# Good - Keep these (ALWAYS)
# Copyright 2024 Example Inc.
# Licensed under the Apache License, Version 2.0

# This file is part of Project Name.
# See LICENSE file in the project root for full license information.
```

```php
<?php
/**
 * @copyright 2024 Example Company
 * @license https://opensource.org/licenses/MIT MIT License
 */
```

**Why preserve**:
- Legal requirement for license compliance
- Copyright notices have legal implications
- Required for open source compliance (GPL, Apache, MIT, etc.)
- Removing these could violate licensing terms
- Often required by corporate or organizational policy

**CRITICAL:** Never remove or modify license headers, SPDX identifiers, copyright notices, or legal disclaimers.

## 1. External References

```php
// Good - Keep these
// Implements OAuth 2.0 RFC 6749 section 4.1
// See Payment Gateway API v2.3 spec section 4.2.1
// Per JIRA-5678 requirements
```

**Why preserve**: References to external documentation help developers find authoritative sources and understand compliance requirements.

## 2. Complex Algorithms and Complexity Analysis

```javascript
// Good - Keep these
// Uses Boyer-Moore algorithm for O(n) performance instead of naive O(n²)
// Binary search requires sorted array - do not remove the sort() call above

// Dijkstra's algorithm: O(V²) with array, O(E log V) with priority queue
// Chose array implementation because V is small (<100) in our use case
```

```python
# Good - Document complexity analysis
# Time: O(n log n) average case, O(n²) worst case (quicksort)
# Space: O(log n) due to recursion stack
# Acceptable because input is typically random and n < 10,000

# Dynamic programming approach: O(n*m) time, O(m) space
# Memoization table reduces repeated calculations
```

```java
// Good - Explain algorithm choice
// Using HashSet for O(1) lookup instead of ArrayList's O(n)
// Trade-off: Higher memory usage (~4x) for 100x faster duplicate detection
```

**Why preserve**:
- Documents algorithmic choices and complexity analysis (Big-O notation)
- Explains trade-offs between time and space complexity
- Helps future maintainers understand performance characteristics
- Prevents "optimizations" that would degrade performance
- Critical dependencies that aren't obvious from code alone

## 2a. Regular Expression (Regex) Documentation

```javascript
// Good - Explains what complex regex matches (exception to "what not why")
// Matches: email addresses in format name@domain.tld
// Valid: user@example.com, user.name+tag@example.co.uk
const emailPattern = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;

// Matches ISO 8601 date format: YYYY-MM-DD
// Example: 2024-01-15, 2023-12-31
const datePattern = /^\d{4}-\d{2}-\d{2}$/;
```

```python
# Good - Documents what complex pattern matches and why
# Matches valid phone numbers in E.164 format: +[country][number]
# Example: +14155552671, +442071234567
# Allows 7-15 digits after country code per ITU-T E.164 spec
phone_regex = r'^\+[1-9]\d{1,14}$'

# Matches semantic version strings (major.minor.patch)
# Example: 1.0.0, 2.3.4-beta, 3.0.0-rc.1+build.123
# Spec: https://semver.org/
semver_pattern = r'^(\d+)\.(\d+)\.(\d+)(?:-([0-9A-Za-z-]+(?:\.[0-9A-Za-z-]+)*))?(?:\+([0-9A-Za-z-]+(?:\.[0-9A-Za-z-]+)*))?$'
```

```java
// Good - Breaks down complex regex with explanation
// Validates credit card numbers with Luhn algorithm check
// Format: 13-19 digits, optional spaces/dashes
// \d{4}: 4-digit groups
// [ -]?: Optional space or dash separator
Pattern cardPattern = Pattern.compile("^\\d{4}[ -]?\\d{4}[ -]?\\d{4}[ -]?\\d{4,7}$");
```

**Why preserve (Exception to "what not why" rule)**:
- Regular expressions are notoriously difficult to read and understand
- Comments explaining what pattern matches are highly valuable
- Breaking down regex components aids comprehension
- Examples of valid/invalid inputs help developers
- References to specs (E.164, ISO 8601, etc.) document why pattern is structured this way
- Complex regex takes minutes to parse; a comment takes seconds to read

**When to document regex**:
- Pattern is longer than 20 characters
- Pattern uses advanced features (lookahead, backreferences, named groups)
- Pattern validates against a specific standard or format
- Provide 1-2 examples of valid inputs

## 3. Workarounds with References

```python
# Good - Keep these
# Workaround for MySQL collation bug #4521 - remove after v6.7.0
# Retry logic needed due to AWS Lambda cold start race condition
```

**Why preserve**: Documents temporary solutions and provides removal criteria or historical context.

## 4. Security, Performance, and Concurrency Warnings

```typescript
// Good - Keep these
// SECURITY: Never log raw credit card numbers - PCI-DSS violation
// PERFORMANCE: This query is slow (~5s) - consider caching
```

```java
// Good - Thread-safety and concurrency warnings
// NOT THREAD-SAFE: Use ThreadLocal or synchronize access
// THREAD-SAFE: All methods are synchronized, safe for concurrent use

// WARNING: Must be called with lock held
private void updateCache() { ... }

// Caller must hold write lock before calling this method
private void modifySharedState() { ... }
```

```python
# Good - Concurrency documentation
# Thread-safe: Uses ThreadPoolExecutor with proper locking
# Not thread-safe: Use separate instance per thread

# DEADLOCK RISK: Always acquire locks in order: db_lock -> cache_lock
# Never reverse the order to avoid deadlock
```

```go
// Good - Concurrency primitives documentation
// goroutine-safe: Protected by mutex
// Not safe for concurrent use: Caller must synchronize

// This function spawns goroutines - ensure proper cleanup
// Use context cancellation to stop background workers
```

**Why preserve**:
- **Security warnings** prevent vulnerabilities and compliance violations
- **Performance warnings** document known bottlenecks and optimization opportunities
- **Thread-safety warnings** prevent race conditions, deadlocks, and data corruption
- **Concurrency documentation** clarifies locking requirements and synchronization expectations
- Critical for multi-threaded/concurrent applications
- Prevents subtle bugs that only appear under load or in production

## 6. TODO/FIXME with Specific Action Items

```go
// Good - Keep these
// TODO(john): Refactor to use dependency injection after v2.0 release
// FIXME: Race condition when concurrent requests exceed 100/s - see issue #789
```

**Why preserve**: Tracks technical debt with clear ownership, timeline, and references.

## 7. Test Rationale and Special Conditions

```php
// Good - Keep these
// Regression test for CVE-2023-1234 security vulnerability
// Flaky on CI - tracking in JIRA-5678, likely race condition
// DO NOT PARALLELIZE - uses shared database fixture
// This seemingly redundant test catches a production race condition
```

**Why preserve**: Explains why tests exist, prevents removal of "duplicate" tests, documents test environment requirements.

## 8. Design Decisions and Architecture Choices

```java
// Good - Keep these
// Factory pattern chosen over DI to support runtime plugin loading
// Singleton avoided due to testing difficulties in parallel test suites
```

**Why preserve**: Documents architectural trade-offs and prevents well-intentioned "improvements" that reintroduce past problems.

## Preservation Checklist

A comment should be preserved if it:
- ✅ Contains license, copyright, or legal compliance information
- ✅ References external specifications, RFCs, standards, or tickets
- ✅ Explains complex algorithms or performance characteristics (Big-O notation)
- ✅ Documents what a complex regex pattern matches (exception to "what not why")
- ✅ Documents workarounds with bug numbers or version removal criteria
- ✅ Contains SECURITY or PERFORMANCE warnings
- ✅ Includes TODO/FIXME with owner and specific context
- ✅ Explains why a test exists (especially regression or CVE tests)
- ✅ Documents architectural decisions or pattern choices
- ✅ Warns about non-obvious dependencies or ordering requirements
- ✅ Provides context that would be lost if the comment were removed

## When in Doubt

If a comment provides information that would require:
- Reading external documentation
- Understanding historical context
- Knowing about past bugs or issues
- Awareness of future plans

Then **KEEP IT**. The goal is removing noise, not removing signal.
