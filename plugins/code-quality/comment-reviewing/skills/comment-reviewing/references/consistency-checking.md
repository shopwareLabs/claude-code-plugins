# Code-Comment Consistency Checking

Guidance for detecting inconsistencies between code comments and actual implementation. This is the #1 quality attribute in code comment research according to systematic literature reviews.

## Table of Contents

- [Why Consistency Matters](#why-consistency-matters)
- [The FLAG Category](#the-flag-category)
- [Consistency Check Patterns](#consistency-check-patterns)
  - [1. Function/Method Name vs Comment Mismatch](#1-functionmethod-name-vs-comment-mismatch)
  - [2. Return Value Mismatch](#2-return-value-mismatch)
  - [3. Parameter Description Contradicts Usage](#3-parameter-description-contradicts-usage)
  - [4. Behavior Description Doesn't Match Implementation](#4-behavior-description-doesnt-match-implementation)
  - [5. Temporal Language Suggesting Outdated Comments](#5-temporal-language-suggesting-outdated-comments)
  - [6. TODO/FIXME Without Ownership or Tracking](#6-todofixme-without-ownership-or-tracking)
  - [7. Exception Handling Comments Contradicting Code](#7-exception-handling-comments-contradicting-code)
  - [8. Conditional Logic Mismatches](#8-conditional-logic-mismatches)
- [How to Flag Comments](#how-to-flag-comments)
- [Consistency Check Workflow](#consistency-check-workflow)
- [What NOT to Flag](#what-not-to-flag)
- [Advanced Patterns](#advanced-patterns)
- [Summary Checklist](#summary-checklist)

## Why Consistency Matters

Research shows that inconsistent comments (also called "rotting comments" or "misleading comments"):
- Cause software bugs and maintenance issues
- Mislead developers and introduce errors
- Are worse than no comments at all
- Become increasingly problematic as code evolves

**Key Principle**: An outdated or incorrect comment is more harmful than a missing comment.

## The FLAG Category

When reviewing comments, use the **FLAG** category for comments that:
- May contradict the code implementation
- Make claims that cannot be verified against the code
- Contain TODO/FIXME without proper ownership and tracking
- Use temporal language suggesting they may be outdated
- Describe behavior that doesn't match what the code does

**Important**: Do NOT remove flagged comments automatically. They require human verification because:
- The comment might be correct and the code wrong (bug in implementation)
- Context may be needed to determine which is correct
- Historical knowledge may explain the discrepancy

## Consistency Check Patterns

### 1. Function/Method Name vs Comment Mismatch

#### Pattern: Comment describes different action than function name

```python
# Bad - Inconsistent
# Returns the user's full name
def get_email(user_id):
    return db.query("SELECT email FROM users WHERE id = ?", user_id)
```

**FLAG**: Comment claims "full name" but function is named `get_email` and returns email

```java
// Bad - Inconsistent
/**
 * Deletes a user from the database
 */
public void updateUser(User user) {
    db.execute("UPDATE users SET ...");
}
```

**FLAG**: Comment says "deletes" but function is named `updateUser` and performs UPDATE

```typescript
// Bad - Inconsistent
/**
 * Validates user input
 */
function sanitizeInput(data: string): string {
    return data.trim().toLowerCase();
}
```

**FLAG**: Comment says "validates" (implies boolean/throwing) but function `sanitizeInput` transforms the input

### 2. Return Value Mismatch

#### Pattern: Comment describes wrong return type or value

```php
/**
 * @return bool True if successful
 */
function getUserById(int $id): ?User {
    return $this->repository->find($id);
}
```

**FLAG**: Comment claims returns `bool` but signature shows returns `?User` (nullable User)

```python
def calculate_total(items):
    """
    Returns total price as integer.
    """
    return sum(item.price for item in items)  # Returns float
```

**FLAG**: Docstring says "integer" but sum of prices would typically be float

```javascript
/**
 * Returns array of user IDs
 * @returns {number[]}
 */
function getActiveUsers() {
    return db.query("SELECT * FROM users WHERE active = true");
}
```

**FLAG**: JSDoc says returns `number[]` (user IDs) but query returns full user objects

### 3. Parameter Description Contradicts Usage

#### Pattern: Comment describes parameter incorrectly

```java
/**
 * @param userId The user's email address
 */
public void deleteUser(int userId) {
    db.execute("DELETE FROM users WHERE id = ?", userId);
}
```

**FLAG**: Comment says "email address" but parameter is `int userId` and used as ID

```python
def send_notification(user_id: int, message: str):
    """
    Args:
        user_id: The user object to notify
        message: The message to send
    """
    user = get_user(user_id)
    notify(user, message)
```

**FLAG**: Docstring says "user object" but parameter is `int` and code calls `get_user()` to retrieve object

### 4. Behavior Description Doesn't Match Implementation

#### Pattern: Comment claims code does X but code actually does Y

```typescript
// Sorts the array in descending order
function processItems(items: number[]): number[] {
    return items.sort((a, b) => a - b);  // This is ASCENDING
}
```

**FLAG**: Comment says "descending" but `a - b` sorts ascending

```php
/**
 * Sends email notification to all administrators
 */
function notifyAdmins(string $message): void {
    $admins = $this->getAdmins();
    foreach ($admins as $admin) {
        $this->logger->info("Would notify: " . $admin->email);
        // Email sending code commented out
    }
}
```

**FLAG**: Comment says "sends email" but code only logs, doesn't actually send

```python
# Validates that amount is positive
def process_payment(amount: float):
    if amount < 0:
        logger.warning(f"Negative amount: {amount}")
    charge_card(amount)  # Processes anyway!
```

**FLAG**: Comment says "validates" (implies enforcement) but code only logs warning and processes anyway

### 5. Temporal Language Suggesting Outdated Comments

#### Pattern: Comments using "will", "soon", "temporary" that may be old

```javascript
// This will be refactored in the next release
function legacyHandler() {
    // Complex legacy code...
}
```

**FLAG**: Check git blame - if comment is >6 months old, "next release" likely already happened

```java
// TODO: Temporary workaround until API v2 is deployed
public void fetchData() {
    // Workaround code that's been here for 3 years
}
```

**FLAG**: If comment is old (check git blame), "temporary" may no longer be accurate

```python
# Soon to be deprecated - use new_method instead
def old_method():
    pass
```

**FLAG**: Check if actually deprecated with `@deprecated` decorator or if comment is wishful thinking

### 6. TODO/FIXME Without Ownership or Tracking

#### Pattern: Action items without owner, ticket, or timeline

```typescript
// TODO: fix this
function handleError(error: Error) {
    console.log(error);
}
```

**FLAG**: No owner, no ticket, no specificity - what needs fixing? By whom? By when?

```python
# FIXME: This breaks sometimes
def unreliable_function():
    pass
```

**FLAG**: No context - when does it break? What's the fix? Who's responsible?

```java
// TODO: Add validation
public void setAmount(int amount) {
    this.amount = amount;
}
```

**FLAG**: Missing owner, ticket, and specifics - what validation? Per what rules?

**Should be**:
```java
// TODO(sarah): Validate amount is positive and <= $10,000 per BR-2019 - JIRA-456
public void setAmount(int amount) {
    this.amount = amount;
}
```

### 7. Exception Handling Comments Contradicting Code

#### Pattern: Comment claims exceptions handled but aren't, or vice versa

```python
def load_config():
    """
    Loads configuration from file.
    Raises: ConfigError if file not found
    """
    with open("config.json") as f:
        return json.load(f)
```

**FLAG**: Claims raises `ConfigError` but actually raises `FileNotFoundError` (no try/catch)

```java
/**
 * Never throws exceptions - all errors are logged
 */
public void processData(String data) throws IOException {
    // Code that can throw IOException
}
```

**FLAG**: Comment says "never throws" but signature declares `throws IOException`

### 8. Conditional Logic Mismatches

#### Pattern: Comment describes wrong condition

```javascript
// Returns true if user is an admin
function isRegularUser(user) {
    return !user.isAdmin;
}
```

**FLAG**: Comment says "returns true if admin" but function returns true if NOT admin

```python
# Skip processing if cache is empty
if cache.has_items():
    return  # Skips if cache HAS items, not if empty
```

**FLAG**: Comment says "skip if empty" but code skips if cache HAS items

## How to Flag Comments

When you detect potential inconsistencies:

1. **Read both comment and code carefully** - Understand what each claims
2. **Identify the discrepancy** - What specifically doesn't match?
3. **Consider context** - Could there be historical/domain reasons?
4. **Flag with specifics** - Explain exactly what's inconsistent

### Flag Report Format

```markdown
**path/to/file.php**
- Line 45: FLAGGED "Returns user's full name" but function `get_email()` returns email address (name vs email mismatch)
- Line 67: FLAGGED TODO without owner or ticket reference (add owner and JIRA-XXX)
- Line 89: FLAGGED Comment claims "validates" but code only logs warning and continues (validation vs logging mismatch)
```

## Consistency Check Workflow

When reviewing each file:

1. **Read comment first** - Note what it claims
2. **Read code immediately after** - Verify the claim
3. **Compare**:
   - Does function name match comment description?
   - Does return type match comment claim?
   - Do parameter descriptions match usage?
   - Does behavior match what comment says?
4. **Check temporal markers**:
   - "TODO/FIXME" - has owner and ticket?
   - "temporary", "will", "soon" - check git blame for age
   - "deprecated" - is it actually deprecated in code?
5. **Flag discrepancies** - Don't remove, flag for human review

## What NOT to Flag

Don't flag comments for:
- Minor wording differences (code does "fetch", comment says "get")
- Implementation details when comment describes intent
- Different abstraction levels (comment describes "why", code shows "how")

### Examples of Acceptable Differences

```python
# Good - Not inconsistent
# Retrieves active users from the database
def get_users():
    return db.query("SELECT * FROM users WHERE active = 1")
```

Not flagged: "retrieves" vs "get" are synonyms, both accurate

```java
// Good - Not inconsistent
/**
 * Processes payment using Stripe API
 */
public void handlePayment(Payment payment) {
    stripeClient.charge(payment);
}
```

Not flagged: "processes" vs "handle" are both accurate; comment adds detail (Stripe)

## Advanced Patterns

### Consistency with Code Evolution

```python
# Version 1 (comment accurate)
# Returns None if user not found
def find_user(user_id):
    return users.get(user_id)  # Returns None if not found

# Version 2 (comment now INCONSISTENT)
# Returns None if user not found  # OUTDATED!
def find_user(user_id):
    user = users.get(user_id)
    if user is None:
        raise UserNotFoundError(user_id)  # Changed to raise exception
    return user
```

**FLAG**: Code evolved to raise exception but comment still says "Returns None"

### Deprecated Inconsistencies

```java
/**
 * @deprecated Use {@link #processPaymentV2} instead
 */
public void processPayment(Payment payment) {
    // Still the primary implementation, not actually deprecated!
}
```

**FLAG**: Claims deprecated but no `@Deprecated` annotation and may still be primary method

## Summary Checklist

Flag comments when:
- ✅ Function name contradicts comment description
- ✅ Return type/value doesn't match comment claim
- ✅ Parameter descriptions contradict types or usage
- ✅ Behavior described doesn't match implementation
- ✅ Temporal language ("will", "soon") in old comments (check git blame)
- ✅ TODO/FIXME missing owner, ticket, or timeline
- ✅ Exception handling claims contradict code
- ✅ Conditional logic descriptions are inverted
- ✅ "Deprecated" claims without proper markers

Don't flag when:
- ❌ Minor synonym differences (get/fetch/retrieve)
- ❌ Different abstraction levels (why vs how)
- ❌ Comment adds context beyond code (both true)

## Remember

The goal is to identify comments that may mislead developers. When in doubt, FLAG for human review rather than removing potentially important context.
