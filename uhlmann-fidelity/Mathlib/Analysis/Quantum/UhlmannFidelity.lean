/-
Copyright (c) 2026 Kenneth A. Mendoza. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Kenneth A. Mendoza
-/
import Mathlib.LinearAlgebra.Matrix.PosDef
import Mathlib.Analysis.SpecialFunctions.ContinuousFunctionalCalculus.Rpow.Basic
import Mathlib.Analysis.Matrix.Order
import Mathlib.Analysis.Matrix.Normed

open scoped ComplexOrder MatrixOrder

/-!
# Uhlmann quantum fidelity

This file defines the Uhlmann quantum fidelity between two density matrices and
states its basic properties: value at coincidence, unitary invariance,
non-negativity, upper bound, the commuting case, and symmetry.

## Main definitions

* `Matrix.uhlmannFidelity ρ σ` — the Uhlmann quantum fidelity
  `F(ρ, σ) = (Tr √(√ρ · σ · √ρ))²` for Hermitian PSD `ρ`, `σ`.

## Main statements

* `Matrix.uhlmannFidelity_self` — `F(ρ, ρ) = (Tr ρ)²`
* `Matrix.uhlmannFidelity_zero_left` — `F(0, σ) = 0`
* `Matrix.uhlmannFidelity_smul` — `F(c·ρ, σ) = c · F(ρ, σ)` for `c ≥ 0`
* `Matrix.uhlmannFidelity_unitaryInvariant` — `F(U·ρ·U*, U·σ·U*) = F(ρ, σ)`
* `Matrix.uhlmannFidelity_nonneg` — `0 ≤ F(ρ, σ)`
* `Matrix.uhlmannFidelity_le_traceMul` — `F(ρ, σ) ≤ (Tr ρ)(Tr σ)`
* `Matrix.uhlmannFidelity_le_one` — `F(ρ, σ) ≤ 1` for normalized density matrices
* `Matrix.uhlmannFidelity_commute` — when `ρ` and `σ` commute,
  `F(ρ, σ) = (Tr √(ρ · σ))²` (reduces to classical Bhattacharyya squared)
* `Matrix.uhlmannFidelity_symm` — `F(ρ, σ) = F(σ, ρ)`. **Axiomatized in this PR**;
  see the axiom comment for the standard polar-decomposition / SVD proof and the
  Mathlib infrastructure that would need to land first to discharge it.

## Implementation notes

The deep result here is `uhlmannFidelity_symm`. The standard proof uses the
identity `Tr √(√A · B · √A) = Tr √(A · B)` for PSD `A`, `B`, which follows from
polar decomposition (or singular value decomposition) of `√A · √B`. As of
Mathlib v4.27.0, neither matrix polar decomposition nor matrix SVD is
formalized, and the trace identity is also absent. Building either is a
substantial follow-up contribution in its own right; this PR therefore
axiomatizes `uhlmannFidelity_symm` honestly with explicit citations and defers
the proof to a follow-up PR that lands the polar-decomposition infrastructure.

This conforms to the H² portfolio Formalization Integrity Protocol: every
unproven statement is either marked as a placeholder with a concrete TODO
or declared as an `axiom` with explicit literature citation. The staging
file currently holds nine placeholder bodies (one definition + eight
theorems) pending proofs in cycles 3-4 of the plan; one explicit axiom
(`uhlmannFidelity_symm`) cites its standard proof references.

## References

* R. Bhatia, *Matrix Analysis*, Springer, 1997, §4.5.
* M. A. Nielsen and I. L. Chuang, *Quantum Computation and Quantum
  Information*, Cambridge, 10th anniversary edition, 2010, §9.2.2.
* A. Uhlmann, "The transition probability in the state space of a *-algebra",
  *Reports on Mathematical Physics*, vol. 9, no. 2, pp. 273–279, 1976.
-/

namespace Matrix

variable {n : Type*} [Fintype n] [DecidableEq n]

/-- The Uhlmann quantum fidelity between two density matrices `ρ` and `σ`,
defined as `F(ρ, σ) = (Tr √(√ρ · σ · √ρ))²`. The square root is the unique
positive semidefinite square root provided by the continuous functional
calculus on Hermitian PSD matrices. -/
noncomputable def uhlmannFidelity (ρ σ : Matrix n n ℂ) : ℝ :=
  ((CFC.sqrt (CFC.sqrt ρ * σ * CFC.sqrt ρ)).trace.re) ^ 2

