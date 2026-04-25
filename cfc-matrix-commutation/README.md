# Matrix-level CFC commutation lemmas

Staging directory for a Mathlib4 pull request that adds matrix-specific corollaries of the existing continuous functional calculus commutation theorems.

## Status

| Gate | Status |
|---|---|
| Compilation gate (lake build PASS against Mathlib v4.27.0) | Pending — first build run not yet executed |
| Sorry count target for v1 | 0 (proofs are mechanical specializations of `IsSelfAdjoint.commute_cfcHom`) |
| Upstream PR | Not yet submitted |

## Scope

Two theorems in the `Matrix` namespace:

- `Matrix.PosSemidef.commute_sqrt` — if `b` commutes with a positive semidefinite matrix `ρ`, then `b` commutes with `CFC.sqrt ρ`.
- `Matrix.PosSemidef.sqrt_mul_eq_of_commute` — equation form of the above.

Both are direct specializations of `IsSelfAdjoint.commute_cfcHom` (defined in `Mathlib/Analysis/CStarAlgebra/ContinuousFunctionalCalculus/Commute.lean`) to the matrix algebra `Matrix n n ℂ`. Positive semidefinite matrices are automatically self-adjoint (`PosSemidef.isHermitian`), so the self-adjoint specialization applies directly.

## Mathlib infrastructure dependencies

- `Mathlib.LinearAlgebra.Matrix.PosDef` — `Matrix.PosSemidef`, `Matrix.PosSemidef.isHermitian`
- `Mathlib.Analysis.SpecialFunctions.ContinuousFunctionalCalculus.Rpow.Basic` — `CFC.sqrt`
- `Mathlib.Analysis.Matrix.Order` — scoped `MatrixOrder` instance providing `StarOrderedRing (Matrix n n ℂ)`
- `Mathlib.Analysis.Matrix.Normed` — normed structure on the matrix algebra
- `Mathlib.Analysis.CStarAlgebra.ContinuousFunctionalCalculus.Commute` — `IsSelfAdjoint.commute_cfcHom` (the lifted theorem)

## Building

```bash
cd cfc-matrix-commutation
lake update    # downloads pinned Mathlib v4.27.0 (~2-5 GB on first run)
lake build     # subsequent builds use cached artifacts
```

## Downstream consumers

A follow-up Uhlmann quantum fidelity formalization (sibling staging directory `uhlmann-fidelity/`) uses these commutation lemmas to discharge four currently-stubbed properties (`uhlmannFidelity_self`, `uhlmannFidelity_smul`, `uhlmannFidelity_unitaryInvariant`, `uhlmannFidelity_commute`).

## References

- R. Bhatia. *Matrix Analysis*. Springer-Verlag, 1997. §V.1.
- Loreaux, J. (2025). `Mathlib/Analysis/CStarAlgebra/ContinuousFunctionalCalculus/Commute.lean`. Lean 4 Mathlib4 source.

## Tooling and acknowledgments

This file was prepared with assistance from Anthropic's Claude (Claude Code CLI) for proof drafting, Mathlib API search, and tactic iteration. All mathematical statements and proof tactics are author-verified against Mathlib v4.27.0 source. The author is responsible for the final content.
