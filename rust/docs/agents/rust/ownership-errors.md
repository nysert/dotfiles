# Ownership and Errors

Read when changing ownership, borrowing, lifetimes, allocations, or fallible operations.

- Make ownership explicit in public APIs: borrow for temporary inspection; transfer owned data when it must outlive the input.
- Check data flow before adding `clone()`, `Rc<RefCell<_>>`, or `Arc<Mutex<_>>` to work around a compiler error.
- Prefer understandable owned values over unnecessary lifetime-heavy abstractions.
- Avoid holding blocking locks across `.await`; keep lock scopes short.
- Propagate recoverable errors with `Result` and `?`; preserve their original cause and meaningful context.
- Prefer typed errors for library boundaries; application outer layers may use existing contextual error tooling.
- Translate errors to HTTP/CLI/job output at the edge rather than in domain logic.
- Never turn a relevant failure into a silent default or `.ok()` without deliberate fallback semantics.
- Reserve `panic!`/`expect` for tests, programmer errors, and documented invariants—not malformed external data.
- Exercise malformed input and error paths without including secrets in diagnostic output.
