# Uncertainty Patterns

This guide provides patterns and examples for evaluating uncertainty when making comment changes. Load this reference when potential HIGH/MEDIUM patterns are detected.

---
## QUICK REFERENCE
---

### Pattern Index

| ID | Pattern Name | Trigger Keywords | Severity |
|----|-------------|------------------|----------|
| H1 | Interface/Abstract Examples | "Examples:", "e.g.", pattern list + interface/abstract | HIGH |
| H2 | Architectural Patterns | Factory, Strategy, DI, Observer + removed explanation | HIGH |
| H3 | Algorithm Rationale | "because", "O(n)", "prevents" + complex code | HIGH |
| H4 | Framework Behavior | ORM, SQL, framework terms + behavior description | HIGH |
| H5 | Naming/Format Conventions | "naming", "format", "convention" + examples/rules | HIGH |
| H6 | Conservative Paths | conservative_paths file + substantive change | HIGH |
| M1 | Parameter Constraints | @param/@return + "must", "cannot", "only" + removed | MEDIUM |
| M2 | Complex Code Changes | Complex code + content signals + substantive change | MEDIUM |
| M3 | Minimal Documentation | Complex logic + 0-1 comments + no changes made | MEDIUM |
| M4 | Domain Terminology | domain_terms + changed comment | MEDIUM |
| M5 | Transformation Rules | A→B pattern + examples | MEDIUM |

### Content Signal Keywords

**REFERENCE** (External identifiers): `bug #`, `issue #`, `JIRA-`, `RFC`, `IEEE`, `ISO`, `OWASP`, `PCI-DSS`, `ticket`, standards

**CONSTRAINT** (Requirements & limits): `must`, `should`, `required`, `cannot`, `must not`, `never`, `avoid`, `if`, `when`, `only`, `unless`, `maximum`, `minimum`, `limit`, `threshold`, specific numbers

**EXAMPLE** (Concrete instances): `Examples:`, `e.g.,`, `such as`, `like`, quoted strings ('value', "pattern"), lists of similar items

**RATIONALE** (WHY explanations): `because`, `due to`, `since`, `as`, `to prevent`, `to avoid`, `to ensure`, `prevents`, `avoids`, `enables`

**TRADE-OFF** (Design decisions): `but`, `however`, `although`, `while`, `trade-off`, `compromise`, `sacrifice`, `faster but`, `X vs Y`, resource mentions (memory, performance, speed)

**BEHAVIOR** (Non-obvious semantics): `lazy load`, `eager load`, `hydration`, `cascade`, `ORDER BY`, `NULL first`, `JOIN`, `HAVING`, framework-specific terms

**CONTEXT** (Domain knowledge): domain_terms from config, `BR-`, business requirement, `GDPR`, `HIPAA`, `PCI-DSS`, compliance terms

---
## HIGH PATTERNS (Always Report)
---

### H1: Interface/Abstract Examples
**Pattern**: Removed examples from interface methods, abstract classes, or base class documentation

**Why HIGH**: Examples might be the only place documenting naming conventions or implementation patterns for subclasses

**Detection**:
- Removed or condensed text containing: "Examples:", "e.g.,", "like", or pattern lists
- Location: interface, abstract class, or @param/@return docs
- Content signals: EXAMPLE

**Example**:
```php
// BEFORE
/** Examples: 'productId', 'categoryId', 'landingPageId' */
public function getEntityIdField(): string;

// AFTER (examples removed)
/** Returns the field name for entity identification. */
public function getEntityIdField(): string;
```

**Verification prompt**: "Are these examples documented elsewhere? Do implementers need this pattern guidance?"

---

### H2: Architectural Patterns
**Pattern**: Removed explanations of design patterns, architectural decisions, or framework usage

**Why HIGH**: Might be only documentation of WHY this pattern was chosen

**Detection**:
- Removed text mentions: Factory, Strategy, Chain of Responsibility, Observer, Dependency Injection, Singleton, Builder, Adapter, Decorator, etc.
- OR removed framework-specific patterns (DI configuration, routing, lifecycle)
- Content signals: RATIONALE, CONTEXT

**Example**:
```php
// BEFORE
/**
 * Generic factory for entity-based content layout rendering.
 * Instantiated multiple times via DI with different repository/definition
 * configurations to create Product, Category, and Landing Page specific
 * factories using the same logic.
 */

// AFTER (pattern explanation removed)
/** Generic factory for entity-based content layout rendering. */
```

**Verification prompt**: "Is this pattern documented elsewhere? Can developers understand the instantiation approach without this comment?"

---

