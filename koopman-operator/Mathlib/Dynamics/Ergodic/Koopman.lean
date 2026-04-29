/-
Copyright (c) 2026 Kenneth A. Mendoza. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Kenneth A. Mendoza
-/
import Mathlib.MeasureTheory.Function.LpSpace.Indicator
import Mathlib.Dynamics.Ergodic.MeasurePreserving
import Mathlib.Analysis.Normed.Operator.LinearIsometry

/-!
# The Koopman operator on `L²` of a measure-preserving system

This file defines the Koopman operator `U_T : L²(X, μ) → L²(X, μ)` associated
with a measure-preserving transformation `T : X → X` on a measure space
`(X, μ)`, by precomposition: `U_T f := f ∘ T`.

The Koopman operator is the linear lift of a non-linear measure-preserving
transformation to a Hilbert space of observables. Measure preservation makes
`U_T` a linear isometry on `L²`. When `T` is invertible measure-preserving,
`U_T` is unitary, and its spectrum lives on the unit circle. The spectral
properties of `U_T` characterise ergodicity, weak mixing, and strong mixing
of `T` — the Koopman–von Neumann correspondence.

This file is a dynamics-facing API layer over the existing
`MeasureTheory.Lp.compMeasurePreservingₗᵢ`, which provides the underlying
precomposition linear isometry. The contribution here is the named
`Koopman` operator and the standard Koopman API (a.e. action, identity,
contravariant composition, constants, iteration) used by the operator-
theoretic approach to ergodic theory.

## Main definitions

* `MeasureTheory.Koopman T hT` — the Koopman linear isometry on `Lp ℂ 2 μ`
  associated with a measure-preserving transformation `T : X → X`

## Main statements

* `MeasureTheory.Koopman_apply` — `(Koopman T hT f) =ᵐ[μ] f ∘ T`
* `MeasureTheory.Koopman_id` — `Koopman id _ = LinearIsometry.id`
* `MeasureTheory.Koopman_comp` — `Koopman (T ∘ S) _ = Koopman S _ ∘L Koopman T _`
  (note: contravariant — since `U_T f = f ∘ T`, we have `U_{T∘S} = U_S ∘ U_T`)
* `MeasureTheory.Koopman_const` — `Koopman T _ (Lp.const 2 μ 1) = Lp.const 2 μ 1`
* `MeasureTheory.Koopman_iterate` — `Koopman (T^[n]) _ = (Koopman T _) ^ n`

## References

* B. O. Koopman, *Hamiltonian systems and transformation in Hilbert space*,
  Proc. Natl. Acad. Sci. USA 17 (1931), 315–318.
* J. von Neumann, *Proof of the quasi-ergodic hypothesis*,
  Proc. Natl. Acad. Sci. USA 18 (1932), 70–82.
* P. Walters, *An Introduction to Ergodic Theory*, Springer 1982, §1.5.
* M. Einsiedler and T. Ward, *Ergodic Theory*, Springer 2011, §2.1.

## Out of scope for this initial contribution

The unitary version for invertible measure-preserving `T`, the spectrum-on-
the-unit-circle property, ergodicity and mixing characterisations, and the
multiplicativity property (which requires `L^∞` arguments to make pointwise
products well-defined on `L²`) are reserved for follow-up files in this
directory.
-/

namespace MeasureTheory

variable {X : Type*} [MeasurableSpace X] {μ : Measure X}

/-- The Koopman operator on `Lp ℂ 2 μ` associated with a measure-preserving
transformation `T : X → X`. Defined by precomposition `U_T f := f ∘ T`;
measure preservation ensures the action is well-defined on the `L²`
quotient and is a linear isometry. This is a dynamics-facing alias over
`Lp.compMeasurePreservingₗᵢ`. -/
noncomputable def Koopman (T : X → X) (hT : MeasurePreserving T μ μ) :
    Lp ℂ 2 μ →ₗᵢ[ℂ] Lp ℂ 2 μ :=
  Lp.compMeasurePreservingₗᵢ ℂ T hT

