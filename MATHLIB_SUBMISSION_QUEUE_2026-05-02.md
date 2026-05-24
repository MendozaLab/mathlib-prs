# Mathlib Submission Queue

Date: 2026-05-02

Purpose: separate upstream-general Mathlib candidates from project-local EHP114
claims and speculative tensor-program material.

Status rule:

```text
LOCAL_SEED      = good local formalization target, not PR-ready
CANDIDATE_PR    = potentially upstreamable after compile + review
BLOCKED         = depends on missing infrastructure or speculative theorem
DO_NOT_SUBMIT   = project-specific / experimental / not Mathlib-shaped
```

No item below is an upstream submission until it passes:

```text
1. local Lean statement file exists,
2. sorry/axiom inventory is explicit,
3. lake build passes in the target Mathlib workspace,
4. theorem statement survives prior-art/counterexample review,
5. scope is useful to Mathlib outside the MendozaLab project.
```

## Priority Queue

| Rank | Item | Status | Why It Belongs / Does Not Belong | Target Location |
|---:|---|---|---|---|
| 1 | Matrix Frobenius / Hilbert-Schmidt inner product | CANDIDATE_PR | General matrix-analysis infrastructure; already staged. | `Lean4/mathlib-prs/frobenius-inner-product/` |
| 2 | Uhlmann fidelity infrastructure | CANDIDATE_PR after axiom reduction | General quantum-information infrastructure; currently has axioms and must not be oversold. | `Lean4/mathlib-prs/uhlmann-fidelity/` |
| 3 | EHP radial curve parameterization | LOCAL_SEED | General enough as a complex-analysis / plane-curve lemma if stated cleanly; useful first formal seed for EHP114. | `Lean4/mathlib-prs/ehp-radial-lemniscate/` |
| 4 | EHP exact `L(z^n - 1)` gamma/beta formula | LOCAL_SEED | Potentially upstreamable after the measure/arc-length dependencies are identified; formula itself is clean. | `Lean4/mathlib-prs/ehp-radial-lemniscate/` |
| 5 | Hypergeometric radial family `L_n(a)` | LOCAL_SEED / BLOCKED | Mathematically clean, but Mathlib hypergeometric support may be insufficient. Start local; upstream only smaller lemmas if useful. | `Lean4/mathlib-prs/ehp-radial-lemniscate/` |
| 6 | Cyclic representation block decomposition | LOCAL_SEED | General representation-theory / linear-algebra support may be useful, but needs non-EHP statement. | TBD |
| 7 | Stratified tensor-cone certificate | DO_NOT_SUBMIT | Project-specific proof architecture, not a Mathlib lemma yet. Keep in papers/experiments. | none |
| 8 | EHP114 conjecture / finite computational claims | DO_NOT_SUBMIT | Not a formal theorem package; computation certificates belong in repo artifacts, not Mathlib. | none |

## EHP Radial Lemma Seed

The Mathlib-worthy seed is not "EHP114 is true." It is the radial/equipotential
geometry used by the proof program.

Candidate theorem family:

```text
Let n >= 1 and a >= 0. For p_a(z) = z^n - a, the lemniscate |p_a(z)| = 1 is
covered by branches satisfying z^n = a + exp(i t).
```

Analytic length formula target:

```text
L_n(a) = integral_0^(2*pi) |a + exp(i*t)|^(1/n - 1) dt.
```

For `a = 1`, target exact value:

```text
L_n(1) = 2^(1/n) * Beta(1/2, 1/(2n))
       = 2^(1/n) * sqrt(pi) * Gamma(1/(2n)) / Gamma(1/2 + 1/(2n)).
```

This queue intentionally avoids claiming a formal proof of the arc-length
formula until the exact Mathlib APIs for arc length, rectifiable paths,
branched covers, and singular endpoints are inspected.

## Gate Notes

- The radial formula has an integrable singular endpoint at `a = 1`. A Lean
  statement must handle this explicitly, probably through interval integrals or
  improper-integral conventions already present in Mathlib.
- The branch map `z -> z^n` is singular at `z = 0`; this is exactly why the
  informal proof is stratified. Do not hide that in a smooth theorem statement.
- Hypergeometric statements should be delayed unless Mathlib already has the
  needed `_2F_1` infrastructure in the current pin.
- Tensor-cone terminology is not Mathlib-shaped. It belongs in the EHP proof
  packet until it reduces to reusable lemmas.

## Immediate Action

Create local seed workspace:

```text
Lean4/mathlib-prs/ehp-radial-lemniscate/
```

with:

```text
README.md
lean-toolchain
lakefile.toml
Mathlib/Analysis/Complex/EHPRadialLemniscate.lean
```

The first Lean file should contain theorem statements and honest `sorry` stubs,
not a claimed proof. It becomes a Mathlib PR candidate only after the statements
compile and at least one nontrivial lemma closes without project-specific
axioms.

