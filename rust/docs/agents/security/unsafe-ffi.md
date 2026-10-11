# Unsafe Rust and FFI

Read for `unsafe`, FFI, raw pointers, pinning, layout, or manual memory handling.

- Prefer safe standard-library or maintained library APIs when they suffice.
- Minimize unsafe regions and document each with a meaningful `// SAFETY:` invariant.
- Ensure public safe callers cannot violate the unsafe preconditions.
- Review aliasing, lifetimes, initialization, alignment, pinning, thread-safety, and ownership.
- Document FFI ABI, nullability, allocation/deallocation, ownership transfers, and error behavior.
- Prevent unwinding across unsupported foreign function boundaries.
- Test edge cases and target platforms; use Miri/sanitizers when appropriate and available.
- Passing tests do not prove safety: independently verify the stated invariants.