/-- The Koopman operator acts a.e. by precomposition with `T`. -/
theorem Koopman_apply (T : X → X) (hT : MeasurePreserving T μ μ)
    (f : Lp ℂ 2 μ) :
    (Koopman T hT f : X → ℂ) =ᵐ[μ] (f : X → ℂ) ∘ T := by
  exact Lp.coeFn_compMeasurePreserving f hT

/-- The Koopman operator of the identity transformation is the identity
isometry. -/
theorem Koopman_id : Koopman (id : X → X) (MeasurePreserving.id μ) =
    (LinearIsometry.id : Lp ℂ 2 μ →ₗᵢ[ℂ] Lp ℂ 2 μ) := by
  ext f
  simpa using Koopman_apply (id : X → X) (MeasurePreserving.id μ) f

/-- The Koopman operator is contravariantly functorial under composition.
Since `U_T f = f ∘ T`, we have `U_{T ∘ S} = U_S ∘ U_T`, not `U_T ∘ U_S`. -/
theorem Koopman_comp (T S : X → X)
    (hT : MeasurePreserving T μ μ) (hS : MeasurePreserving S μ μ) :
    Koopman (T ∘ S) (hT.comp hS) =
      (Koopman S hS).comp (Koopman T hT) :=
by
  ext f
  calc
    (Koopman (T ∘ S) (hT.comp hS) f : X → ℂ)
        =ᵐ[μ] (f : X → ℂ) ∘ (T ∘ S) :=
      Koopman_apply (T ∘ S) (hT.comp hS) f
    _ =ᵐ[μ] ((Koopman T hT f : X → ℂ) ∘ S) :=
      (hS.quasiMeasurePreserving.ae_eq (Koopman_apply T hT f)).symm
    _ =ᵐ[μ] ((Koopman S hS).comp (Koopman T hT) f : X → ℂ) :=
      (Koopman_apply S hS (Koopman T hT f)).symm

/-- Constant functions are fixed by the Koopman operator. This is the entry
point to the Koopman–von Neumann ergodicity criterion (constants are always
in the eigenspace of eigenvalue 1; ergodicity says they are the entire
eigenspace). -/
theorem Koopman_const (T : X → X) (hT : MeasurePreserving T μ μ)
    [IsFiniteMeasure μ] :
    Koopman T hT (Lp.const 2 μ (1 : ℂ)) = Lp.const 2 μ (1 : ℂ) :=
by
  ext
  calc
    (Koopman T hT (Lp.const 2 μ (1 : ℂ)) : X → ℂ)
        =ᵐ[μ] (Lp.const 2 μ (1 : ℂ) : X → ℂ) ∘ T :=
      Koopman_apply T hT (Lp.const 2 μ (1 : ℂ))
    _ =ᵐ[μ] (Function.const X (1 : ℂ)) ∘ T :=
      hT.quasiMeasurePreserving.ae_eq (Lp.coeFn_const (μ := μ) (p := 2) (c := (1 : ℂ)))
    _ =ᵐ[μ] Function.const X (1 : ℂ) := by
      simp
    _ =ᵐ[μ] (Lp.const 2 μ (1 : ℂ) : X → ℂ) :=
      (Lp.coeFn_const (μ := μ) (p := 2) (c := (1 : ℂ))).symm

/-- The Koopman operator of the `n`-th iterate of `T` equals the `n`-th
power of the Koopman operator. Required for any subsequent application of
the mean ergodic theorem (which averages `(Koopman T)^n`). -/
theorem Koopman_iterate (T : X → X) (hT : MeasurePreserving T μ μ) (n : ℕ) :
    Koopman (T^[n]) (hT.iterate n) = (Koopman T hT) ^ n :=
by
  induction n with
  | zero =>
      simpa using (Koopman_id (X := X) (μ := μ))
  | succ n ih =>
      calc
        Koopman (T^[n.succ]) (hT.iterate n.succ)
            = (Koopman T hT).comp (Koopman (T^[n]) (hT.iterate n)) := by
          simpa [Function.iterate_succ] using
            (Koopman_comp (T^[n]) T (hT.iterate n) hT)
        _ = (Koopman T hT).comp ((Koopman T hT) ^ n) := by
          rw [ih]
        _ = (Koopman T hT) ^ n.succ := by
          rw [pow_succ']
          rfl

end MeasureTheory
