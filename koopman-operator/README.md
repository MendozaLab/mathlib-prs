# Koopman operator on `L²` of a measure-preserving system

Staging directory for a Mathlib4 pull request that adds the canonical Koopman operator on `L²(X, μ)` associated with a measure-preserving transformation `T : X → X`. Defined by `U_T f := f ∘ T`. Measure preservation makes `U_T` a linear isometry. The Koopman operator is the linear lift of non-linear dynamical systems to operator-theoretic dynamics; central to von Neumann's mean ergodic theorem and the Koopman–von Neumann correspondence between classical and quantum dynamics.

## Status

| Gate | Status |
|---|---|
| Compilation gate | PASS on 2026-04-29 against Mathlib `master` at `95dcb74bf07a3a4f6828034c836a45b8fe7c6ca8` |
| Sorry / axiom count | 0 executable `sorry`, 0 executable `axiom` |
| Upstream PR | Prepared locally; not yet submitted |

## Scope

One definition + five proven theorems in the `MeasureTheory` namespace:

- `Koopman T hT` — the Koopman linear isometry on `Lp ℂ 2 μ`
- `Koopman_apply` — `(Koopman T hT f) =ᵐ[μ] f ∘ T`
- `Koopman_id` — Koopman of the identity is the identity isometry
- `Koopman_comp` — Koopman is contravariantly functorial under composition:
  `Koopman (T ∘ S) _ = (Koopman S _).comp (Koopman T _)`
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

- `Mathlib.MeasureTheory.Function.LpSpace.Indicator` — `Lp`, `Lp.const`
- `Mathlib.Dynamics.Ergodic.MeasurePreserving` — `MeasurePreserving`, `MeasurePreserving.id`, `MeasurePreserving.comp`, `MeasurePreserving.iterate`
- `Mathlib.Analysis.Normed.Operator.LinearIsometry` — `LinearIsometry`, `LinearIsometry.id`, `LinearIsometry.comp`

## Building

```bash
cd koopman-operator
lake update
lake build Mathlib.Dynamics.Ergodic.Koopman
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

This file was prepared with local proof-search assistance for API search and tactic iteration. All theorem statements and proof tactics are author-verified against Mathlib `master` at `95dcb74bf07a3a4f6828034c836a45b8fe7c6ca8`. The author is responsible for the final content.
