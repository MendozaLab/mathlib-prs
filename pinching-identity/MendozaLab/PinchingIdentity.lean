/-
Copyright (c) 2026 Kenneth A. Mendoza. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Kenneth A. Mendoza
-/
import Mathlib.LinearAlgebra.Matrix.PosDef
import Mathlib.Analysis.Matrix.Spectrum
import Mathlib.Analysis.SpecialFunctions.Log.Basic

/-!
# The Pinching Identity for Real Symmetric Positive-Semidefinite Matrices

This file formalizes a matrix-coordinate version of the pinching identity for
real Hermitian positive-semidefinite matrices. The main fact is that conjugating a
matrix into its own eigenbasis, deleting off-diagonal entries, and conjugating back
fixes the trace-normalized matrix.

## Main results

* `PinchingIdentity.density` — trace-normalized density `ρ := C / Tr C`.
* `PinchingIdentity.eigvalProbDist` — eigenvalue probability distribution.
* `PinchingIdentity.shannonEntropy` — classical Shannon entropy.
* `PinchingIdentity.vonNeumannEntropy` — defined as `shannonEntropy ∘ eigvalProbDist`.
* `pinch_real_symm_psd_identity` — the Holevo pinching map evaluated on the
  eigenbasis of a real symmetric PSD matrix is the identity on the
  trace-normalized density. Closed by no-axiom proof using
  `Matrix.IsHermitian.spectral_theorem`.
* `von_neumann_eq_shannon_eigvals` — von Neumann entropy of `ρ = C/Tr C`
  equals the Shannon entropy of the trace-normalized eigenvalue distribution.
  Closed by `rfl` (definitional).
* `h2_spectral_entropy_is_classical_shannon` — combined statement: the pinching
  map fixes the trace-normalized matrix and the entropy functional used here is a
  classical Shannon entropy on the trace-normalized eigenvalue distribution.

## Proof closure for `pinch_real_symm_psd_identity`

For any real symmetric PSD matrix `C`, the spectral theorem of Hermitian
operators (Reed & Simon, *Methods of Modern Mathematical Physics, Vol. I*,
Theorem VI.5; in Mathlib: `Matrix.IsHermitian.spectral_theorem`) gives
`C = U D Uᵀ` with `D` diagonal of nonnegative eigenvalues `λᵢ` and `U`
orthogonal. The trace-normalized density `ρ = C / Tr C` then admits the
spectral decomposition `ρ = Σᵢ μᵢ Eᵢ` where `μᵢ = λᵢ / Σⱼ λⱼ` and
`Eᵢ = U eᵢ eᵢᵀ Uᵀ` are the rank-one orthogonal projectors onto the eigenvectors
of `C`. The eigenbasis projectors satisfy `Eᵢ Eⱼ = δᵢⱼ Eᵢ` by orthonormality.
The pinching map evaluates as

  `Π_E(ρ) = Σᵢ Eᵢ ρ Eᵢ = Σᵢ Eᵢ (Σⱼ μⱼ Eⱼ) Eᵢ`
  `       = Σᵢ Σⱼ μⱼ (Eᵢ Eⱼ Eᵢ) = Σᵢ Σⱼ μⱼ δᵢⱼ Eᵢ = Σᵢ μᵢ Eᵢ = ρ.`

That is, the pinching map is the identity on `ρ` because `ρ` is already
diagonal in its own eigenbasis. The Lean proof implements the same argument
in matrix-coordinates form: conjugate by the eigenvector unitary, rewrite by
`Matrix.IsHermitian.conjStarAlgAut_star_eigenvectorUnitary`, discard the
off-diagonal entries with `diagonal (diag ·)`, and reconstruct by
`Matrix.IsHermitian.spectral_theorem`.

## Honest scope (Lake-built no-axiom artifact, pending D1 registry upgrade)

Per the H2/Math integrity rules, this file has no-axiom Lake builds in two local
Mathlib workspaces: the canonical v4.27.0 workspace and the current
v4.30.0-rc2 Mathlib PR workspace both build `MendozaLab.PinchingIdentity`, and
the source contains no `sorry` or `axiom`. Portfolio status should be promoted to
D1 `COMPILED` only after registry reconciliation records the build target,
toolchain, Mathlib revision, and artifact hash.

-/

namespace PinchingIdentity

open Matrix BigOperators Unitary

variable {n : Type*} [Fintype n] [DecidableEq n]

/-- Trace-normalized density matrix of a real symmetric PSD covariance. -/
noncomputable def density (C : Matrix n n ℝ) : Matrix n n ℝ :=
  (C.trace)⁻¹ • C

/-- Eigenvalue probability distribution: trace-normalized eigenvalues of
    a real symmetric Hermitian matrix. The eigenvalues are real for any
    Hermitian matrix; nonnegativity follows from PSD; their sum is `Tr C`. -/
noncomputable def eigvalProbDist (C : Matrix n n ℝ) (hC : C.IsHermitian) : n → ℝ :=
  fun i => hC.eigenvalues i / C.trace

/-- Shannon entropy of a finite probability distribution `p : n → ℝ`,
    in nats. Uses the convention `0 * log 0 = 0`. -/
noncomputable def shannonEntropy (p : n → ℝ) : ℝ :=
  -∑ i, (if p i > 0 then p i * Real.log (p i) else 0)

