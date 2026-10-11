# Testing Workflow

Read when implementing or reviewing changed behavior.

1. Run a focused test first (e.g. `cargo test -p <crate> <filter>` in a workspace).
2. Iterate on affected tests and error scenarios.
3. If needed, run mutating `cargo fmt --all`, then review the diff.
4. Run non-mutating formatting, lint, and test verification.
5. Include supported features, targets, and external services required by CI.

## Common checks

```sh
cargo fmt --all -- --check
cargo clippy --workspace --all-targets -- -D warnings
cargo test --workspace
cargo check --workspace --all-targets
```

Do not assume `--all-features` is valid for mutually exclusive features. Follow existing `just`, `make`, `nextest`, or CI commands when available. Test WASM and non-default targets when affected.

## Completion checklist

- [ ] Relevant new or changed behavior has tests.
- [ ] Important failures and cleanup paths are exercised.
- [ ] Required lint/format/build/test checks pass.
- [ ] Supported features and targets are covered.
- [ ] Formatter changes were inspected; unrelated files remain untouched.
- [ ] Unrun or failing checks are reported clearly.