### H3: Algorithm Rationale
**Pattern**: Substantially reduced or removed comments explaining WHY a complex algorithm was implemented

**Why HIGH**: Algorithm choice rationale is valuable even if implementation is clear

**Detection**:
- Substantially reduced or removed comment explaining WHY (not just WHAT)
- Near complex code: nested loops, recursion, mathematical operations, sorting
- Original contained:
  - Causal language: `because`, `due to`, `since`, `prevents`, `avoids`
  - Complexity notation: `O(n)`, `O(log n)`, `O(n²)`
  - Trade-off descriptions: `faster but`, `memory vs speed`, `X vs Y`
  - Anti-pattern warnings: `avoid X because Y`
  - Performance requirements or thresholds
- Content signals: RATIONALE, TRADE-OFF

**Definition**: "Substantially reduced" = Most explanatory content removed, making rationale unclear. Focus on whether reasoning remains understandable, not word count. Evaluate WHAT was removed (rationale, trade-offs, complexity, anti-patterns) not HOW MUCH.

**Example**:
```php
// BEFORE (22 words)
// Binary search used because user lists can contain 10,000+ entries
// and lookups happen on every request. Linear scan would timeout.

// AFTER (3 words)
// Binary search used

// Lost: Performance rationale, scale justification, anti-pattern warning
```

**Verification prompt**: "Does the condensed version preserve critical performance or design rationale? Original explained algorithm choice with specific scale (10,000+ entries) and consequence (timeouts)."

---

### H4: Framework/Library Behavior
**Pattern**: Changed comments describing ORM behavior, SQL semantics, library quirks, or framework conventions

**Why HIGH**: Behavior might not be obvious from code alone; depends on external semantics

**Detection**:
- Comment describes behavior AND mentions:
  - SQL: `FieldSorting`, `ORDER BY`, `JOIN`, `WHERE`, `NULL` behavior
  - ORM: `lazy load`, `eager load`, `cascade`, `hydration`, `flush`
  - Framework APIs: routing, middleware, lifecycle hooks
  - Library-specific behavior: date parsing, timezone handling, encoding
- Content signals: BEHAVIOR

**Example**:
```php
// BEFORE
// Fallback priority: specific → global (null)
// Uses FieldSorting('salesChannelId', DESCENDING) to sort non-null first

// AFTER (simplified)
// Fallback priority: specific → global
```

**Verification prompt**: "Verify the SQL sorting behavior matches the comment. Does DESCENDING on nullable field actually prioritize non-null values?"

---

### H5: Naming/Format Conventions
**Pattern**: Removed comments documenting naming conventions, data formats, or transformation rules

**Why HIGH**: If not documented elsewhere, this information is lost

**Detection**:
- Removed comment contains:
  - Naming conventions: camelCase, snake_case, kebab-case patterns
  - Data format specifications: date formats, encodings, character sets
  - Transformation rules: input → output mappings with examples
  - Cross-file references: "see ProductService for similar logic"
- Content signals: EXAMPLE, CONSTRAINT, CONTEXT

**Example**:
```php
// BEFORE
/**
 * Transform entity definition names to routing patterns.
 * Examples: product_definition → product, landing_page_definition → landing-page
 */

// AFTER (examples removed)
/** Transform entity definition names to routing patterns. */
```

**Verification prompt**: "Are transformation rules documented elsewhere? Do developers need examples to understand edge cases like hyphenation?"

---

### H6: Conservative Paths
**Pattern**: Substantive changes in files marked as conservative_paths in configuration

**Why HIGH**: These files were explicitly marked as requiring extra caution

**Detection**:
- File path matches `conservative_paths` pattern in config
- Change is substantive (removing/improving/condensing comment content)
- NOT merely fixing typos or formatting

**Substantive changes** (HIGH uncertainty in conservative_paths):
- Removing explanatory comments
- Condensing WHY rationale
- Improving vague comments with new interpretation
- Removing examples or specifications

**Non-substantive changes** (apply normal patterns, may be LOW):
- Fixing typos: "// Reutrns user" → "// Returns user"
- Correcting grammar without meaning change
- Reformatting line breaks or indentation
- Fixing punctuation

**Verification prompt**: "File is in conservative paths. Verify this substantive change is safe for this critical file."

---
## MEDIUM PATTERNS (Report If Present)
---

### M1: Parameter Constraints
**Pattern**: Removed @param descriptions that contained edge case information or constraints

**Why MEDIUM**: Condensation might have lost important parameter requirements

**Detection**:
- Removed or condensed @param/@return documentation
- Original contained: `must`, `should`, `required`, `cannot`, `if`, `when`, `only`, `unless`
- Content signals: CONSTRAINT

