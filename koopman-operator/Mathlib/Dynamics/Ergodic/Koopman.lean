/-
Copyright (c) 2026 Kenneth A. Mendoza. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Kenneth A. Mendoza
-/
import Mathlib.MeasureTheory.Function.LpSpace.Basic
import Mathlib.Dynamics.Ergodic.MeasurePreserving
import Mathlib.Analysis.NormedSpace.LinearIsometry
import Mathlib.Analysis.NormedSpace.OperatorNorm.Basic

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

## Main definitions

* `MeasureTheory.Koopman T hT` — the Koopman linear isometry on `Lp ℂ 2 μ`
  associated with a measure-preserving transformation `T : X → X`

## Main statements

* `MeasureTheory.Koopman_apply` — `(Koopman T hT f) =ᵐ[μ] f ∘ T`
* `MeasureTheory.Koopman_id` — `Koopman id _ = LinearIsometry.id`
* `MeasureTheory.Koopman_comp` — `Koopman (T ∘ S) _ = Koopman T _ ∘L Koopman S _`
* `MeasureTheory.Koopman_const` — `Koopman T _ (Lp.const _ _ 1) = Lp.const _ _ 1`
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
quotient and is a linear isometry. -/
noncomputable def Koopman (T : X → X) (_hT : MeasurePreserving T μ μ) :
    Lp ℂ 2 μ →ₗᵢ[ℂ] Lp ℂ 2 μ :=
  sorry

/-- The Koopman operator acts a.e. by precomposition with `T`. -/
theorem Koopman_apply (T : X → X) (hT : MeasurePreserving T μ μ)
    (f : Lp ℂ 2 μ) :
    (Koopman T hT f : X → ℂ) =ᵐ[μ] (f : X → ℂ) ∘ T :=
  sorry

/-- The Koopman operator of the identity transformation is the identity
isometry. -/
theorem Koopman_id : Koopman (id : X → X) (MeasurePreserving.id μ) =
    LinearIsometry.id (𝕜 := ℂ) (E := Lp ℂ 2 μ) :=
  sorry

/-- The Koopman operator of a composition of measure-preserving
transformations is the composition of the Koopman operators. -/
theorem Koopman_comp {Y : Type*} [MeasurableSpace Y] (T : Y → X) (S : X → Y)
    (hT : MeasurePreserving T μ μ) (hS : MeasurePreserving S μ μ) :
    Koopman (T ∘ S) (hT.comp hS) =
      (Koopman T hT).comp (Koopman S hS) :=
  sorry

/-- Constant functions are fixed by the Koopman operator. This is the entry
point to the Koopman–von Neumann ergodicity criterion (constants are always
in the eigenspace of eigenvalue 1; ergodicity says they are the entire
eigenspace). -/
theorem Koopman_const (T : X → X) (hT : MeasurePreserving T μ μ)
    [IsFiniteMeasure μ] :
    Koopman T hT ((Lp.indicatorConstLp 2 MeasurableSet.univ
        (measure_ne_top μ Set.univ) (1 : ℂ))) =
      Lp.indicatorConstLp 2 MeasurableSet.univ
        (measure_ne_top μ Set.univ) (1 : ℂ) :=
  sorry

/-- The Koopman operator of the `n`-th iterate of `T` equals the `n`-th
power of the Koopman operator. Required for any subsequent application of
the mean ergodic theorem (which averages `(Koopman T)^n`). -/
theorem Koopman_iterate (T : X → X) (hT : MeasurePreserving T μ μ) (n : ℕ) :
    Koopman (T^[n]) (hT.iterate n) = (Koopman T hT) ^ n :=
  sorry

end MeasureTheory
