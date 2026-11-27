# Module and Function Complexity

Apply these rules to all handwritten production Rust code, including libraries, entry points, workflows, and providers.

## Review cohesion first

Give every file a cohesive responsibility. Split independent actions and unrelated responsibilities at any size. A 150-line file with five independent business actions needs to be split. A cohesive 350-line algorithm can stay together after review if splitting it would obscure the implementation.

Review decomposition whenever a module:

- Contains independent actions or unrelated public functions.
- Mixes transport handling with workflows, or provider-specific details with provider-independent workflows.
- Orchestrates several complex steps that can be grouped into distinct responsibilities.
- Accumulates unrelated types, errors, private helpers, or persistence operations.
- Introduces deeply nested control flow.
- Repeatedly grows with unrelated requests or requires reading substantial unrelated code to understand or test it.

## Review production file length

Apply these thresholds to new and materially modified production modules. Count handwritten production source lines, including documentation and ordinary formatting. Exclude generated code (including generated ORM entities), test-only fixtures, and inline test-only modules. Use `wc -l path/to/file.rs` for an initial count, then inspect the file and subtract excluded content before applying the thresholds.

| Handwritten production lines | Required behavior |
| ---: | --- |
| 1–200 | Preferred range |
| 201–300 | Acceptable if cohesive |
| 301–500 | Review for decomposition |
| 501–1,000 | Decompose or explicitly justify |
| Over 1,000 | Exceptional and strongly discouraged. Decompose or explicitly justify. |

## Review function complexity

These are project engineering thresholds.

| Metric | Required review or action |
| --- | --- |
| Function length over 50 lines | Review |
| Function length over 100 lines | Decompose or explicitly justify |
| Cognitive complexity over 15 | Review and address Clippy |
| Cyclomatic complexity over 10 | Review |
| Control-flow nesting over 4 levels | Review |
| More than 7 function arguments | Review and address Clippy |

Use guard clauses, focused helper functions, enums, explicit state transitions, or cohesive private submodules when they clarify the logic. Create wrappers or parameter structs only when they express a meaningful boundary or contract.

## Work incrementally in existing modules

1. Before adding substantial functionality, inspect the module's responsibility and production line count.
2. Put independent actions in separate modules. For additions to the same action, look for internal responsibilities that warrant private submodules.
3. Review natural decomposition boundaries in oversized files. Refactor the relevant portion when practical and preserve caller-facing interfaces. Leave unrelated legacy modules outside the scope of the change.
4. Review the resulting file and function complexity. Explain any remaining threshold exception and why keeping the implementation together is appropriate.
5. Run applicable formatting, Clippy, and test checks. Report remaining complexity exceptions at completion.

Preserve useful comments and ordinary formatting. Avoid arbitrary splits such as `part1.rs` and `part2.rs`, catch-all modules, unnecessary abstractions or visibility, macros that conceal complexity, and lint suppressions without a documented reason. Split code along responsibility boundaries.

## Use Clippy for function-level checks

The preset's `clippy.toml` sets thresholds for `too_many_lines`, `cognitive_complexity`, and `too_many_arguments`. Place it where Clippy discovers the project's configuration, normally at the Cargo workspace root. If the project already has `clippy.toml` or `.clippy.toml`, use its existing configuration and reconcile equivalent settings there. Follow the lint activation instructions in [Rust conventions](../rust.md#completion). Enable the individual lints without enabling the entire pedantic or restriction groups.

When an exception is justified, scope the lint allowance to the function and put the reason immediately above the attribute. For example, this excerpt shows an application-specific parser signature:

```rust
// Keeping the transitions together makes the parsing state machine easier to follow.
#[allow(clippy::too_many_lines)]
fn parse_complex_document(_input: &str) -> Result<Document, ParseError> {
    todo!("Parsing implementation omitted")
}
```

Keep the lints enabled at the project level. Clippy measures certain kinds of function complexity. Production lines per file, responsibility boundaries, and whether a module contains independent actions still require manual review. Review cyclomatic complexity and nesting manually unless the application already has appropriate automation.
