# Mathlib PR Prep — Pinching Identity for Real Symmetric PSD

**Status:** Pre-submission prep. Do NOT submit until (a) `lake build` PASS against current Mathlib master, (b) axiom replaced by constructive proof, (c) D1 `scoring_lean_artifacts` updated to `lake_build_status='pass'` + `sorry_count=0` + `axiom_count=0`, (d) Publisher + Crackpot-Scrub run on the companion preprint.

## Decision: sibling PR, not bundled

The Koopman-operator PR (`Math/Lean4/mathlib-prs/koopman-operator/`) is a focused contribution to `Mathlib.Dynamics.Ergodic` — Hilbert-space lift of measure-preserving transformations. The pinching identity belongs in `Mathlib.LinearAlgebra.Matrix.Spectrum` or a new sibling module — different mathematical object (Hermitian spectral functional calculus), different review pool, different importer surface. Mathlib reviewers prefer single-concept PRs; bundling would slow both. Submit as **sibling PR** after Koopman lands.

## Target module placement

`Mathlib/LinearAlgebra/Matrix/PinchingIdentity.lean`

Sibling to existing `Mathlib/LinearAlgebra/Matrix/Spectrum.lean` and `Mathlib/LinearAlgebra/Matrix/PosDef.lean`. Imports both. No new top-level dependencies.

## Toolchain

Match the Koopman PR setup:

```
lean-toolchain: leanprover/lean4:v4.30.0-rc2
mathlib version: git#master  (resolved at submission time)
```

## Promotion checklist (CLEAN-AXIOM → COMPILED → Mathlib-PR)

1. Replace the `axiom pinch_real_symm_psd_identity` declaration with a constructive proof using `Matrix.IsHermitian.spectralTheorem`. Proof sketch is in the file's module docstring; bounded by ~30 lines.
2. Lake-build against current Mathlib master:
   ```bash
   cd Math/Lean4/mathlib-prs/pinching-identity
   lake update
   lake build Mathlib.LinearAlgebra.Matrix.PinchingIdentity
   ```
   Verify: `Build completed successfully`, `axiom_count=0`, `sorry_count=0`.
3. Update D1 `scoring_lean_artifacts`:
   ```sql
   INSERT INTO scoring_lean_artifacts (
     assessment_id, lean_file_name, repo_relative_path,
     sorry_count, theorem_count, axiom_count, lemma_count,
     lake_build_status, last_verified_date, notes
   ) VALUES (
     <PinchingIdentity assessment id>,
     'PinchingIdentity.lean',
     'Mathlib/LinearAlgebra/Matrix/PinchingIdentity.lean',
     0, 3, 0, 0,
     'pass', '<YYYY-MM-DD>',
     'Sibling Mathlib PR; cited by H2 portfolio for §101 anchor'
   );
   ```
4. Run Publisher skill on the companion `.tex` preprint.
5. Run Crackpot-Scrub on the same preprint.
6. Submit Mathlib PR with the cover letter below.
7. Deposit Zenodo preprint to mint the stable DOI; update Lean file's module docstring with the DOI before the PR's final review pass.

## Cover-letter draft (Mathlib PR body)

```
Title: feat(LinearAlgebra/Matrix): pinching identity for real symmetric PSD matrices

This PR adds three lightweight definitions and one main theorem capturing
the equivalence of the von Neumann entropy and the Shannon entropy of the
trace-normalized eigenvalue distribution for any real symmetric
positive-semidefinite matrix with strictly positive trace.

The substantive content is a one-line consequence of
`Matrix.IsHermitian.spectralTheorem`: when ρ commutes with its own
eigenbasis projectors, the Holevo pinching map evaluated on those projectors
is the identity on ρ, and consequently `S_VN(ρ) = -Tr(ρ log ρ)` collapses
to a Shannon entropy of the eigenvalue distribution.

The definitions added are:
- `Matrix.density` : trace-normalized PSD matrix as a density operator
- `Matrix.eigvalProbDist` : trace-normalized eigenvalue distribution
- `Matrix.shannonEntropy` : classical Shannon entropy on a finite distribution
- `Matrix.vonNeumannEntropy` : as `shannonEntropy ∘ eigvalProbDist`

(Names normalized to Mathlib conventions; module-internal names in the
source repository may differ.)

The theorems are:
- `Matrix.IsHermitian.pinch_psd_identity`
- `Matrix.IsHermitian.von_neumann_eq_shannon_eigvals`

Sibling to the Koopman-operator contribution previously merged.
Companion preprint with full motivation and proof exposition is deposited
on Zenodo at DOI <fill at submission time>.

No new top-level dependencies. Imports `LinearAlgebra.Matrix.Spectrum` and
`LinearAlgebra.Matrix.PosDef`.
```

## Files in this directory (post-COMPILED)

- `Mathlib/LinearAlgebra/Matrix/PinchingIdentity.lean` — the Lean source (target Mathlib path)
- `lakefile.toml` — workspace lake manifest (mirror Koopman PR setup)
- `lean-toolchain` — `leanprover/lean4:v4.30.0-rc2`
- `STATUS_BUILD_<DATE>.md` — emitted on lake-build PASS, mirrors Koopman PR pattern

## Stable citation form (frozen now, do not change)

For patent-evidence binding and downstream reuse:

```
Mendoza, Kenneth A. (2026). "Pinching Identity for Real Symmetric Positive-
Semidefinite Covariance: Equivalence of von Neumann and Shannon Spectral
Entropies in Classical Statistics." Zenodo. DOI: <fill at deposit>.
Lean 4 / Mathlib repository, theorem `pinch_real_symm_psd_identity`.
Apache 2.0.
```

The theorem name `pinch_real_symm_psd_identity` and the Apache 2.0 license
are FROZEN now. The DOI is filled at Zenodo deposit. The Mathlib commit hash
is filled when the sibling PR merges. The combination of these three
references is what the H² portfolio's patent-evidence record cites.
