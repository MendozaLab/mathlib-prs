# Frobenius inner product on complex matrices

Staging directory for a Mathlib4 pull request that defines the Frobenius (Hilbert-Schmidt) inner product on `Matrix n n ℂ`, registers the corresponding `InnerProductSpace ℂ` instance, and lifts Cauchy-Schwarz to the matrix-trace form.

## Status

| Gate | Status |
|---|---|
| Compilation gate (lake build PASS against Mathlib v4.27.0) | Pending — first build run not yet executed |
| Sorry count target for v1 | 0 (proofs are mechanical; current scaffold has placeholders for first build cycle) |
| Upstream PR | Not yet submitted |

## Scope

One definition + five algebraic-property theorems + one Cauchy-Schwarz lifting theorem in the `Matrix` namespace:

- `Matrix.frobeniusInner` — definition `⟨A, B⟩_F = Tr(Aᴴ · B)`.
- `Matrix.frobeniusInner_conj_symm` — conjugate symmetry.
- `Matrix.frobeniusInner_add_right` — additivity in the second argument.
- `Matrix.frobeniusInner_smul_right` — linearity in the second argument.
- `Matrix.frobeniusInner_self_nonneg` — non-negativity of the self inner product.
- `Matrix.frobeniusInner_self_eq_zero_iff` — definiteness.
- `Matrix.trace_cauchy_schwarz` — Cauchy-Schwarz in matrix-trace form.

Plus an `InnerProductSpace.Core` registration (added in subsequent build cycles after the algebraic properties land) which yields the canonical `InnerProductSpace ℂ (Matrix n n ℂ)` instance and unlocks Mathlib's full inner-product-space machinery for matrix arguments.

## Mathlib infrastructure dependencies

- `Mathlib.LinearAlgebra.Matrix.PosDef` — `Matrix.posSemidef_conjTranspose_mul_self`, `Matrix.trace_conjTranspose_mul_self_eq_zero_iff`
- `Mathlib.Analysis.InnerProductSpace.Basic` — `InnerProductSpace.Core`, `inner_mul_le_norm_mul_norm`
- `Mathlib.Analysis.Matrix.Order` — scoped `MatrixOrder` instance providing `StarOrderedRing (Matrix n n ℂ)`

## Building

```bash
cd frobenius-inner-product
lake update    # downloads pinned Mathlib v4.27.0 (~2-5 GB on first run)
lake build     # subsequent builds use cached artifacts
```

## Downstream consumers

This is the foundational prerequisite for several other Mathlib4 contributions:

- A planned trace Cauchy-Schwarz wrapper (currently the `trace_cauchy_schwarz` theorem in this file) is the foundation for matrix-norm bounds throughout the matrix-analysis library.
- A follow-up Uhlmann quantum fidelity formalization (sibling staging directory `uhlmann-fidelity/`) uses trace Cauchy-Schwarz to discharge an upper-bound theorem `uhlmannFidelity_le_traceMul`.

## References

- R. Bhatia. *Matrix Analysis*. Springer-Verlag, 1997. §IV.5 (matrix norms and the trace inner product).
- R. A. Horn and C. R. Johnson. *Matrix Analysis*. Cambridge University Press, 2nd edition, 2013. §5.2 (Hilbert-Schmidt / Frobenius norm).

## Tooling and acknowledgments

This file was prepared with assistance from Anthropic's Claude (Claude Code CLI) for proof drafting, Mathlib API search, and tactic iteration. All mathematical statements and proof tactics are author-verified against Mathlib v4.27.0 source. The author is responsible for the final content.
