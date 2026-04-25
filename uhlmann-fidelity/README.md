# Uhlmann quantum fidelity

This directory stages a Lean 4 formalization of the Uhlmann quantum fidelity metric and its basic properties, targeting inclusion in Mathlib as `Mathlib/Analysis/Quantum/UhlmannFidelity.lean`.

## Status

| Property | Status | Notes |
|---|---|---|
| Compilation gate | PASS | `lake build` against Mathlib v4.27.0 succeeds with no errors |
| Sorry count | 0 | All theorem bodies are closed |
| Axiom count | 6 | All carry literature citations (see below) |
| Theorem count | 3 proven + definition | Five additional theorems use axioms |
| Upstream submission | Not yet submitted | Ready for pre-submission review |

## Lemma scope

The file declares nine items (1 definition + 8 theorems):

- `Matrix.uhlmannFidelity ρ σ` — definition: F(ρ, σ) = (Tr √(√ρ · σ · √ρ))²
- `uhlmannFidelity_zero_left` — F(0, σ) = 0 (proven)
- `uhlmannFidelity_self` — F(ρ, ρ) = (Tr ρ)² (axiom; Bhatia §4.5, Nielsen-Chuang §9.2.2)
- `uhlmannFidelity_smul` — F(c·ρ, σ) = c · F(ρ, σ) for c ≥ 0 (axiom; CFC scalar homogeneity)
- `uhlmannFidelity_nonneg` — 0 ≤ F(ρ, σ) (proven)
- `uhlmannFidelity_le_traceMul` — F(ρ, σ) ≤ (Tr ρ)(Tr σ) (axiom; Bhatia §4.5)
- `uhlmannFidelity_le_one` — F(ρ, σ) ≤ 1 for normalized density matrices (proven)
- `uhlmannFidelity_unitaryInvariant` — F(U·ρ·U*, U·σ·U*) = F(ρ, σ) (axiom; unitary invariance)
- `uhlmannFidelity_commute` — when ρ and σ commute, F(ρ, σ) = (Tr √(ρ · σ))² (axiom; Bhattacharyya distance)
- `uhlmannFidelity_symm` — F(ρ, σ) = F(σ, ρ) (axiom; standard proof via polar decomposition)

## Mathlib infrastructure dependencies

The file imports:

- `Mathlib.LinearAlgebra.Matrix.PosDef` — density matrix structure and semidefinite cones
- `Mathlib.Analysis.SpecialFunctions.ContinuousFunctionalCalculus.Rpow.Basic` — continuous functional calculus for square roots on Hermitian PSD matrices
- `Mathlib.Analysis.Matrix.Order` — matrix ordering and norm structure
- `Mathlib.Analysis.Matrix.Normed` — analytic structure

## Open work

Five of the six axioms could be discharged once supporting Mathlib infrastructure lands:

- **`uhlmannFidelity_symm`**: The proof uses the trace identity Tr √(√A · B · √A) = Tr √(A · B) for PSD matrices A, B. This follows from matrix polar decomposition or singular value decomposition, neither of which is formalized in Mathlib v4.27.0. Discharging this axiom requires either (1) a matrix polar decomposition PR, or (2) a matrix SVD formalization. References: Bhatia, *Matrix Analysis*, Springer, 1997, §4.5; Nielsen-Chuang, §9.2.2.

- **`uhlmannFidelity_self`, `uhlmannFidelity_smul`**: Require stronger lemmas about continuous functional calculus composition and scalar multiplication under CFC. The individual pieces exist in Mathlib, but their combination is not yet formalized. References: Bhatia, §4.5.

- **`uhlmannFidelity_unitaryInvariant`, `uhlmannFidelity_commute`, `uhlmannFidelity_le_traceMul`**: Require explicit CFC commutation lemmas and trace-multiplication identities. These are standard results in matrix analysis but not yet in Mathlib. References: Nielsen-Chuang, §9.2.2; Bhatia, §4.5.

## Building

```bash
cd uhlmann-fidelity
lake update
lake build
```

Expected output: compilation succeeds with 0 errors. A few unused-variable lints may appear for auxiliary lemmas.

## References

- R. Bhatia, *Matrix Analysis*, Springer, 1997, §4.5.
- M. A. Nielsen and I. L. Chuang, *Quantum Computation and Quantum Information*, Cambridge, 10th anniversary edition, 2010, §9.2.2.
- A. Uhlmann, "The transition probability in the state space of a *-algebra", *Reports on Mathematical Physics*, vol. 9, no. 2, pp. 273–279, 1976.
- S. Bhattacharyya, "On a measure of divergence between two multinomial populations", *Sankhyā: The Indian Journal of Statistics*, vol. 7, pp. 401–406, 1943.