**Example**:
```php
// BEFORE
/** @param string $path Must be absolute, not relative. */

// AFTER
/** @param string $path The file path */
```

**Verification prompt**: "Does condensed version capture the absolute path requirement? Original specified 'must be absolute, not relative'."

---

### M2: Complex Code Changes
**Pattern**: Substantive change to comment in complex code (catchall for unlisted risks)

**Why MEDIUM**: Complex code benefits from documentation; changes need verification to ensure no critical details lost

**Detection**:
- Comment changed substantively (not just typo/formatting)
- In or near complex code:
  - High cyclomatic complexity
  - Nested control structures (loops, conditionals)
  - Mathematical operations or algorithms
  - Framework-specific operations (ORM, DI, routing)
- Doesn't match other specific HIGH patterns
- Original contained content signals:
  - Specific numeric values or thresholds
  - Concrete examples or patterns
  - Causal language: `because`, `prevents`, `due to`, `enables`
  - External references: `RFC`, `bug #`, `issue #`, standards
  - Constraint language: `must`, `cannot`, `only`, `if`, `when`
  - Trade-off descriptions: `but`, `however`, `X vs Y`

**Example**:
```php
// BEFORE (15 words)
// Returns user email. Must validate against RFC 5322 before storing.

// AFTER (10 words)
// Returns user email for storage in database.

// Lost: RFC reference (REFERENCE signal), validation requirement (CONSTRAINT signal)
```

**Verification prompt**: "Verify no critical details (examples, constraints, rationale, references) were lost during condensation. Original comment was near complex code and contained [list specific signals detected]."

---

### M3: Minimal Documentation
**Pattern**: Complex code with minimal comments, and no new comments added

**Why MEDIUM**: Might indicate under-documentation rather than good documentation

**Detection**:
- Complex logic (high cyclomatic complexity, nested structures, algorithms)
- Only 0-1 comments in method/function
- No changes made (preserved existing minimal comments)

**Verification prompt**: "Complex logic with minimal comments. Consider if more documentation would help future maintainers understand this code."

---

### M4: Domain Terminology
**Pattern**: Changed comments using domain-specific terms that might have precise meanings

**Why MEDIUM**: Term might have specific meaning in this domain/codebase

**Detection**:
- Changed comment contains terms from `domain_terms` config
- OR changed comment with technical jargon specific to business domain
- Content signals: CONTEXT

**Verification prompt**: "Verify terminology change preserves precise domain meaning. Original term might have specific definition in this business context."

---

### M5: Transformation Rules
**Pattern**: Comments describing transformations with examples

**Why MEDIUM**: Examples might not cover all edge cases

**Detection**:
- Comment shows transformation pattern (A → B format)
- Contains examples of input/output pairs
- Content signals: EXAMPLE

**Verification prompt**: "Verify transformation examples are accurate and cover edge cases. Check if there are unusual inputs that might behave differently."

---
## LOW UNCERTAINTY (Don't Report)
---

Routine changes that are safe and don't need user verification. These should NOT clutter the report.

### What NOT to Report

**1. Pure Formatting Changes**
- Whitespace adjustments (indentation, spacing)
- Line break standardization
- Comment delimiter style changes (`//` vs `/* */`)

**2. Typo Fixes**
- Spelling corrections with no meaning change: "retrun" → "return"
- Grammar fixes that don't alter intent
- Punctuation standardization

**3. Obviously Redundant Comment Removals**
- `// Get user` above `getUser()`
- `// Set name` above `setName(string $name)`
- `// Return total` above `return $total;`
- Setter/getter documentation that adds no information

**4. Style Standardization**
- Consistent comment format across codebase
- Capitalization normalization
- Period placement standardization

**5. Minor to Moderate Condensation**
- Removed filler words: "basically", "simply", "just", "actually"
- Reduced verbosity with all meaning preserved
- Streamlined phrasing without information loss
- Condensed wordy explanations to concise clarity while preserving all key points

**Example of LOW uncertainty condensation**:
```php
// BEFORE (19 words)
/**
 * This method is responsible for the task of enabling the feature
 * for polymorphic handling without needing to know specific getter names
 */

// AFTER (7 words)
/** Enables polymorphic handling without entity-specific getters. */

// All key information preserved, only fluff removed
```

**Why these are LOW**: Zero risk of losing valuable information. These are safe, mechanical improvements.

---
## ADDING NEW PATTERNS
---

### Template (Copy and modify)

