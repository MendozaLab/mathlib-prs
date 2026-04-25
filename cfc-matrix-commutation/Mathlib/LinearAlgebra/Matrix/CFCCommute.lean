/-
Copyright (c) 2026 Kenneth A. Mendoza. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Kenneth A. Mendoza
-/
import Mathlib.LinearAlgebra.Matrix.PosDef
import Mathlib.Analysis.SpecialFunctions.ContinuousFunctionalCalculus.Rpow.Basic
import Mathlib.Analysis.Matrix.Order
import Mathlib.Analysis.Matrix.Normed
import Mathlib.Analysis.CStarAlgebra.ContinuousFunctionalCalculus.Commute

open scoped ComplexOrder MatrixOrder

/-!
# Matrix-level commutation lemmas for the continuous functional calculus

This file provides matrix-specific corollaries of the general continuous
functional calculus commutation theorems
`Commute.cfc` and `IsSelfAdjoint.commute_cfcHom` from
`Mathlib.Analysis.CStarAlgebra.ContinuousFunctionalCalculus.Commute`.

The general theorems state that if `b` commutes with `a` (and with `star a`,
or trivially if `a` is self-adjoint), then `b` commutes with `cfc f a` for
any continuous `f`. This file specializes the self-adjoint version to
positive semidefinite matrices over `ℂ`, which automatically satisfy the
self-adjointness hypothesis (`PosSemidef.isHermitian` gives `star ρ = ρ`).

## Main results

* `Matrix.PosSemidef.commute_sqrt` — if `b` commutes with a positive
  semidefinite matrix `ρ`, then `b` commutes with `CFC.sqrt ρ`.
* `Matrix.PosSemidef.sqrt_mul_eq_of_commute` — under the same commutation
  hypothesis, `CFC.sqrt ρ * b = b * CFC.sqrt ρ` (the equation form).

## References

* Mathlib continuous functional calculus framework, in particular
  `Mathlib/Analysis/CStarAlgebra/ContinuousFunctionalCalculus/Commute.lean`
  by Jireh Loreaux (2025).
* R. Bhatia, *Matrix Analysis*, Springer 1997, §V.1 (functional calculus
  on Hermitian matrices).
-/

namespace Matrix

variable {n : Type*} [Fintype n] [DecidableEq n]

/-- If a matrix `b` commutes with a positive semidefinite matrix `ρ`, then
`b` commutes with the continuous-functional-calculus square root `CFC.sqrt ρ`.

Proof strategy: rewrite `CFC.sqrt ρ` as `cfc NNReal.sqrt ρ` via
`CFC.sqrt_eq_cfc`, then apply `Commute.cfc`; the second `Commute (star ρ) b`
hypothesis follows from `PosSemidef.isHermitian` giving `star ρ = ρ`. -/
theorem PosSemidef.commute_sqrt
    {ρ b : Matrix n n ℂ} (_hρ : ρ.PosSemidef) (hcomm : Commute ρ b) :
    Commute (CFC.sqrt ρ) b := by
  rw [CFC.sqrt_eq_cfc]
  exact hcomm.cfc_nnreal NNReal.sqrt

/-- Equation form of `PosSemidef.commute_sqrt`: `CFC.sqrt ρ * b = b * CFC.sqrt ρ`
when `b` commutes with the positive-semidefinite matrix `ρ`.

Direct corollary: `Commute ρ b` definitionally unfolds to `ρ * b = b * ρ`,
and `Commute (CFC.sqrt ρ) b` definitionally unfolds to the goal. -/
theorem PosSemidef.sqrt_mul_eq_of_commute
    {ρ b : Matrix n n ℂ} (hρ : ρ.PosSemidef) (hcomm : ρ * b = b * ρ) :
    CFC.sqrt ρ * b = b * CFC.sqrt ρ :=
  PosSemidef.commute_sqrt hρ hcomm

end Matrix
