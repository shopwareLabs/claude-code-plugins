# API Documentation: Parameters and Return Values

Guidance for reviewing parameter and return value documentation in API documentation.

## Table of Contents

- [Class Documentation Examples](#class-documentation-examples)
  - [Verbose Example (Needs Improvement)](#verbose-example-needs-improvement)
  - [Concise Version (Better)](#concise-version-better)
- [Remove Redundant Parameter Documentation](#remove-redundant-parameter-documentation)
- [Add Vital Non-Obvious Information](#add-vital-non-obvious-information)
- [When to Keep Parameter Documentation](#when-to-keep-parameter-documentation)
- [When to Remove Parameter Documentation](#when-to-remove-parameter-documentation)
- [Return Value Documentation](#return-value-documentation)

## Class Documentation Examples

### Verbose Example (Needs Improvement)

```php
/**
 * This is a service class that handles user authentication.
 * It provides methods for logging in, logging out, checking
 * if a user is authenticated, and managing user sessions.
 * It also handles password validation and token generation.
 */
class AuthService { }
```

**Problems:**
- Too verbose
- Lists every method (redundant with code)
- No vital information

### Concise Version (Better)

```php
/**
 * Handles user authentication, session management, and token generation.
 */
class AuthService { }
```

**Improvements:**
- Single-line summary
- Captures essence without listing methods
- Reader can explore methods in code

## Remove Redundant Parameter Documentation

### Bad Example

```java
/**
 * Creates a new user
 * @param name The name of the user
 * @param email The email of the user
 * @return The created user
 */
User createUser(String name, String email)
```

**Problems:**
- Parameter descriptions simply restate parameter names
- Return description restates return type
- No value added

### Good Example

```java
/**
 * Creates user and sends verification email.
 * @throws DuplicateEmailError if email already exists
 */
User createUser(String name, String email)
```

**Improvements:**
- Brief action summary
- Documents exception (not obvious from signature)
- No redundant parameter descriptions

## Add Vital Non-Obvious Information

### Good Example with Vital Context

```typescript
/**
 * Fetches user profile from cache if available, otherwise from database.
 *
 * @throws NetworkError if database is unreachable
 * @performance Cached responses return in <10ms, DB queries ~50ms
 */
async getUserProfile(id: string): Promise<UserProfile>
```

**What makes this valuable:**
- Caching behavior (not obvious from signature)
- Performance characteristics (helps developers decide when to call)
- Exception documentation (helps error handling)

## When to Keep Parameter Documentation

Keep @param docs ONLY when:

### 1. Parameter has constraints not expressed in type

```php
/**
 * @param amount Must be positive and not exceed $10,000 per business rule BR-2019
 */
function processPayment(int $amount)
```

### 2. Parameter units aren't obvious

```javascript
/**
 * @param timeout Timeout in milliseconds (not seconds)
 */
function waitFor(timeout)
```

### 3. Parameter has specific format requirements

```python
"""
Args:
    phone: Phone number in E.164 format (e.g., "+14155552671")
"""
def send_sms(phone: str):
```

## When to Remove Parameter Documentation

Remove @param docs when:
- Parameter name and type are self-documenting
- Description simply restates the parameter name
- No constraints or requirements beyond the type

### Examples to Remove

```typescript
/**
 * @param userId The user ID  // REMOVE: obvious from name
 * @param email The email address  // REMOVE: obvious from name
 */
function updateUser(userId: number, email: string)
```

## Return Value Documentation

### Keep When:
- Return value meaning is non-obvious
- Nullability has special significance
- Return value has performance implications

```php
/**
 * @return User|null Returns null if user is soft-deleted (still in DB)
 */
function findUser(int $id): ?User
```

### Remove When:
- Return type is obvious and self-explanatory

```java
/**
 * @return The created user  // REMOVE: obvious from return type
 */
User createUser(String name)
```

## Summary Guidelines

When reviewing parameter and return value documentation:

✅ **Keep documentation that adds value:**
- Constraints not in type system (positive, max value, ranges)
- Units (milliseconds, meters, pixels)
- Format requirements (E.164, ISO-8601, regex patterns)
- Non-obvious nullability semantics
- Performance characteristics

❌ **Remove documentation that's redundant:**
- Parameter name restatements ("userId: The user ID")
- Type restatements ("name: The name")
- Obvious return values ("@return User The user")
- Self-documenting parameter names with types

## Related Documentation

For broader context on API documentation:
- **Core principles and visibility rules**: See `api-docs-core-principles.md`
- **Preconditions, postconditions, and contracts**: See `api-docs-contracts.md`
