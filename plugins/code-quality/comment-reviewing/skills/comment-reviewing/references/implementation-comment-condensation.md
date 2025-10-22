# Implementation Comment Condensation Guidelines

Guidelines for condensing verbose implementation comments that already have good "WHY" content but use too many words.

## Table of Contents

- [When to Condense Implementation Comments](#when-to-condense-implementation-comments)
- [Condensation Patterns](#condensation-patterns)
  - [1. Remove Redundant Explanations](#1-remove-redundant-explanations)
  - [2. Remove Exhaustive Enumerations](#2-remove-exhaustive-enumerations)
  - [3. Remove Obvious Implications](#3-remove-obvious-implications)
  - [4. Use Concise Phrasing](#4-use-concise-phrasing)
- [Key Principles](#key-principles)
- [Decision Tree](#decision-tree)
- [What NOT to Condense](#what-not-to-condense)
- [Summary Checklist](#summary-checklist)

## When to Condense Implementation Comments

Condense when a comment:
- ✅ Already explains WHY (good content)
- ✅ Provides valuable context
- ❌ **But** is verbose with redundant phrasing, repetition, or over-explanation

**Note**: This is different from "vague comments" which need improvement (adding context), or "obvious comments" which should be removed entirely.

## Condensation Patterns

### 1. Remove Redundant Explanations

Remove sentences that restate the same concept in different words.

#### Example: Path Normalization

```php
// Before (verbose but good WHY):
// Normalize path to match stored URL patterns. Routes are persisted with leading slash
// and no trailing slash. This normalization ensures consistent matching regardless of
// how the client formats the request path.

// After (condensed):
// Normalize path to match stored URL patterns (leading slash, no trailing slash)
```

**What was removed:**
- "Routes are persisted with" → Already implied by "stored URL patterns"
- "This normalization ensures consistent matching regardless of how the client formats the request path" → Just restates what normalization means

**What was kept:**
- The WHY: matching stored URL patterns
- The constraint: specific format requirement

---

### 2. Remove Exhaustive Enumerations

Don't list all possible scenarios, failure modes, or cases unless each one requires different handling.

#### Example: Null Handling

```php
// Before (verbose but good WHY):
// LayoutResolver returns null when no assignment matches the route context.
// This can occur when: entity resolution succeeded but no layout assignments
// match the resolved entity types/IDs, or route has no assignments for this
// sales channel. Provide resolved placeholders in error for debugging.

// After (condensed):
// LayoutResolver returns null when no matching assignment exists.
// Include resolved placeholders in error for debugging.
```

**What was removed:**
- Exhaustive enumeration of when null occurs (implementation detail)
- "This can occur when:" verbose phrasing

**What was kept:**
- The WHY: what null means (no matching assignment)
- The action: include placeholders for debugging

---

### 3. Remove Obvious Implications

If something is directly implied by the main statement, don't restate it.

#### Example: Exception Wrapping

```php
// Before (verbose but good WHY):
// Wrap refinement exceptions with context for debugging. The refinement phase can fail
// due to: layout entity not found in DB, refiner execution errors, or placeholder
// resolution issues. Wrapping preserves the original exception as cause while clearly
// indicating which pipeline phase failed (refinement vs routing, hydration, etc.).

// After (condensed):
// Wrap refinement exceptions to indicate which pipeline phase failed while preserving original cause.
```

**What was removed:**
- "for debugging" → Obvious from "with context"
- Enumeration of failure causes → Implementation detail
- Parenthetical examples of other phases

**What was kept:**
- The WHY: indicate which phase failed
- The approach: preserve original cause

---

### 4. Use Concise Phrasing

Replace multi-sentence explanations with parenthetical notes or shorter phrasing.

#### Verbose Phrasing Patterns to Avoid

```php
// Avoid: "This ensures that X regardless of Y"
// Instead: State X directly, omit "regardless of Y" if obvious

// Avoid: "This can occur when: A, B, or C"
// Instead: "When X occurs" or omit if implementation detail

// Avoid: "The process works by doing X, then Y, then Z"
// Instead: "Does X" (omit HOW unless critical)

// Avoid: "for the purpose of", "in order to", "with the goal of"
// Instead: "to"
```

#### Example Transformations

```php
// Before: Validate input to ensure data integrity regardless of client implementation
// After: Validate input to ensure data integrity

// Before: Cache is checked first for performance. If cache misses, query database.
// After: Cache-first lookup (falls back to database)

// Before: This normalization is required because the routing system expects consistent format
// After: Normalize path for routing system consistency
```

---

## Key Principles

1. **Preserve the WHY** - Never lose the reasoning or context that makes the comment valuable
2. **Remove redundancy** - One clear statement beats multiple restatements
3. **Trust the reader** - Don't over-explain obvious implications
4. **Be direct** - Prefer straightforward phrasing over verbose explanations
5. **Use parentheticals** - For constraints, examples, or qualifiers

## Decision Tree

When reviewing a verbose implementation comment:

1. **Does it explain WHY?**
   - No → Improve it (add context)
   - Yes → Continue to step 2

2. **Does it repeat the same idea multiple ways?**
   - Yes → Remove redundant sentences
   - No → Continue to step 3

3. **Does it enumerate multiple scenarios/cases?**
   - Yes → Consider if enumeration adds value
     - If implementation detail → Remove enumeration
     - If each case needs different handling → Keep enumeration
   - No → Continue to step 4

4. **Does it explain obvious implications?**
   - Yes → Remove obvious parts
   - No → Continue to step 5

5. **Can phrasing be more concise?**
   - Yes → Use parentheticals, remove filler words
   - No → Comment is already concise, keep as-is

## What NOT to Condense

Don't condense when:

1. **Multiple scenarios need different handling**
   ```php
   // KEEP: Can throw TimeoutException if service unavailable (retry safe),
   // NetworkException if connection lost (NOT retry safe), or
   // ValidationException if data malformed (fix data before retry)
   ```

2. **Security/performance warnings with specific implications**
   ```php
   // KEEP: SECURITY: Never log raw credentials - violates PCI-DSS 3.2.1
   // requirement 3.4. Sanitize before logging or use token references.
   ```

3. **Complex constraints or business rules**
   ```php
   // KEEP: Amount must not exceed $10,000 per transaction per business rule BR-2019.
   // For amounts over $1,000, manager approval required (BR-2020).
   ```

4. **Workarounds with removal criteria**
   ```php
   // KEEP: Workaround for PHP 8.1 bug #81122 where array_merge fails on
   // objects with __get magic method. Remove after PHP 8.2 minimum version.
   ```

## Summary Checklist

When condensing verbose implementation comments:

- ✅ Keep the WHY context (the valuable part)
- ✅ Remove sentences that restate the main point
- ✅ Replace exhaustive lists with general principles
- ✅ Omit obvious implications
- ✅ Use parenthetical notes for constraints/examples
- ✅ Remove filler phrases ("regardless of", "in order to", "for the purpose of")
- ❌ Don't lose security warnings or constraints
- ❌ Don't remove scenario enumerations if each needs different handling
- ❌ Don't condense complex business rules
- ❌ Don't sacrifice clarity for brevity
