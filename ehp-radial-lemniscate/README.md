# EHP radial lemniscate seed

Local staging directory for possible Mathlib4 support lemmas around the radial
lemniscate family

```text
p_a(z) = z^n - a.
```

This is not a Mathlib PR yet. It is a local seed queue entry.

## Status

| Gate | Status |
|---|---|
| Compilation gate | Not run |
| Sorry count target for initial seed | Explicit sorry stubs allowed |
| Upstream PR | Not submitted |

## Scope

Candidate upstreamable material:

- parameterization of the radial lemniscate by `z^n = a + exp(i t)`;
- exact length integral shape:

  ```text
  L_n(a) = integral_0^(2*pi) |a + exp(i t)|^(1/n - 1) dt;
  ```

- exact `a = 1` beta/gamma value:

  ```text
  L_n(1) = 2^(1/n) * Beta(1/2, 1/(2n)).
  ```

## Out Of Scope

- The EHP114 conjecture itself.
- Finite computational certificates.
- Stratified Koopman-Tensor Certification.
- Tensor-cone proof architecture.
- Any claim that the conjecture is solved.

## Current Risk

The branch map `z -> z^n` is singular at `z = 0`, and the `a = 1` length
integral has an integrable singularity. A Mathlib theorem statement must expose
this honestly instead of pretending the curve is smooth everywhere.

## Build

```bash
cd ehp-radial-lemniscate
lake update
lake build
```

The first build is expected to fail until the seed statements are adjusted to
current Mathlib APIs.

