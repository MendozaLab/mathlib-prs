# Pinching Identity Mathlib PR Build Status 2026-04-29

## Bottom Line

`MendozaLab.PinchingIdentity` builds successfully against current Mathlib `master`.

- Build command: `lake build PinchingIdentity`
- Build result: `Build completed successfully (2572 jobs).`
- Mathlib revision: `1c83e3fe6144e0ba422d998f1ccd339aea8be0fb`
- Lean toolchain: `leanprover/lean4:v4.30.0-rc2`
- Workspace source file: `Math/Lean4/mathlib-prs/pinching-identity/MendozaLab/PinchingIdentity.lean`
- Canonical source file: `Math/Lean4/MendozaLab/PinchingIdentity.lean`
- Source SHA-256: `b0ea9fdd11ac7326f8a03b4bfc0fb67e362b0e498f330afea7dec5822c92ccff` (workspace and canonical are bit-identical)
- Declarations exported: `density`, `eigvalProbDist`, `shannonEntropy`, `vonNeumannEntropy`, `pinchingOnDensity`, `pinch_real_symm_psd_identity`, `von_neumann_eq_shannon_eigvals`, `h2_spectral_entropy_is_classical_shannon`
- Theorem count: 3 (`pinch_real_symm_psd_identity`, `von_neumann_eq_shannon_eigvals`, `h2_spectral_entropy_is_classical_shannon`)
- Executable `sorry`: 0
- Executable `axiom`: 0

## Scope

This is the matrix-coordinate pinching identity for real symmetric positive-semidefinite matrices, the §101 classical-equivalence anchor cited across the H² portfolio (fibromyalgia patent V1.7, H2D-MED V1.3, and downstream spectral-analysis claims).

The file proves:

- The Holevo pinching map evaluated on the eigenbasis of a real symmetric PSD matrix `C` is the identity on the trace-normalized density `ρ = C / Tr C` (`pinch_real_symm_psd_identity`).
- The von Neumann entropy of `ρ` equals the Shannon entropy of the trace-normalized eigenvalue probability distribution (`von_neumann_eq_shannon_eigvals`, closed by `rfl`).
- The combined classical-Shannon equivalence statement (`h2_spectral_entropy_is_classical_shannon`).

The proof of `pinch_real_symm_psd_identity` is a no-axiom constructive argument: rewrite the trace-normalized density via the eigenvector unitary using `Matrix.IsHermitian.conjStarAlgAut_star_eigenvectorUnitary`, observe that scalar normalization preserves diagonal form in the eigenbasis, drop off-diagonal entries via `diagonal (diag ·)`, and reconstruct by `Matrix.IsHermitian.spectral_theorem`.

## Verification Notes

The no-sorry/no-axiom scan used a comment-stripping source scan:

```bash
perl -0ne 's#/-.*?-/# #gs; s/--.*//g; print if /\b(sorry|axiom)\b/' \
  MendozaLab/PinchingIdentity.lean
```

The command produced empty output. Run `lake build PinchingIdentity` from this directory and confirm the `Build completed successfully (2572 jobs).` line; reproducibility relies on the pinned Mathlib revision recorded in `lake-manifest.json`.

## Submission Posture

Sibling Mathlib PR; submission is gated on Zenodo DOI mint of the companion preprint at `Math/preprints/pinching-identity/pinching_identity_2026-04-28.tex`. PR cover letter and target placement (`Mathlib.LinearAlgebra.Matrix.PinchingIdentity` namespace, `Matrix.IsHermitian.holevoPinching_density_eq_density` declaration name) are documented in `MATHLIB_PR_PREP.md`. The frozen citation name `pinch_real_symm_psd_identity` in the canonical source remains unchanged — Mathlib-namespace renaming is a downstream submission concern, not a build-verification concern.
