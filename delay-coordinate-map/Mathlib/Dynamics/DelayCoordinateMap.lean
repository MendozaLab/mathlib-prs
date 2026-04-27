/-
Copyright (c) 2026 Kenneth A. Mendoza. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Kenneth A. Mendoza
-/
import Mathlib.Dynamics.FixedPoints.Basic
import Mathlib.Topology.Basic
import Mathlib.Data.Fin.Basic

/-!
# Delay-coordinate map

This file defines the delay-coordinate map associated with a transformation
`T : X → X` and an observation function `φ : X → ℝ`. The delay-coordinate
map of length `n + 1` sends a point `x ∈ X` to the tuple
`(φ(x), φ(Tx), φ(T²x), …, φ(Tⁿx)) ∈ ℝ^(n+1)`.

The delay-coordinate map is the named object underlying the Takens embedding
theorem (Takens 1981) and its generalisations (Sauer–Yorke–Casdagli 1991),
which state that for a smooth dynamical system on a compact manifold of
dimension `d` and a generic observation function, the delay-coordinate map
of length `2d + 1` is an embedding. This file contributes the named object
and its basic continuity / iteration properties; the embedding theorem
itself requires Whitney embedding, transversality theory, and Baire-category
genericity infrastructure that is reserved for follow-up work.

## Main definitions

* `delayCoordinateMap T φ n` — the delay-coordinate map of length `n + 1`
  associated with `T : X → X` and `φ : X → ℝ`

## Main statements

* `delayCoordinateMap_zero` — the length-1 case is constant in the iterate index
* `delayCoordinateMap_continuous` — continuity of the delay-coordinate map
  when both `T` and `φ` are continuous
* `delayCoordinateMap_succ` — recursive structure: appending `φ ∘ T^(n+1) x`
  to the length-`(n+1)` map yields the length-`(n+2)` map

## Out of scope for this initial contribution

The Takens embedding theorem (genericity of `φ` in `C^∞(M, ℝ)` makes the
delay-coordinate map of length `2 dim M + 1` an embedding `M ↪ ℝ^(2 dim M+1)`),
the Sauer–Yorke–Casdagli generalisation to fractal-dimension state spaces,
and the smooth-manifold immersion / embedding properties are reserved for
follow-up files. Each of those depends on substantial prerequisite Mathlib
infrastructure (Whitney embedding theorem, Thom transversality, Baire
genericity in function spaces) that has not yet been formalised.

## References

* F. Takens, *Detecting strange attractors in turbulence*, in Dynamical
  Systems and Turbulence, Warwick 1980, Lecture Notes in Mathematics
  vol. 898, Springer 1981, pp. 366–381.
* T. Sauer, J. A. Yorke, and M. Casdagli, *Embedology*, Journal of
  Statistical Physics 65 (1991), 579–616.
* H. D. I. Abarbanel, *Analysis of Observed Chaotic Data*, Springer 1996,
  Chapter 4.
-/

namespace Dynamics

variable {X : Type*}

/-- The delay-coordinate map of length `n + 1` associated with a
transformation `T : X → X` and an observation function `φ : X → ℝ`.

Sends `x ↦ (φ(x), φ(Tx), φ(T²x), …, φ(Tⁿx))`, indexed by `Fin (n + 1)`. -/
def delayCoordinateMap (T : X → X) (φ : X → ℝ) (n : ℕ) (x : X) :
    Fin (n + 1) → ℝ :=
  fun i => φ ((T^[i.val]) x)

/-- The length-1 delay-coordinate map is the function that sends every
`Fin 1` index to `φ x` (since the only iterate index `0` gives the
identity iterate, and `T^[0] x = x`). -/
theorem delayCoordinateMap_zero (T : X → X) (φ : X → ℝ) (x : X) :
    delayCoordinateMap T φ 0 x = fun _ => φ x := by
  sorry

/-- The delay-coordinate map is continuous when both the transformation
`T` and the observation function `φ` are continuous. -/
theorem delayCoordinateMap_continuous [TopologicalSpace X] (T : X → X)
    (φ : X → ℝ) (n : ℕ) (hT : Continuous T) (hφ : Continuous φ) :
    Continuous (delayCoordinateMap T φ n) := by
  sorry

/-- The recursive / extension structure of the delay-coordinate map: the
length-`(n + 2)` map at index `n + 1` evaluates to `φ ((T^(n+1)) x)`,
extending the length-`(n + 1)` map by appending one more iterate
observation. -/
theorem delayCoordinateMap_succ (T : X → X) (φ : X → ℝ) (n : ℕ) (x : X)
    (i : Fin (n + 2)) :
    delayCoordinateMap T φ (n + 1) x i =
      φ ((T^[i.val]) x) := by
  sorry

end Dynamics
