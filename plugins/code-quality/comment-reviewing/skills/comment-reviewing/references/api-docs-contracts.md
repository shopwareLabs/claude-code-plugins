# API Documentation: Contracts and Invariants

Guidance for documenting API contracts, preconditions, postconditions, and class invariants.

## Table of Contents

- [When to Document Contracts](#when-to-document-contracts)
- [Preconditions (Requirements Before Calling)](#preconditions-requirements-before-calling)
- [Postconditions (Guarantees After Execution)](#postconditions-guarantees-after-execution)
- [Class Invariants](#class-invariants)
- [When to Keep Contract Documentation](#when-to-keep-contract-documentation)
- [Class Documentation](#class-documentation)
- [Summary Checklist](#summary-checklist)

## When to Document Contracts

Document preconditions and postconditions when they're not obvious from the method signature or parameter types.

## Preconditions (Requirements Before Calling)

### Example: Batch Processing

```java
/**
 * Processes a batch of transactions.
 *
 * @param transactions List of transactions to process
 * @precondition transactions must not be empty
 * @precondition all transactions must have valid IDs
 * @precondition caller must hold database transaction lock
 */
public void processBatch(List<Transaction> transactions)
```

### Example: Financial Calculation

```python
def calculate_interest(principal: float, rate: float, years: int) -> float:
    """
    Calculate compound interest.

    Args:
        principal: Initial amount (must be positive)
        rate: Annual interest rate (must be between 0 and 1)
        years: Number of years (must be positive)

    Preconditions:
        - principal > 0
        - 0 <= rate <= 1
        - years > 0

    Raises:
        ValueError: If any precondition is violated
    """
```

### Example: Authorization Requirements

```typescript
/**
 * Updates user profile in database.
 *
 * @param userId - User ID to update
 * @param data - Profile data
 *
 * @precondition User must be authenticated
 * @precondition userId must match current session user or user must be admin
 * @precondition data must pass validation schema
 *
 * @throws UnauthorizedError if authentication check fails
 * @throws ValidationError if data is invalid
 */
async function updateProfile(userId: string, data: ProfileData)
```

## Postconditions (Guarantees After Execution)

### Example: Fund Transfer

```java
/**
 * Transfers funds between accounts.
 *
 * @postcondition Total balance across both accounts remains unchanged
 * @postcondition Transaction is recorded in audit log
 * @postcondition Both accounts are locked during transfer
 *
 * @throws InsufficientFundsError if source account balance is too low
 */
public void transferFunds(Account source, Account dest, BigDecimal amount)
```

### Example: In-Place Modification

```python
def sort_in_place(items: List[int]) -> None:
    """
    Sort list of integers in ascending order.

    Args:
        items: List to sort (modified in place)

    Postconditions:
        - items is sorted in ascending order
        - items contains same elements (no additions/removals)
        - items is the same list object (not a copy)
    """
```

## Class Invariants

### Example: Bank Account

```java
/**
 * Represents a bank account with balance tracking.
 *
 * Invariants:
 * - balance >= 0 (never negative)
 * - accountId is immutable after construction
 * - All balance changes are logged in transactionHistory
 */
public class BankAccount {
    private BigDecimal balance;
    private final String accountId;
    private List<Transaction> transactionHistory;
}
```

## When to Keep Contract Documentation

### Keep Preconditions When:
- Precondition cannot be expressed in type system (e.g., "list must not be empty", "value must be positive")
- Method has side effects not obvious from signature
- Caller has responsibilities (locks, authentication, validation)

### Keep Postconditions When:
- Method makes guarantees about state after execution
- Non-obvious side effects occur (logging, notifications, state changes)
- Invariants must be maintained by callers/subclasses

### Remove When:
- Type system already enforces the constraint (e.g., `@NonNull` annotations)
- Precondition is obvious from parameter name and type
- No special requirements beyond normal input validation

## Class Documentation

### Good Class Documentation

```php
/**
 * Manages file uploads with virus scanning and S3 storage.
 *
 * Files are scanned with ClamAV before upload. Maximum file size: 100MB.
 * Uses multipart upload for files >5MB per AWS S3 guidelines.
 */
class FileUploadService
```

**What makes this good:**
- One-line summary of purpose
- Important constraints (100MB limit)
- Implementation detail that affects usage (multipart upload)

### Bad Class Documentation

```php
/**
 * Service for handling file operations
 * Provides methods for uploading files
 * Provides methods for downloading files
 * Provides methods for deleting files
 */
class FileService
```

**Problems:**
- Vague and generic
- Lists methods (redundant)
- No valuable information

## Summary Checklist

When reviewing API documentation:

### Do Document:
- ✅ Check method visibility: private methods use implementation comment rules, public/protected use API documentation rules
- ✅ Make class docs one concise sentence when possible
- ✅ Add caching, performance, or side-effect information
- ✅ Document exceptions and error conditions
- ✅ Include constraints not expressed in types
- ✅ Specify units for numeric parameters
- ✅ Document preconditions (requirements before calling)
- ✅ Document postconditions (guarantees after execution)
- ✅ Document class invariants that must be maintained

### Don't Document:
- ❌ Don't use API-style PHPDoc for private methods (explain WHY in implementation comments instead)
- ❌ Don't restate obvious parameter names
- ❌ Don't list all methods in class docs
- ❌ Don't describe what the code obviously does
- ❌ Don't write multi-paragraph class summaries
- ❌ Don't document preconditions already enforced by type system

## Remember

API documentation is for **developers using your code**, not for explaining implementation. Focus on:
- What developers need to know to call this correctly
- What side effects or non-obvious behaviors exist
- What constraints or requirements apply

## Related Documentation

For related guidance:
- **Core principles and visibility rules**: See `api-docs-core-principles.md`
- **Parameters and return values**: See `api-docs-parameters-and-returns.md`
