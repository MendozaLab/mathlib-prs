/-
Copyright (c) 2026 Kenneth A. Mendoza. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Kenneth A. Mendoza
-/
import Mathlib.Analysis.Complex.Basic
import Mathlib.Analysis.SpecialFunctions.Gamma.Basic
import Mathlib.MeasureTheory.Integral.IntervalIntegral.Basic

/-!
# Radial lemniscates for `z^n - a`

This local seed file records Mathlib candidate statements around the radial
lemniscate family `p_a(z) = z^n - a`.

This file is not an upstream PR. It intentionally contains statement stubs while
the exact Mathlib APIs for arc length, rectifiable parameterized curves,
improper interval integrals, and singular branch points are inspected.

## Main intended statements

* `radialLemniscateParam` -- parameterization by `z^n = a + exp(i t)`.
* `radialLemniscateLengthIntegral` -- length integral
  `integral |a + exp(i t)|^(1/n - 1) dt`.
* `radialLemniscateLength_one_beta` -- beta/gamma value for `a = 1`.

## Not in scope

This file does not state the EHP114 conjecture and does not claim any
maximality theorem.
-/

noncomputable section

open Complex Real MeasureTheory intervalIntegral

namespace EHPRadialLemniscate

/-- The radial lemniscate polynomial `p_a(z) = z^n - a`. -/
def radialPoly (n : ℕ) (a : ℝ) (z : ℂ) : ℂ :=
  z ^ n - (a : ℂ)

/-- The base circle in the `w`-plane used to parameterize
`|z^n - a| = 1`: `w(t) = a + exp(i t)`. -/
def radialBaseCircle (a : ℝ) (t : ℝ) : ℂ :=
  (a : ℂ) + Complex.exp (Complex.I * (t : ℂ))

/--
Formal seed: if `z^n = a + exp(i t)`, then `z` lies on the lemniscate
`|z^n - a| = 1`.

This is the first small upstreamable algebraic lemma; it avoids arc-length
infrastructure.
-/
theorem norm_radialPoly_eq_one_of_pow_eq_baseCircle {n : ℕ} {a t : ℝ} {z : ℂ}
    (hz : z ^ n = radialBaseCircle a t) :
    Complex.normSq (radialPoly n a z) = 1 := by
  -- This should close from `hz`, `radialPoly`, `radialBaseCircle`, and
  -- `Complex.normSq_exp`.
  sorry

/--
Formal seed for the derivative magnitude of a local branch of `z^n =
a + exp(i t)`.

The intended analytic statement is that on a smooth local branch

```text
|dz/dt| = (1/n) * |a + exp(i t)|^(1/n - 1).
```

The exact Lean statement is intentionally deferred until branch/arc-length APIs
are selected.
-/
theorem localBranch_deriv_norm_seed :
    True := by
  trivial

/--
Formal seed for the radial length integral.

Informally:

```text
L_n(a) = integral_0^(2*pi) |a + exp(i t)|^(1/n - 1) dt.
```

This is a placeholder theorem until the appropriate Mathlib arc-length API is
chosen.
-/
theorem radialLemniscateLengthIntegral_seed :
    True := by
  trivial

/--
Formal seed for the `a = 1` beta/gamma value.

Informally:

```text
L_n(1) = 2^(1/n) * Beta(1/2, 1/(2n)).
```

This should be split into reusable beta/gamma/integral lemmas before any
upstream submission.
-/
theorem radialLemniscateLength_one_beta_seed :
    True := by
  trivial

end EHPRadialLemniscate

