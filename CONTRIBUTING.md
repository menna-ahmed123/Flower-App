# Contributing

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
