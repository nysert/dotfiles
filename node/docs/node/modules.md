# Modules

Detailed guidance referenced by `docs/node.md`.

Read this file when module boundaries, imports, exports, or package structure are relevant.

## Module system

Follow the repository's existing module system.

For ESM projects, respect `"type": "module"` and the project's TypeScript module settings.

For CommonJS projects, preserve the existing `require` / `module.exports` convention unless an intentional migration is part of the task.

Do not mix ESM and CommonJS as incidental cleanup.

## Imports

- Prefer stable package/public module entry points over dependency internals.
- Keep imports at the top level unless dynamic import is required for lazy loading, optional dependencies, runtime isolation, or intentionally deferred initialization.
- Avoid circular dependencies.
- Respect path aliases only when the project already configures them consistently across TypeScript, tests, runtime, bundling, and linting.
- Do not introduce an alias that works only in the editor.

## Exports

- Export the smallest useful public surface.
- Prefer named exports for reusable application/library modules unless the surrounding project consistently uses default exports.
- Do not expose private implementation details merely to make tests easier.
- Keep transport/framework-specific types out of core domain modules when practical.

## File boundaries

Prefer organizing code by domain or capability over large generic directories such as `utils`, `helpers`, `common`, or `misc` when those directories would collect unrelated behavior.

When adding a file, prefer placing it beside the behavior it supports unless an established project structure says otherwise.
