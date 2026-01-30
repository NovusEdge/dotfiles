# Codebase Review

Comprehensive codebase review with configurable modes, parallel analysis agents, and regression tracking.

## Mode Selection

Parse `$ARGUMENTS` to determine review mode:

| Argument | Mode | Description |
|----------|------|-------------|
| (empty) | `full` | Complete codebase analysis |
| `quick` | `quick` | Changed files only (git diff HEAD~5) |
| `incremental` | `incremental` | Uncommitted changes only |
| `focused:<area>` | `focused` | Deep-dive specific area |

**Mode Configuration:**

| Mode | Scope | Agents | Model |
|------|-------|--------|-------|
| `quick` | Changed files (git diff HEAD~5) | 2 (Logic, Errors) | haiku |
| `full` | Entire codebase | 5 (all) | sonnet |
| `incremental` | Uncommitted changes (git diff HEAD) | 3 (Logic, Errors, Performance) | sonnet |
| `focused:<area>` | Specific subsystem | 1-2 (relevant) | sonnet |

---

## Phase 1: Context Loading

Before launching agents, gather project context:

### 1. Project Context Files

Read these files if they exist:

```bash
# Check for project documentation
[ -f "CLAUDE.md" ] && echo "Read CLAUDE.md"
[ -f "README.md" ] && echo "Read README.md"
[ -f "context/architecture.md" ] && echo "Read context/architecture.md"
[ -f "context/directives.md" ] && echo "Read context/directives.md"
```

### 2. Previous Review (for regression tracking)

```bash
# Find most recent review file
ls -t context/review/codebase-review-*.md 2>/dev/null | head -1
```

### 3. For Quick/Incremental Modes

```bash
# Get changed files for scoping
git diff --name-only HEAD~5  # quick mode
git diff --name-only HEAD    # incremental mode
```

Store the changed file list for scoping agent analysis.

---

## Phase 2: Launch Parallel Agents

Launch agents **in parallel** using the Task tool. Skip agents based on mode.

### Agent 1: Logic & Spec Conformance (ALL MODES)

**Model**: sonnet (haiku for quick mode)

```
Cross-reference implementation against documented specifications.

1. Read Specifications First:
   - Extract ALL documented formulas, thresholds, weights from docs
   - Extract data flow and component responsibilities from architecture docs
   - Extract enabled features and parameters from config files

2. Implementation vs Documentation:
   - For each documented formula/behavior:
     - Find corresponding implementation in code
     - Verify it matches OR document the discrepancy
   - Check: Are all documented features actually implemented?
   - Check: Do config-enabled features have working implementations?

3. Data Flow Verification:
   - Verify documented data flow matches actual code paths
   - Check input/output contracts between components

Key principle: If docs say X but code does Y, that's a finding.
If docs are silent, note as "undocumented behavior".

Output format:
| Discrepancy | Doc Location | Code Location | Documented | Actual | Severity |
```

### Agent 2: Performance & Query Analysis (full, incremental modes)

**Model**: sonnet

```
Find performance bottlenecks and inefficient patterns.

1. N+1 Query Detection:
   - Look for loops calling database per iteration
   - Pattern: `for item in items: await db.query(item.id)`
   - Check batch operation availability

2. Batch Operation Gaps:
   - Identify sequential operations that could be batched
   - Check batch_size handling in existing batch operations
   - Look for bulk insert opportunities

3. Connection Management:
   - Are connections pooled and reused?
   - Are connections properly closed/returned?
   - Is there connection leak potential?

4. Index Verification:
   - Are frequently filtered columns indexed?
   - Are foreign keys indexed?
   - Any full table scans on large tables?

5. Caching Opportunities:
   - Repeated expensive computations
   - Cacheable external API calls
   - Missing memoization

Output format:
| Issue | Location | Current | Recommended | Impact Estimate |
```

### Agent 3: Error Handling & Resilience (ALL MODES)

**Model**: sonnet (haiku for quick mode)

```
Identify missing error handling that could cause silent failures.

1. Silent Failure Patterns:
   - `return []` or `return None` in except blocks
   - Bare `except:` or `except Exception: pass`
   - Empty results indistinguishable from errors

2. Retry Logic Gaps:
   - External APIs without retry (network failures)
   - Database transient errors (leader election, timeouts)
   - Rate limiting without backoff

3. Input Validation:
   - Numeric bounds (scores in [0,1], etc.)
   - NaN/Inf handling for floats
   - Null/empty string handling
   - Config value validation

4. Race Conditions:
   - Concurrent writes to same resource
   - Check-then-act patterns without locking
   - Entity creation races

5. Resource Cleanup:
   - Unclosed connections/files in error paths
   - Missing finally blocks
   - Context manager opportunities

Output format:
| Issue | Location | Failure Mode | Severity | Recommended Fix |
```

### Agent 4: Security Review (full mode only)

**Model**: sonnet

```
Security-focused analysis.

1. Injection Risks:
   - SQL: String interpolation vs parameterized queries
   - NoSQL: User input in query objects
   - Shell: os.system(), subprocess with shell=True
   - Template: User input in templates

2. Authentication/Authorization:
   - Auth bypass possibilities
   - Missing auth on routes
   - Ownership checks (can users access others' data?)
   - Token/session handling

3. Secrets Handling:
   - Hardcoded secrets, API keys, passwords
   - Secrets in error messages or logs
   - Secure environment variable loading

4. Input Validation:
   - Parameter bounds, types, lengths
   - File path traversal
   - URL validation (SSRF prevention)
   - Content-type validation

5. Data Exposure:
   - Sensitive data in responses
   - Verbose error messages
   - Debug endpoints in production

Output format:
| Vulnerability | Location | Attack Vector | Severity | Remediation |
```

