# Project Directives

Guidelines and standards for this codebase. Claude will reference these during code reviews, brainstorming, and implementation.

---

## Project Overview

<!-- Brief description of what this project does -->

**Name**: [Project Name]
**Type**: [Web App | CLI | Library | Service | etc.]
**Primary Language**: [Python | TypeScript | Go | etc.]
**Framework**: [FastAPI | Next.js | etc.]

---

## Architecture Principles

### Core Patterns

<!-- Define patterns used in this codebase -->

- [ ] **Dependency Injection**: Constructor injection / Factory functions / Singletons
- [ ] **Error Handling**: Exceptions / Result types / Error codes
- [ ] **Async Model**: async/await / callbacks / sync
- [ ] **State Management**: [describe approach]

### Directory Structure

```
project/
├── [main source]/     # [purpose]
├── [tests]/           # [purpose]
├── [config]/          # [purpose]
└── [docs]/            # [purpose]
```

### Boundaries

<!-- Define clear boundaries between layers/components -->

| Layer | Responsibilities | Can Import From |
|-------|------------------|-----------------|
| API | Request handling, validation | Services, Schemas |
| Services | Business logic | Repositories, External clients |
| Repositories | Data access | Models |

---

## Code Standards

### Naming Conventions

| Entity | Convention | Example |
|--------|------------|---------|
| Files | snake_case / kebab-case | `user_service.py` |
| Classes | PascalCase | `UserService` |
| Functions | snake_case / camelCase | `get_user_by_id` |
| Constants | UPPER_SNAKE_CASE | `MAX_RETRY_COUNT` |
| Private | _prefix / #prefix | `_internal_method` |

### Import Organization

```python
# Example for Python
# 1. Standard library
# 2. Third-party packages
# 3. Local imports (absolute)
# 4. Local imports (relative)
```

### Documentation

- [ ] Public APIs require docstrings
- [ ] Complex algorithms require inline comments
- [ ] README for each major component
- [ ] Type hints required / optional

---

## Error Handling

### Standard Patterns

```python
# Example pattern for this project
# [Include actual patterns used]
```

### Error Categories

| Category | Handling | Example |
|----------|----------|---------|
| Validation | Return 400 / raise ValueError | Invalid input |
| Not Found | Return 404 / raise NotFoundError | Missing resource |
| Auth | Return 401/403 | Unauthorized |
| External | Retry with backoff | API failures |
| Internal | Log + generic error | Unexpected |

### Retry Policy

- **External APIs**: [retry count, backoff strategy]
- **Database**: [retry count, which errors]
- **Message queues**: [retry/DLQ policy]

---

## Testing Standards

### Test Structure

```
tests/
├── unit/           # Isolated unit tests
├── integration/    # Component integration
├── e2e/            # End-to-end flows
└── fixtures/       # Shared test data
```

### Coverage Requirements

- [ ] Unit test coverage: [X]%
- [ ] Critical paths: 100%
- [ ] New code must include tests

### Test Naming

```python
# Pattern: test_<what>_<when>_<expected>
def test_user_creation_with_valid_data_succeeds():
    pass
```

---

## Performance Guidelines

### Database

- [ ] Use batch operations for bulk inserts/updates
- [ ] Avoid N+1 queries (use eager loading / UNWIND)
- [ ] Index frequently filtered columns
- [ ] Connection pooling required

### Caching

- [ ] Cache TTL: [default TTL]
- [ ] Cache invalidation: [strategy]
- [ ] Cacheable: [what to cache]

### Limits

| Resource | Limit | Rationale |
|----------|-------|-----------|
| API payload | [X] MB | Memory constraints |
| Batch size | [X] items | DB performance |
| Concurrent connections | [X] | Pool size |

---

## Security Requirements

### Authentication

- [ ] Auth method: [JWT / API Key / OAuth]
- [ ] Token expiry: [duration]
- [ ] Refresh strategy: [approach]

### Authorization

- [ ] RBAC / ABAC / Custom
- [ ] Resource ownership checks required
- [ ] Admin routes protected

### Data Protection

- [ ] PII handling: [requirements]
- [ ] Secrets: Environment variables only
- [ ] Logging: Never log sensitive data

### Input Validation

- [ ] All user input validated at API boundary
- [ ] Parameterized queries only (no string interpolation)
- [ ] File paths sanitized

---

## External Integrations

### APIs

| Service | Purpose | Auth | Rate Limit |
|---------|---------|------|------------|
| [Service] | [purpose] | [method] | [limit] |

### Databases

| Database | Purpose | Connection |
|----------|---------|------------|
| [DB] | [purpose] | [pool config] |

---

## Deployment

### Environments

| Env | Purpose | Config Source |
|-----|---------|---------------|
| local | Development | .env.local |
| staging | Testing | secrets manager |
| production | Live | secrets manager |

### CI/CD

- [ ] Lint check required
- [ ] Type check required
- [ ] Tests must pass
- [ ] Coverage threshold: [X]%

---

## Review Checklist

Before merging, verify:

- [ ] Follows naming conventions
- [ ] Error handling complete
- [ ] Tests included
- [ ] No hardcoded secrets
- [ ] Documentation updated
- [ ] Performance considered
- [ ] Security reviewed

---

## Project-Specific Rules

<!-- Add any project-specific guidelines below -->

### Domain Rules

<!-- Business logic constraints, formulas, algorithms -->

### Forbidden Patterns

<!-- Anti-patterns to avoid in this codebase -->

- [ ] [Pattern]: [Why forbidden]

### Required Patterns

<!-- Patterns that must be used -->

- [ ] [Pattern]: [When to use]
