# Workflow

Detailed guidance referenced by `docs/testing.md`.

Read this file when implementing or reviewing behavior changes.

## Working strategy

While implementing a change:

1. Run the narrowest relevant test first.
2. Iterate using focused tests.
3. Apply mechanical lint/format fixes when useful.
4. Expand to the affected test area.
5. Run the project's full non-mutating completion checks.

Use scripts already defined in `package.json`.

Do not assume npm when the repository uses another package manager.

---

## Mechanical fixes

When the project defines these scripts:

```json
{
  "scripts": {
    "lint:fix": "eslint . --fix",
    "format": "prettier --write .",
    "fix": "npm run lint:fix; npm run format"
  }
}
```

the agent may run:

```sh
npm run fix
```

or the equivalent command for the repository's package manager.

`fix` is intentionally mutating.

The semicolon is deliberate for this POSIX/macOS-oriented setup:

- ESLint applies every automatic lint fix it can.
- Prettier still runs afterward even if ESLint leaves unresolved errors.
- Final correctness is determined by `check`, not by `fix`.

After running `fix`:

1. Inspect the resulting diff.
2. Ensure only intended files changed.
3. Do not treat `fix` as proof that validation passes.
4. Run the non-mutating checks afterward.

Do not use automated fixing to rewrite unrelated files.

---

## Verification commands

Prefer non-mutating verification commands:

```sh
npm run format:check
npm run lint
npm run typecheck
npm run test
npm run build
```

when those scripts exist.

If the repository provides:

```sh
npm run check
```

prefer it for final verification.

A typical `check` script is:

```json
{
  "scripts": {
    "check": "npm run format:check && npm run lint && npm run typecheck && npm run test"
  }
}
```

Add `npm run build` when a build step is part of the project's normal completion contract.

`check` should use fail-fast sequencing such as `&&` so any failed verification returns a non-zero status.

The final verification path must not intentionally modify source files.

---

## Completion checklist

Before considering behavior changes complete, verify:

- [ ] Changed behavior has appropriate coverage.
- [ ] Tests focus on public behavior.
- [ ] Important failure paths are covered.
- [ ] External I/O is controlled at a clear boundary.
- [ ] Relevant focused tests pass.
- [ ] `format:check` passes when defined.
- [ ] `lint` passes when defined.
- [ ] `typecheck` passes when defined.
- [ ] Relevant tests pass.
- [ ] `build` passes when defined and applicable.
- [ ] `check` passes when defined.
- [ ] Automated fixes were reviewed for unrelated changes.
- [ ] A mutating formatter/fixer command was not mistaken for verification.
- [ ] Unrelated failures were not silently modified.

If the full test suite or build is unusually expensive, run the broadest practical affected checks and clearly report what was not run.
