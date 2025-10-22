# Comment Removal Patterns

Detailed examples of comments that should be removed during code review.

## Table of Contents

- [State the Obvious](#state-the-obvious)
- [Restate Function/Method Names](#restate-functionmethod-names)
- [Describe Trivial Operations](#describe-trivial-operations)
- [Test Structure Boilerplate](#test-structure-boilerplate)
- [Empty or Punctuation Only](#empty-or-punctuation-only)
- [Commented-Out Code](#commented-out-code)
- [Summary](#summary)

## State the Obvious

```php
// Bad
// Get user by ID
function getUserById($id) { ... }

// Set the name property
$this->name = $name;

// Loop through items
foreach ($items as $item) { ... }
```

## Restate Function/Method Names

```typescript
// Bad
// Constructor
constructor() { ... }

// Login function
function login() { ... }
```

## Describe Trivial Operations

```python
# Bad
# Initialize variable
count = 0

# Return result
return result
```

## Test Structure Boilerplate

```php
// Bad
// Test
public function testUserLogin() { ... }

// Arrange
$user = new User();

// Act
$result = $user->login();

// Assert
$this->assertTrue($result);
```

## Empty or Punctuation Only

```javascript
// Bad
//
// ----
// TODO (no context)
```

## Commented-Out Code

```python
# Bad
# def old_implementation():
#     return legacy_behavior()

# result = some_function()
# print(result)
```

```typescript
// Bad
// const oldConfig = {
//   timeout: 5000,
//   retries: 3
// };

// function deprecatedMethod() {
//   // ...
// }
```

**Rationale:**
- Version control systems (Git, SVN) preserve code history
- Commented-out code creates clutter and confusion
- No one knows if the code should be kept or can be safely removed
- If code might be needed again, it can be retrieved from version control

**Exception:** Keep temporarily commented code ONLY during active development with TODO explaining why:
```java
// TODO(john): Temporarily disabled for testing - re-enable before merge
// validateInput(data);
```

## Summary

Remove any comment that:
- Simply describes what the code obviously does
- Repeats the function or variable name
- States trivial operations like "initialize", "return", "loop"
- Uses Arrange/Act/Assert labels without additional context
- Is empty or contains only punctuation
- Contains commented-out code (use version control instead)
- Provides no information beyond what the code itself conveys