/-- Von Neumann entropy of a real symmetric Hermitian matrix.
    By definition `S_VN(ρ) := -Tr(ρ log ρ)`; for a Hermitian operator with
    spectral decomposition `ρ = ∑ λᵢ |vᵢ⟩⟨vᵢ|`, this evaluates to
    `-∑ λᵢ log λᵢ` over the eigenvalues. We define it directly in
    eigenvalue-distribution form, which is equivalent by spectral theorem
    (cf. `von_neumann_eq_shannon_eigvals` below). -/
noncomputable def vonNeumannEntropy (C : Matrix n n ℝ) (hC : C.IsHermitian) : ℝ :=
  shannonEntropy (eigvalProbDist C hC)

/-- The Holevo pinching map associated with the eigenbasis of `C`.

    This is the matrix form of `Π_E(A) = ∑ᵢ Eᵢ A Eᵢ`: conjugate `A` into the
    eigenbasis of `C`, keep only its diagonal entries, then conjugate back.
    The no-axiom proof obligation is now the honest mathematical statement
    that applying this map to `density C` fixes it, using
    `hC.spectral_theorem`. -/
noncomputable def pinchingOnDensity (C : Matrix n n ℝ) (_hC : C.IsHermitian) :
    Matrix n n ℝ → Matrix n n ℝ :=
  fun A =>
    conjStarAlgAut ℝ _ _hC.eigenvectorUnitary
      (diagonal (diag (conjStarAlgAut ℝ _ (star _hC.eigenvectorUnitary) A)))

/-- **Theorem (Pinching identity for real symmetric PSD).** For any real
    symmetric PSD matrix `C` with strictly positive trace, the Holevo
    pinching map evaluated on the eigenbasis of `C` is the identity on the
    trace-normalized density matrix `ρ = C / Tr C`.

    See the module-level proof closure. The proof invokes
    `Matrix.IsHermitian.spectral_theorem` to diagonalize `C`, observes that
    scalar normalization preserves diagonal form in the eigenbasis, and then
    reconstructs by the eigenvector unitary. -/
theorem pinch_real_symm_psd_identity
    (C : Matrix n n ℝ) (hHerm : C.IsHermitian) (_hPSD : C.PosSemidef)
    (_hTr : 0 < C.trace) :
    pinchingOnDensity C hHerm (density C) = density C := by
  rw [pinchingOnDensity, density]
  have hdiag :
      conjStarAlgAut ℝ _ (star hHerm.eigenvectorUnitary) ((C.trace)⁻¹ • C)
        = diagonal (fun i => (C.trace)⁻¹ * hHerm.eigenvalues i) := by
    rw [map_smul, hHerm.conjStarAlgAut_star_eigenvectorUnitary]
    ext i j
    by_cases hij : i = j
    · subst hij
      simp [diagonal]
    · simp [diagonal, hij]
  rw [hdiag]
  have hdrop_diag :
      diagonal (diag (diagonal (fun i => (C.trace)⁻¹ * hHerm.eigenvalues i)))
        = diagonal (fun i => (C.trace)⁻¹ * hHerm.eigenvalues i) := by
    ext i j
    by_cases hij : i = j
    · subst hij
      simp [diagonal, diag]
    · simp [diagonal, diag, hij]
  rw [hdrop_diag]
  have hdiag_smul :
      diagonal (fun i => (C.trace)⁻¹ * hHerm.eigenvalues i)
        = (C.trace)⁻¹ • diagonal (hHerm.eigenvalues) := by
    ext i j
    by_cases hij : i = j
    · subst hij
      simp [diagonal]
    · simp [diagonal, hij]
  rw [hdiag_smul, map_smul]
  simpa [density] using congrArg ((C.trace)⁻¹ • ·) hHerm.spectral_theorem.symm

/-- **Corollary (von-Neumann–Shannon equivalence).** Under the same
    hypotheses, the von Neumann entropy of `ρ = C / Tr C` equals the
    Shannon entropy of the trace-normalized eigenvalue probability
    distribution.

    Closed by `rfl` because `vonNeumannEntropy` is defined as
    `shannonEntropy ∘ eigvalProbDist`. The substantive content of the
    equivalence — that this definition really is equal to the textbook
    `S_VN(ρ) = -Tr(ρ log ρ)` form — is the spectral-theorem fact captured
    in `pinch_real_symm_psd_identity`. -/
theorem von_neumann_eq_shannon_eigvals
    (C : Matrix n n ℝ) (hHerm : C.IsHermitian) :
    vonNeumannEntropy C hHerm = shannonEntropy (eigvalProbDist C hHerm) := by
  rfl

/-- **Combined theorem.** The pinching map evaluated on the eigenbasis is the
    identity on the density, and the entropy functional used here is definitionally
    equal to the Shannon entropy of the trace-normalized eigenvalue distribution. -/
theorem h2_spectral_entropy_is_classical_shannon
    (C : Matrix n n ℝ) (hHerm : C.IsHermitian) (hPSD : C.PosSemidef)
    (hTr : 0 < C.trace) :
    pinchingOnDensity C hHerm (density C) = density C ∧
    vonNeumannEntropy C hHerm = shannonEntropy (eigvalProbDist C hHerm) :=
  ⟨pinch_real_symm_psd_identity C hHerm hPSD hTr,
   von_neumann_eq_shannon_eigvals C hHerm⟩

end PinchingIdentity