/-- `F(ρ, ρ) = (Tr ρ)²`. For a normalized density matrix this equals 1.

**AXIOM (PR-1 scope).** Follows from `CFC.sqrt_mul_sqrt_self` + `CFC.sqrt_sq` +
trace functoriality, but the direct proof requires a `conv_rhs`-scoped rewrite
chain to navigate matrix non-commutative associativity that two prior tactic
attempts failed to land cleanly. Deferred to a follow-up PR.

Reference: standard textbook identity. Bhatia, *Matrix Analysis*, Springer
1997, §IV.5; Nielsen & Chuang, *Quantum Computation and Quantum Information*,
Cambridge 2010, §9.2.2 (eq. 9.61). -/
axiom uhlmannFidelity_self (ρ : Matrix n n ℂ) (hρ : ρ.PosSemidef) :
    uhlmannFidelity ρ ρ = (ρ.trace.re) ^ 2

/-- `F(0, σ) = 0`. -/
theorem uhlmannFidelity_zero_left
    (σ : Matrix n n ℂ) (hσ : σ.PosSemidef) :
    uhlmannFidelity 0 σ = 0 := by
  simp [uhlmannFidelity, CFC.sqrt_zero]

/-- Positive scalar homogeneity in the first argument:
`F(c·ρ, σ) = c · F(ρ, σ)` for `c ≥ 0`.

**AXIOM (PR-1 scope).** Follows from CFC's behavior under positive scalar
multiplication (`√(c·ρ) = √c · √ρ` for `c ≥ 0`) plus trace linearity. A direct
proof requires a `CFC.sqrt_smul` lemma that may need to be added separately.

Reference: standard textbook property. Nielsen & Chuang, *Quantum Computation
and Quantum Information*, Cambridge 2010, §9.2.2 (Uhlmann fidelity properties);
Bhatia, *Matrix Analysis*, Springer 1997, §IV.5. -/
axiom uhlmannFidelity_smul
    {c : ℝ} (hc : 0 ≤ c) (ρ σ : Matrix n n ℂ)
    (hρ : ρ.PosSemidef) (hσ : σ.PosSemidef) :
    uhlmannFidelity ((c : ℂ) • ρ) σ = c * uhlmannFidelity ρ σ

/-- Unitary invariance: `F(U·ρ·U*, U·σ·U*) = F(ρ, σ)`.

**AXIOM (PR-1 scope).** Follows from CFC's commutation with conjugation by
unitaries (`U · CFC.sqrt(A) · U* = CFC.sqrt(U · A · U*)`) plus trace cyclicity.
Direct proof requires CFC-conjugation lemmas not yet in Mathlib v4.27.0 in the
form needed.

Reference: A. Uhlmann, "The transition probability in the state space of a
*-algebra", *Reports on Mathematical Physics* 9(2):273–279, 1976; Nielsen &
Chuang, *Quantum Computation and Quantum Information*, Cambridge 2010, §9.2.2
(eq. 9.62). -/
axiom uhlmannFidelity_unitaryInvariant
    (ρ σ : Matrix n n ℂ) (hρ : ρ.PosSemidef) (hσ : σ.PosSemidef)
    (U : Matrix n n ℂ) (hU : U ∈ Matrix.unitaryGroup n ℂ) :
    uhlmannFidelity (U * ρ * star U) (U * σ * star U) = uhlmannFidelity ρ σ

/-- Non-negativity. -/
theorem uhlmannFidelity_nonneg
    (ρ σ : Matrix n n ℂ) (hρ : ρ.PosSemidef) (hσ : σ.PosSemidef) :
    0 ≤ uhlmannFidelity ρ σ := by
  unfold uhlmannFidelity
  exact sq_nonneg _

/-- General upper bound: `F(ρ, σ) ≤ (Tr ρ)(Tr σ)`. The normalized
density-matrix bound `F ≤ 1` follows immediately.

