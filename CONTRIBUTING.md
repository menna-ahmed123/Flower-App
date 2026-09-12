# Contributing

## Branch Naming Convention

All branches must follow one of the following naming conventions:

- `feature/<name>` - New features
- `bugfix/<name>` - Bug fixes
- `hotfix/<name>` - Urgent production fixes
- `release/<name>` - Release preparation

### Examples

- `feature/login`
- `bugfix/cart-total`
- `hotfix/payment-crash`
- `release/v1.0.0`

Branches that do not follow these conventions will fail the branch name check.
## Pull Request Titles

Pull request titles must follow this convention:

```text
type(scope): description
```

`scope` is optional. A colon and a non-empty description are required.

### Allowed types

- `feat`
- `fix`
- `chore`
- `refactor`
- `docs`
- `test`
- `build`
- `ci`
- `perf`
- `revert`

### Valid examples

- `feat(cart): add checkout screen`
- `fix(checkout): resolve delivery fee issue`
- `chore(ci): add PR title validation`
- `refactor(cart): simplify cart provider`
- `docs(readme): update setup instructions`

### Invalid examples

- `Update cart`
- `fix cart issue`
- `Added checkout`
- `Cart changes`
- `[FIX] cart issue`
- `unknown(scope): something`
- `feat:`

PR titles are validated automatically by GitHub Actions. Pull requests with titles that do not match this convention will fail the **PR Title Check**.
