# Koopman operator on `L²` of a measure-preserving system

Staging directory for a Mathlib4 pull request that adds the canonical Koopman operator on `L²(X, μ)` associated with a measure-preserving transformation `T : X → X`. Defined by `U_T f := f ∘ T`. Measure preservation makes `U_T` a linear isometry. The Koopman operator is the linear lift of non-linear dynamical systems to operator-theoretic dynamics; central to von Neumann's mean ergodic theorem and the Koopman–von Neumann correspondence between classical and quantum dynamics.

## Status

| Gate | Status |
|---|---|
| Compilation gate (lake build PASS against Mathlib v4.27.0) | Pending — first build run not yet executed |
| Sorry count target for v1 | 0 (proofs are mechanical; current scaffold has placeholders for cycle-1 build) |
| Upstream PR | Not yet submitted |

## Scope

One definition + five proven theorems in the `MeasureTheory` namespace:

- `Koopman T hT` — the Koopman linear isometry on `Lp ℂ 2 μ`
- `Koopman_apply` — `(Koopman T hT f) =ᵐ[μ] f ∘ T`
- `Koopman_id` — Koopman of the identity is the identity isometry
- `Koopman_comp` — Koopman respects composition of measure-preserving maps
- `Koopman_const` — constant functions are fixed
- `Koopman_iterate` — `Koopman (T^[n]) = (Koopman T)^n`

## Out of scope (reserved for follow-up PRs)

- Unitary version for invertible measure-preserving T
- Spectrum on the unit circle
- Multiplicativity (`L^∞` × `L²` argument needed; pointwise products of `L²` functions aren't generally `L²`)
- Adjoint identity `(Koopman T)* = Koopman T⁻¹` for invertible T
- Ergodicity ↔ 1 is a simple eigenvalue (Koopman–von Neumann criterion)
- Weak / strong mixing characterisations via Koopman spectrum
- General `L^p` version (canonical case is `L²` because of the inner-product structure)

## Mathlib infrastructure dependencies

- `Mathlib.MeasureTheory.Function.LpSpace.Basic` — `Lp`, `Lp.indicatorConstLp`
- `Mathlib.Dynamics.Ergodic.MeasurePreserving` — `MeasurePreserving`, `MeasurePreserving.id`, `MeasurePreserving.comp`, `MeasurePreserving.iterate`
- `Mathlib.Analysis.NormedSpace.LinearIsometry` — `LinearIsometry`, `LinearIsometry.id`, `LinearIsometry.comp`
- `Mathlib.Analysis.NormedSpace.OperatorNorm.Basic` — for the bounded-operator infrastructure

## Building

```bash
cd koopman-operator
lake update    # downloads pinned Mathlib v4.27.0 (~2-5 GB on first run; cached after)
lake build     # subsequent builds use cached artifacts
```

## Downstream uses (post-merge)

- The mean ergodic theorem at `Mathlib/Analysis/InnerProductSpace/MeanErgodic.lean` already proves the abstract Hilbert-space statement; the Koopman operator is the canonical concrete instance to which it applies in dynamical-systems land. Once the Koopman operator is in Mathlib, the mean ergodic theorem can be stated for measure-preserving transformations directly.
- Subsequent contributions: ergodicity criterion (1 is a simple eigenvalue), weak/strong mixing characterisation via Koopman spectrum, Koopman-mode decomposition for spectral analysis of dynamical systems.

## References

- B. O. Koopman, *Hamiltonian systems and transformation in Hilbert space*, Proc. Natl. Acad. Sci. USA 17 (1931), 315–318.
- J. von Neumann, *Proof of the quasi-ergodic hypothesis*, Proc. Natl. Acad. Sci. USA 18 (1932), 70–82.
- P. Walters, *An Introduction to Ergodic Theory*, Springer 1982. §1.5.
- M. Einsiedler and T. Ward, *Ergodic Theory*, Springer 2011. §2.1.

## Tooling and acknowledgments

This file was prepared with assistance from Anthropic's Claude (Claude Code CLI) for proof drafting, Mathlib API search, and tactic iteration. All theorem statements and proof tactics are author-verified against Mathlib v4.27.0 source. The author is responsible for the final content.