```markdown
### [H/M][Next Number]: [Short Name]
**Pattern**: [One-line description of what this detects]

**Why [HIGH/MEDIUM]**: [Why this needs manual verification]

**Detection**:
- Trigger condition 1
- Trigger condition 2
- Content signals: [REFERENCE/CONSTRAINT/EXAMPLE/RATIONALE/TRADE-OFF/BEHAVIOR/CONTEXT]

**Example**:
[Code example showing the risk - BEFORE and AFTER]

**Verification prompt**: "[Specific actionable prompt for user]"

---
```

### Workflow for Adding New Pattern

1. **Copy template** above
2. **Fill in pattern details**:
   - ID: Next sequential number (H7, M6, etc.)
   - Name: Short descriptive name
   - Detection rules: Specific conditions and content signals
   - Example: Real code showing the risk
   - Verification prompt: Actionable user instruction
3. **Append to appropriate section** (HIGH or MEDIUM)
4. **Add row to Quick Reference table** at top of file
5. **Update lightweight heuristics** in SKILL.md if needed
6. **Test on real codebase** to validate pattern accuracy

**Time estimate**: ~10 minutes

**Example of adding new pattern**:
```markdown
### H7: Safety-Critical Prefixes
**Pattern**: Removed or modified comments with safety-critical prefixes

**Why HIGH**: Indicates code that could cause physical harm, data loss, or security breaches if modified incorrectly

**Detection**:
- Comment removed or substantially modified
- Original contained prefix: `SAFETY:`, `CRITICAL:`, `WARNING:`, `DANGER:`
- Content signals: CONTEXT, CONSTRAINT

**Example**:
// BEFORE
// SAFETY: Must validate input range to prevent motor damage
function setMotorSpeed(int $rpm) { }

// AFTER (safety prefix removed)
// Validates and sets motor speed
function setMotorSpeed(int $rpm) { }

**Verification prompt**: "This comment was marked SAFETY/CRITICAL. Verify the safety requirement is documented elsewhere and code changes are safe."

---
```

Then add to Quick Reference:
```
| H7 | Safety-Critical Prefixes | "SAFETY:", "CRITICAL:", "WARNING:", "DANGER:" | HIGH |
```

---
## CONTENT SIGNAL REFERENCE
---

### Detection Keyword Library

Use these for pattern detection rules. These represent different types of information that might be lost during comment changes.

#### REFERENCE (External Identifiers)
**What**: Links to external resources, tracking systems, or documentation
**Risk if lost**: Traceability lost, compliance issues, can't find related information

**Detection keywords:**
- Bug tracking: `bug #`, `issue #`, `JIRA-`, `GH-`, `ticket #`, tracking IDs
- Standards: `RFC`, `IEEE`, `ISO`, `OWASP`, `PCI-DSS`, `WCAG`, standard names
- Documentation: `see`, `refer to`, `documented in`, `see also`
- Tickets: Project-specific patterns from `ticket_format` config

**Example**: `// Fixed per bug #4521` → REFERENCE signal detected

---

#### CONSTRAINT (Requirements & Limits)
**What**: Preconditions, requirements, prohibitions, limits on usage
**Risk if lost**: Incorrect usage, validation logic bypassed, edge cases unhandled

**Detection keywords:**
- Requirements: `must`, `should`, `required`, `needs to`, `requires`
- Prohibitions: `cannot`, `must not`, `never`, `avoid`, `do not`
- Conditions: `if`, `when`, `only if`, `unless`, `provided that`
- Limits: `maximum`, `minimum`, `limit`, `threshold`, `at most`, `at least`, specific numbers

**Example**: `// Must be absolute path, not relative` → CONSTRAINT signal

---

#### EXAMPLE (Concrete Instances)
**What**: Specific values, variable names, patterns showing usage
**Risk if lost**: Implementation guidance unclear, edge cases missed, ambiguous specifications

**Detection patterns:**
- List markers: `Examples:`, `e.g.,`, `such as`, `like`, `for example`
- Quoted strings: `'productId'`, `"landing_page_content"`, `'value'`
- Multiple instances: Series of similar items (productId, categoryId, landingPageId)
- Code snippets or patterns in comments

**Example**: `// Examples: 'productId', 'categoryId'` → EXAMPLE signal

---

#### RATIONALE (WHY Explanations)
**What**: Reasoning, causes, purposes explaining why something is done
**Risk if lost**: Lost understanding of design decisions, can't evaluate alternatives

**Detection keywords:**
- Causation: `because`, `due to`, `since`, `as`, `caused by`
- Purpose: `to prevent`, `to avoid`, `to ensure`, `to enable`, `in order to`
- Reasoning: `rationale`, `reason`, `why`, `motivation`, `justification`
- Consequences: `prevents`, `avoids`, `enables`, `ensures`, `guarantees`