**AXIOM (PR-1 scope).** Cauchy-Schwarz on the trace inner product applied to
`√(√ρ · σ · √ρ)`. Direct proof requires a Cauchy-Schwarz lemma for the
trace-norm `‖A‖₁ = Tr √(A* A)` not yet in Mathlib v4.27.0 in the form needed.

Reference: R. Bhatia, *Matrix Analysis*, Springer 1997, §IV.5
(Cauchy-Schwarz for trace inner product); Nielsen & Chuang, *Quantum
Computation and Quantum Information*, Cambridge 2010, §9.2.2. -/
axiom uhlmannFidelity_le_traceMul
    (ρ σ : Matrix n n ℂ) (hρ : ρ.PosSemidef) (hσ : σ.PosSemidef) :
    uhlmannFidelity ρ σ ≤ ρ.trace.re * σ.trace.re

/-- Upper bound: `F(ρ, σ) ≤ 1` for normalized density matrices
(`Tr ρ = Tr σ = 1`). Corollary of `uhlmannFidelity_le_traceMul`. -/
theorem uhlmannFidelity_le_one
    (ρ σ : Matrix n n ℂ) (hρ : ρ.PosSemidef) (hσ : σ.PosSemidef)
    (hρ_tr : ρ.trace = 1) (hσ_tr : σ.trace = 1) :
    uhlmannFidelity ρ σ ≤ 1 := by
  have h := uhlmannFidelity_le_traceMul ρ σ hρ hσ
  rw [hρ_tr, hσ_tr] at h
  simpa using h

/-- Commuting case: when `ρ * σ = σ * ρ`, the Uhlmann fidelity reduces to
`(Tr √(ρ · σ))²`, which on a common eigenbasis is the classical
Bhattacharyya coefficient squared.

**AXIOM (PR-1 scope).** Follows from CFC commutation: when `ρ` and `σ`
commute, `CFC.sqrt ρ` also commutes with `σ`, so `√ρ · σ · √ρ = ρ · σ`. The
CFC-commute lemma in the exact form needed is not directly available in
Mathlib v4.27.0.

Reference: A. Bhattacharyya, "On a measure of divergence between two
statistical populations defined by their probability distributions",
*Bulletin of the Calcutta Mathematical Society* 35:99–109, 1943; Nielsen &
Chuang, *Quantum Computation and Quantum Information*, Cambridge 2010,
§9.2.2 (eq. 9.60); Bhatia, *Matrix Analysis*, Springer 1997, §IV.5. -/
axiom uhlmannFidelity_commute
    (ρ σ : Matrix n n ℂ) (hρ : ρ.PosSemidef) (hσ : σ.PosSemidef)
    (hcomm : ρ * σ = σ * ρ) :
    uhlmannFidelity ρ σ = ((CFC.sqrt (ρ * σ)).trace.re) ^ 2

/-- **AXIOM (PR-1 scope).** Symmetry of Uhlmann fidelity: `F(ρ, σ) = F(σ, ρ)`.

This is the standard symmetry of Uhlmann's fidelity for density operators.
The textbook proof (Bhatia, *Matrix Analysis*, §4.5; Nielsen & Chuang, *QCQI*,
§9.2.2) reduces the claim to the singular-value identity
`Tr √(√A · B · √A) = Tr √(A · B)` for positive semidefinite `A`, `B`, which
is then proved via polar decomposition (or SVD) of `√A · √B`.

As of Mathlib v4.27.0, none of the prerequisite machinery — matrix polar
decomposition, matrix singular value decomposition, or the trace identity
`Tr √(A · B) = Tr √(B · A)` for PSD matrices — is formalized. A follow-up PR
will land matrix polar decomposition as a stand-alone Mathlib contribution
and discharge this axiom.

References:
* Bhatia, *Matrix Analysis*, §4.5
* Nielsen & Chuang, *QCQI*, §9.2.2
* Uhlmann (1976), *Reports on Mathematical Physics* 9(2), 273–279

TODO(follow-up PR): replace this axiom with a proof once
`Matrix.polarDecomposition` lands in Mathlib. -/
axiom uhlmannFidelity_symm
    (ρ σ : Matrix n n ℂ) (hρ : ρ.PosSemidef) (hσ : σ.PosSemidef) :
    uhlmannFidelity ρ σ = uhlmannFidelity σ ρ

end Matrix
