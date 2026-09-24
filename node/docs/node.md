# Node.js and TypeScript Conventions

Use this file when creating or modifying Node.js, JavaScript, or TypeScript code.

The project's ESLint, Prettier, or Biome configuration is the source of truth for mechanically enforceable formatting and style.

Do not duplicate formatter/linter rules here unless the convention cannot be expressed reliably through those tools.

## Core rules

- Follow the project's existing JavaScript vs TypeScript choice; do not migrate languages incidentally.
- Follow the existing ESM vs CommonJS choice; do not mix module systems without a concrete requirement.
- Prefer modern Node.js built-ins and platform APIs before adding dependencies.
- Prefer `async`/`await` for asynchronous control flow.
- Await or intentionally return promises; do not leave floating promises.
- Keep functions and modules focused, with explicit inputs, outputs, and side effects.
- Validate data at trust boundaries rather than scattering defensive checks throughout internal code.
- Preserve useful error context when wrapping errors.
- Do not silently swallow failures.
- Prefer project scripts from `package.json` over ad-hoc global commands.
- Use the package manager and lockfile already selected by the repository.
- Do not depend on globally installed project tooling.

## Tooling baseline

This preset includes:

- `eslint.config.mjs`
- `prettier.config.mjs`

If the project uses these files, install the corresponding tools locally:

```sh
npm install --save-dev \
  eslint \
  @eslint/js \
  globals \
  typescript-eslint \
  prettier
```

Use the project's package manager instead of `npm` when applicable.

If the project uses Biome instead, use a local `@biomejs/biome` dependency and the project's `biome.json` or `biome.jsonc`.

Do not keep ESLint or Prettier solely because the editor requires them. The editor must follow the project tooling, not dictate it.

## Read when relevant

- Implementation, async/error handling, and TypeScript guidance → `docs/node/implementation.md`
- ESM/CommonJS, imports, exports, and module boundaries → `docs/node/modules.md`

## Standard project scripts

When establishing Node.js tooling for a project, prefer conventional scripts with separate mutation and verification responsibilities.

Recommended names:

```text
lint          non-mutating ESLint check
lint:fix      ESLint auto-fix
format        Prettier write
format:check  Prettier verification
typecheck     TypeScript verification
test          test suite
build         build verification when applicable
fix           lint:fix + format
check         non-mutating completion checks
```

A simple POSIX/macOS setup is:

```json
{
  "scripts": {
    "lint": "eslint .",
    "lint:fix": "eslint . --fix",
    "format": "prettier --write .",
    "format:check": "prettier --check .",
    "typecheck": "tsc --noEmit",
    "test": "vitest run",
    "fix": "npm run lint:fix; npm run format",
    "check": "npm run format:check && npm run lint && npm run typecheck && npm run test"
  }
}
```

Use the repository's actual package manager rather than assuming `npm`.

The intended agent workflow is:

```sh
npm run fix
npm run check
```

`fix` may modify files and may still leave unresolved issues.

`check` is the authoritative non-mutating completion gate and must pass before the task is considered complete.

## Completion

Use the scripts already defined by the project.

Run only commands that exist for the repository.

When `fix` exists, it may be used during implementation to apply mechanical changes.

Before completion, prefer `check` when it exists.

If `check` does not exist, run the applicable equivalents of:

- format check
- lint
- typecheck
- tests
- build

Report any broader check that could not be run.

Do not fix unrelated failures unless required by the task.
