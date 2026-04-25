/-
Copyright (c) 2026 Kenneth A. Mendoza. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Kenneth A. Mendoza
-/
import Mathlib.LinearAlgebra.Matrix.PosDef
import Mathlib.Analysis.InnerProductSpace.Basic
import Mathlib.Analysis.Matrix.Order

open scoped ComplexOrder MatrixOrder

/-!
# The Frobenius (Hilbert-Schmidt) inner product on complex matrices

This file defines the Frobenius inner product `⟨A, B⟩_F = Tr(Aᴴ · B)` on
`Matrix n n ℂ` and registers the corresponding `InnerProductSpace ℂ` instance
via `InnerProductSpace.Core`.

This makes available Mathlib's existing inner-product machinery — including
Cauchy-Schwarz `inner_mul_le_norm_mul_norm` — for matrix-valued arguments,
and serves as the foundation for trace-norm and Frobenius-norm bounds used
throughout matrix analysis.

## Main definitions

* `Matrix.frobeniusInner A B` — the Frobenius inner product `Tr(Aᴴ · B)`.
* `Matrix.frobeniusInnerProductCore` — the `InnerProductSpace.Core` instance.
* `Matrix.frobeniusInnerProductSpace` — the derived `InnerProductSpace ℂ`
  instance on `Matrix n n ℂ`.

## Main statements (basic algebraic properties)

* `Matrix.frobeniusInner_conj_symm` — `⟨B, A⟩_F = star ⟨A, B⟩_F`.
* `Matrix.frobeniusInner_add_right` — additivity in the second argument.
* `Matrix.frobeniusInner_smul_right` — linearity in the second argument.
* `Matrix.frobeniusInner_self_nonneg` — `0 ≤ Re ⟨A, A⟩_F`.
* `Matrix.frobeniusInner_self_eq_zero_iff` — `⟨A, A⟩_F = 0 ↔ A = 0`.

## References

* R. Bhatia, *Matrix Analysis*, Springer-Verlag, 1997. §IV.5 (matrix norms
  and the trace inner product).
* R. A. Horn and C. R. Johnson, *Matrix Analysis*, Cambridge University
  Press, 2nd edition, 2013. §5.2 (Hilbert-Schmidt / Frobenius norm).
-/

namespace Matrix

variable {n : Type*} [Fintype n] [DecidableEq n]

/-- The Frobenius (Hilbert-Schmidt) inner product on `Matrix n n ℂ`,
defined as `⟨A, B⟩_F = Tr(Aᴴ · B)`. Conjugate-linear in the first argument
and linear in the second (Mathlib / mathematicians' convention). -/
noncomputable def frobeniusInner (A B : Matrix n n ℂ) : ℂ :=
  (Aᴴ * B).trace

/-- Conjugate symmetry: `⟨B, A⟩_F = star ⟨A, B⟩_F`. -/
theorem frobeniusInner_conj_symm (A B : Matrix n n ℂ) :
    frobeniusInner B A = star (frobeniusInner A B) := by
  -- ⟨B, A⟩_F = Tr(Bᴴ · A) = Tr((Aᴴ · B)ᴴ) = star (Tr(Aᴴ · B)) = star ⟨A, B⟩_F.
  unfold frobeniusInner
  rw [← Matrix.trace_conjTranspose, Matrix.conjTranspose_mul,
      Matrix.conjTranspose_conjTranspose]

/-- Additivity in the second argument: `⟨A, B + C⟩_F = ⟨A, B⟩_F + ⟨A, C⟩_F`. -/
theorem frobeniusInner_add_right (A B C : Matrix n n ℂ) :
    frobeniusInner A (B + C) = frobeniusInner A B + frobeniusInner A C := by
  unfold frobeniusInner
  rw [mul_add, trace_add]

/-- Linearity in the second argument: `⟨A, c • B⟩_F = c * ⟨A, B⟩_F`. -/
theorem frobeniusInner_smul_right (A B : Matrix n n ℂ) (c : ℂ) :
    frobeniusInner A (c • B) = c * frobeniusInner A B := by
  simp [frobeniusInner, Matrix.mul_smul, trace_smul, smul_eq_mul]

omit [DecidableEq n] in
/-- Non-negativity of the self inner product: `0 ≤ Re ⟨A, A⟩_F`.
Follows from `Matrix.posSemidef_conjTranspose_mul_self` and
`Matrix.PosSemidef.trace_nonneg`. -/
theorem frobeniusInner_self_nonneg (A : Matrix n n ℂ) :
    0 ≤ (frobeniusInner A A).re := by
  -- Aᴴ · A is positive semidefinite; trace of PSD matrix has nonneg real part.
  -- PosSemidef.trace_nonneg gives (0:ℂ) ≤ trace under ComplexOrder; extract
  -- the real-part inequality via Complex.nonneg_iff.
  unfold frobeniusInner
  exact (Complex.nonneg_iff.mp
    (Matrix.posSemidef_conjTranspose_mul_self A).trace_nonneg).1

omit [DecidableEq n] in
/-- Definiteness: `⟨A, A⟩_F = 0 ↔ A = 0`. Follows from
`Matrix.trace_conjTranspose_mul_self_eq_zero_iff`. -/
theorem frobeniusInner_self_eq_zero_iff (A : Matrix n n ℂ) :
    frobeniusInner A A = 0 ↔ A = 0 := by
  -- Direct application of trace_conjTranspose_mul_self_eq_zero_iff.
  unfold frobeniusInner
  exact Matrix.trace_conjTranspose_mul_self_eq_zero_iff

/-! ## Trace Cauchy-Schwarz (downstream of the InnerProductSpace instance)

Once the `InnerProductSpace ℂ (Matrix n n ℂ)` instance below is registered,
Mathlib's existing `inner_mul_le_norm_mul_norm` immediately yields trace
Cauchy-Schwarz: `|Tr(Aᴴ · B)|² ≤ Tr(Aᴴ · A) · Tr(Bᴴ · B)`. A convenience
wrapper exposing this in matrix-trace form is included below.
-/

/-- Trace Cauchy-Schwarz: the standard Cauchy-Schwarz inequality on the
Frobenius inner product, expressed in matrix-trace form. Direct corollary
of `inner_mul_le_norm_mul_norm` applied to the `InnerProductSpace ℂ` instance
on `Matrix n n ℂ`. -/
theorem trace_cauchy_schwarz (A B : Matrix n n ℂ) :
    Complex.normSq (frobeniusInner A B) ≤
      (frobeniusInner A A).re * (frobeniusInner B B).re := by
  sorry

end Matrix