**Example**: `// Binary search because linear would timeout` → RATIONALE signal

---

#### TRADE-OFF (Design Decisions with Costs)
**What**: Conscious choices with pros and cons, alternative approaches considered
**Risk if lost**: Lost context for future changes, can't understand why not done differently

**Detection patterns:**
- Contrast: `but`, `however`, `although`, `while`, `though`, `yet`
- Trade-off markers: `trade-off`, `compromise`, `sacrifice`, `balance`
- Comparative: `faster but`, `simpler but`, `more X but less Y`, `X vs Y`
- Resource mentions: `memory`, `performance`, `speed`, `time`, `space`, `complexity`

**Example**: `// HashMap for O(1) lookup but uses 4x memory` → TRADE-OFF signal

---

#### BEHAVIOR (Non-Obvious Semantics)
**What**: Framework/library behavior not apparent from code alone
**Risk if lost**: Incorrect assumptions, subtle bugs, misunderstanding of how code works

**Detection contexts:**
- ORM terms: `lazy load`, `eager load`, `hydration`, `cascade`, `flush`, `persist`
- SQL semantics: `ORDER BY`, `NULL first`, `JOIN`, `HAVING`, `GROUP BY`, null handling
- Async/concurrency: race conditions, deadlocks, synchronization, thread-safety
- Framework APIs: routing, middleware, lifecycle hooks, dependency injection
- Security: XSS, CSRF, injection, sanitization, validation

**Example**: `// Uses FieldSorting DESCENDING to sort non-null first` → BEHAVIOR signal

---

#### CONTEXT (Domain Knowledge)
**What**: Business rules, compliance requirements, domain-specific facts
**Risk if lost**: Institutional knowledge lost, compliance violations, domain misunderstandings

**Detection indicators:**
- Domain terms from `domain_terms` config (project-specific)
- Business rules: `BR-`, business requirement, policy, regulation
- Compliance: `GDPR`, `HIPAA`, `PCI-DSS`, `SOX`, legal requirements
- Historical context: legacy, migration, backward compatibility, deprecated
- Industry-specific: Finance, healthcare, e-commerce, manufacturing terms

**Example**: `// GDPR requires consent before storing` → CONTEXT signal

---

### Using Content Signals in Pattern Detection

When writing pattern detection rules, reference these signal types to identify what information is at risk:

**Example pattern detection**:
```
**Detection**:
- Comment removed or substantially changed
- Original contained:
  - REFERENCE signals (bug IDs, RFCs, standards)
  - CONSTRAINT signals (must, cannot, limits, thresholds)
  - RATIONALE signals (because, prevents, due to)
- Located in complex code or interfaces
```

This makes pattern detection semantic (based on information type) rather than syntactic (based on length).

---
## DESIGN NOTES
---

### Philosophy

These patterns are **practical heuristics** based on software engineering experience, not empirical research or validated studies.

**Core principles:**
1. **Content over length**: Focus on WHAT was removed (examples, rationale, constraints) not HOW MUCH (percentage, word count)
2. **Qualitative over quantitative**: Use descriptive language ("substantially", "drastically") requiring judgment rather than arbitrary numeric thresholds
3. **Trust Claude's judgment**: Semantic analysis is Claude's strength; leverage it instead of mechanical rules
4. **Intellectual honesty**: Acknowledge these are educated guesses, not scientific facts
5. **Encourage true evaluation**: Prompts ask "was substance lost?" not "did you exceed 50%?"

### Reality Check

**No metrics validate these patterns.**
**No studies support these guidelines.**
**No data backs these heuristics.**

These are educated guesses based on:
- Common sense about what information is valuable
- Experience with code maintenance and evolution
- Understanding of how documentation serves developers

### Adaptation Encouraged

**If different patterns work better for your codebase**, change them and document your reasoning. There's no "correct" pattern because uncertainty evaluation is fundamentally about judgment, not measurement.

### Why Content Signals Work Better Than Compression

**Compression percentages fail because:**
- High compression of verbose fluff triggers false positives
- Low compression with critical loss creates false negatives
- No correlation between word count and information value

**Content signals succeed because:**
- Directly detect information types that matter (references, constraints, examples, rationale)
- Semantic analysis plays to Claude's strengths
- Context-aware (interfaces need examples more than implementations)
- Extensible (add new signals as patterns emerge)

### Evolution History

- v1.1.0 (2025-10-30): Initial uncertainty evaluation with content-based detection
  - Removed compression-based patterns (<50%, >50%, >70%)
  - Added content signal library (7 information types)
  - Added Quick Reference for fast pattern lookup
  - Added pattern template for easy extension

---
