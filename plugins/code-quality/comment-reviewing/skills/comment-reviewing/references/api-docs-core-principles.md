# API Documentation: Core Principles

Guidance for understanding when and how to review API documentation (PHPDoc, JSDoc, JavaDoc, etc.).

## Table of Contents

- [Core Principle: Concise + Vital Information Only](#core-principle-concise--vital-information-only)
- [Visibility and API Documentation Scope](#visibility-and-api-documentation-scope)
  - [Public Methods: External API Contract](#public-methods-external-api-contract)
  - [Protected Methods: Inheritance API Contract](#protected-methods-inheritance-api-contract)
  - [Private Methods: Implementation Details (NOT API)](#private-methods-implementation-details-not-api)
  - [Detection Strategy](#detection-strategy)
- [Contract vs Implementation Distinction](#contract-vs-implementation-distinction)
  - [Contract (Document This)](#contract-document-this)
  - [Implementation (Avoid Documenting)](#implementation-avoid-documenting)
  - [Example: Multi-Phase Pipeline](#example-multi-phase-pipeline)
  - [This Pattern Applies To](#this-pattern-applies-to)

## Core Principle: Concise + Vital Information Only

Class and method documentation should be brief and include only non-obvious information that adds value beyond the code signature.

## Visibility and API Documentation Scope

**The fundamental rule**: API documentation is for external consumers of an interface. Method visibility determines who those consumers are and what documentation style to use.

### Public Methods: External API Contract

Public methods are the external interface—document the contract (what it offers, requires, guarantees).

```php
// Good - Public method documents API contract
/**
 * Loads and renders content for the given URL path.
 *
 * @throws ContentSystemException When route or layout assignment not found
 * @performance Full pipeline: ~50ms; cached routes: ~20ms
 */
public function loadContent(string $path, Request $request, SalesChannelContext $context): ContentPage
{
    // Implementation
}
```

### Protected Methods: Inheritance API Contract

Protected methods define the inheritance contract—subclasses are external consumers.

```php
// Good - Protected method documents inheritance contract
/**
 * Resolves layout ID for the given route. Override to customize layout resolution.
 *
 * @return string|null Returns null when no assignment matches
 */
protected function resolveLayout(Route $route): ?string
{
    return $this->layoutResolver->resolve($route);
}
```

### Private Methods: Implementation Details (NOT API)

Private methods are internal implementation—no external consumers exist. Comments should explain WHY (implementation rationale), not WHAT (contract).

**Apply implementation comment rules: remove if obvious, improve if vague, condense if verbose.**

#### Bad Example: Private Method with API-Style Documentation

```php
// Bad - Treats private method as API contract
/**
 * Normalizes the path to match stored URL patterns.
 *
 * @param string $path The URL path to normalize
 * @return string The normalized path with leading slash and no trailing slash
 */
private function normalizePath(string $path): string
{
    return '/' . trim($path, '/');
}
```

**Problems:**
- PHPDoc format for private method (no external consumers)
- Parameter description restates obvious name/type
- Return description restates what code obviously does
- Reads like API contract, but this is internal implementation

#### Good Example: Private Method with Implementation WHY Comment

```php
// Good - Explains WHY normalization is needed
// Normalize path to match stored URL patterns (leading slash, no trailing slash)
private function normalizePath(string $path): string
{
    return '/' . trim($path, '/');
}
```

**Improvements:**
- Implementation comment explains WHY (to match stored patterns)
- Concise, includes constraint (format requirement)
- No redundant parameter/return descriptions
- Follows implementation comment rules, not API documentation rules

#### Another Example: Obvious Private Method

```php
// Bad - Obvious, should be removed
/**
 * Gets the layout ID from the resolver.
 *
 * @param Route $route The route entity
 * @return string The resolved layout ID
 */
private function getLayoutId(Route $route): string
{
    return $this->layoutResolver->resolve($route);
}

// Good - No comment needed
private function getLayoutId(Route $route): string
{
    return $this->layoutResolver->resolve($route);
}
```

**Why remove:** Private method name and implementation are self-documenting. No external consumers need to know about this internal helper.

### Detection Strategy

When reviewing structured documentation (`/** */` with `@param`, `@return`):

1. **Check method visibility first**
2. **Private method?** → Apply implementation comment rules (WHY not WHAT, remove if obvious, condense if verbose)
3. **Public/protected method?** → Apply API documentation rules (condense if verbose, ensure contract-focused)

**Rationale:**
- Private methods have no external consumers (not part of any API)
- API documentation is for users of the interface, not implementers
- Private method comments should explain implementation decisions (WHY), not interface contracts (WHAT)
- Over-documenting private methods with API-style PHPDoc is redundant noise

## Contract vs Implementation Distinction

**The fundamental rule**: API documentation describes the interface CONTRACT (what it offers, requires, and guarantees), not the IMPLEMENTATION (how it works internally).

### Contract (Document This)
- **Capabilities**: What the interface does for the caller
- **Requirements**: Preconditions, input constraints, caller responsibilities
- **Guarantees**: Postconditions, return values, state changes, invariants
- **Exceptions**: What can fail and under what conditions
- **Non-obvious behavior**: Caching, side effects, performance characteristics

### Implementation (Avoid Documenting)
- **Internal sequence**: Step-by-step processing flow, phases, stages
- **Algorithm details**: How the solution is computed internally
- **Service calls**: Which internal components or services are invoked
- **State transitions**: Internal state machine or workflow mechanics
- **Data flow**: How data moves through internal layers

### Example: Multi-Phase Pipeline

#### Verbose Version (Implementation Focus) - NEEDS CONDENSING

```php
/**
 * Orchestrates the five-phase content system pipeline to load and render content.
 *
 * Pipeline phases (sequential, must run in order):
 * 1. Route Matching: Match URL to content route entity
 * 2. Entity Resolution: Extract URL parameters, query entities to resolve IDs
 * 3. Layout Resolution: Determine layout via priority-based assignment matching
 * 4. Refinement: Apply refiners (placeholder resolution, partial rendering)
 * 5. Hydration: Load data requirements, resolve context, populate element tree
 *
 * After hydration, partial rendering may extract a subtree if ?elementId present.
 *
 * @param string $path URL path to match
 * @param Request $request HTTP request
 * @param SalesChannelContext $context Sales channel context
 * @throws ContentSystemException When route/layout not found
 * @return ContentPage Fully hydrated content page
 */
public function loadContent(string $path, Request $request, SalesChannelContext $context): ContentPage
```

**Problems:**
- Lists every internal phase (implementation detail)
- Explains HOW each phase works (internal mechanics)
- Describes processing sequence (internal workflow)
- Parameter descriptions restate obvious names/types

#### Condensed Version (Contract Focus) - BETTER

```php
/**
 * Loads and renders content for the given URL path.
 *
 * @throws ContentSystemException When route or layout assignment not found
 * @performance Full pipeline: ~50ms; cached routes: ~20ms
 */
public function loadContent(string $path, Request $request, SalesChannelContext $context): ContentPage
```

**Improvements:**
- States WHAT it does (capability), not HOW (implementation)
- Documents exceptions (part of contract)
- Includes performance characteristics (non-obvious, helps callers)
- Removed redundant parameter descriptions
- Caller can use the method without knowing internal phases

### This Pattern Applies To

The contract vs implementation distinction prevents verbose API documentation across all architectures:
- **Multi-phase systems**: Document what the pipeline accomplishes, not every stage
- **State machines**: Document state change contracts, not internal transition logic
- **Microservices orchestrations**: Document overall capability, not which services are called
- **Event-driven systems**: Document observable behavior, not event flow internals
- **Algorithms**: Document time complexity and constraints, not algorithm steps
- **Data transformations**: Document input/output contracts, not transformation steps

## Related Documentation

For specific guidance on:
- **Parameters and return values**: See `api-docs-parameters-and-returns.md`
- **Preconditions, postconditions, and contracts**: See `api-docs-contracts.md`