### Agent 5: Architecture & Regression Check (full mode only)

**Model**: sonnet

```
Check architecture consistency and verify previous fixes.

1. Previous Review Regression Check:
   - Read most recent review file
   - For each P0/P1 finding, verify fix is still in place
   - Check if any fixed issues have regressed

2. Pattern Consistency:
   - Document which pattern each service uses:
     - Singleton, Constructor injection, Factory function
   - Flag inconsistencies within same category

3. Dependency Patterns:
   - Are similar components structured similarly?
   - Is error handling consistent across layers?
   - Are retries/timeouts configured consistently?

4. Code Quality:
   - Dead code: unused imports, unreachable paths
   - Duplicate logic implementations
   - Missing type hints on public APIs
   - Outdated comments/docstrings

Output format:
| Issue | Location | Pattern/Finding | Recommendation |
```

---

## Phase 3: Synthesize & Output

After all agents complete:

### 1. Create Output File

Write findings to: `context/review/codebase-review-YYYY-MM-DD.md`

Use this structure:

```markdown
# Codebase Review - YYYY-MM-DD

**Mode**: [full|quick|incremental|focused:<area>]
**Scope**: [description of what was reviewed]

## Executive Summary

| Category          | P0    | P1    | P2    | P3    | Total |
| ----------------- | ----- | ----- | ----- | ----- | ----- |
| Logic Correctness | X     | X     | X     | X     | X     |
| Performance       | X     | X     | X     | X     | X     |
| Error Handling    | X     | X     | X     | X     | X     |
| Security          | X     | X     | X     | X     | X     |
| Architecture      | X     | X     | X     | X     | X     |
| **Total**         | **X** | **X** | **X** | **X** | **X** |

## Regression Status

[List any P0/P1 from previous review that have regressed or remain unfixed]

---

## Findings

### Category: [Logic/Performance/Error Handling/Security/Architecture]

| ID  | Priority | Location | Issue | Recommendation | Verify Exists | Verify Fixed |
| --- | -------- | -------- | ----- | -------------- | ------------- | ------------ |
```

### 2. Priority Definitions

| Priority | Criteria | Examples |
|----------|----------|----------|
| **P0** | Data corruption, security vulnerability, crash | Race condition in writes, injection, unhandled exception crashes |
| **P1** | Logic incorrectness, >10x perf degradation, frequent failures | Formula mismatch, N+1 on hot path, missing retry causes 5% failures |
| **P2** | Missing validation, architectural drift, edge case failures | Config not validated, inconsistent patterns, rare error unhandled |
| **P3** | Code quality, minor optimization, documentation gaps | Dead code, could batch better, missing type hints |

### 3. Verification Columns

Every finding MUST include:

- **Verify Exists**: How to confirm the issue exists
  - Grep pattern: `grep -n "pattern" file.py`
  - Code path: "Function X calls Y without checking Z"
  - Test scenario: "Call endpoint with payload {...}"

- **Verify Fixed**: How to confirm the fix works
  - Test command: `pytest tests/test_x.py -k test_name`
  - Grep pattern: `grep "fixed_pattern" file.py`
  - Expected output: "Should return 400 instead of 500"

### 4. Console Summary

After writing the file, output:

```
## Review Complete

**File**: context/review/codebase-review-YYYY-MM-DD.md
**Mode**: [mode]

### Summary
- P0 (Critical): X findings
- P1 (High): X findings
- P2 (Medium): X findings
- P3 (Low): X findings

### Top 5 Issues

1. [P0] Location: Issue summary
2. [P0] Location: Issue summary
3. [P1] Location: Issue summary
4. [P1] Location: Issue summary
5. [P1] Location: Issue summary

### Regressions
- [X regressions found | No regressions from previous review]
```

---

## Focused Mode Targets

Define focused areas dynamically based on codebase structure:

| Area | Common Paths | Key Concerns |
|------|--------------|--------------|
| `api` | `*/api/`, `*/routes/`, `*/endpoints/` | Auth, validation, error responses |
| `database` | `*/models/`, `*/repositories/`, `*/db/` | Query efficiency, transactions |
| `services` | `*/services/`, `*/domain/` | Business logic, boundaries |
| `infra` | `*/infra/`, `*/clients/` | Connections, retries, timeouts |
| `tests` | `tests/`, `*/tests/` | Coverage, assertions, fixtures |

When using `focused:<area>`:
1. Identify relevant paths for this codebase
2. Run only agents relevant to that area
3. Provide deeper analysis of the focused area

---

## Customization Per Project

### Project-Specific Additions

If project has specific patterns or concerns, add them to agents:

1. **Domain Logic**: Add to Agent 1
   - Specific formulas to verify
   - Business rules to check
   - Config parameters to validate

2. **Performance Hotspots**: Add to Agent 2
   - Known slow queries
   - High-traffic endpoints

3. **Security Concerns**: Add to Agent 4
   - Authentication flows specific to project
   - Sensitive data paths

### Using Project Directives

If `context/directives.md` exists:
- Extract relevant coding standards
- Add as verification criteria to agents
- Check for directive violations

---

## Important Notes

- **Analysis Only**: Reviews should NOT make changes
- **Ask Before Modifying**: If issues found, ask before fixing
- **Verification Required**: Every finding must be verifiable
- **Regression Tracking**: Always check previous reviews
- **Context First**: Read docs before analyzing code
