# Koopman Mathlib PR Build Status 2026-04-29

## Bottom Line

`Mathlib.Dynamics.Ergodic.Koopman` builds successfully against current Mathlib `master`.

- Build command: `lake build Mathlib.Dynamics.Ergodic.Koopman`
- Build result: `Build completed successfully (2166 jobs).`
- Mathlib revision: `95dcb74bf07a3a4f6828034c836a45b8fe7c6ca8`
- Lean toolchain: `leanprover/lean4:v4.30.0-rc2`
- Source file: `Mathlib/Dynamics/Ergodic/Koopman.lean`
- Declarations: `Koopman`, `Koopman_apply`, `Koopman_id`, `Koopman_comp`, `Koopman_const`, `Koopman_iterate`
- Executable `sorry`: 0
- Executable `axiom`: 0

## Scope

This is a focused first PR for the Koopman operator on `Lp C 2 mu` associated with a measure-preserving map `T : X -> X`.
It is intentionally an API layer over the existing `MeasureTheory.Lp.compMeasurePreservingₗᵢ` linear isometry.

The file proves:

- a.e. action by precomposition;
- identity map compatibility;
- contravariant composition;
- fixedness of constant functions under finite measure;
- compatibility with iterates.

## Verification Notes

The no-sorry/no-axiom scan used a comment-stripping source scan:

```bash
perl -0ne 's#/\\-.*?\\-/# #gs; s/--.*//g; print if /\\b(sorry|axiom)\\b/' \
  Mathlib/Dynamics/Ergodic/Koopman.lean
```

The command produced empty output.

## Submission Posture

This directory is PR-ready locally. The upstream PR should include the Lean source file and the normal Mathlib branch state; this status file is a local handoff artifact, not intended for upstream.
