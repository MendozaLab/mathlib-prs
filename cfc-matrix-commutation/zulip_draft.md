# DRAFT — Lean Zulip pre-discussion (#mathlib4 stream)

Status: not yet posted. Awaiting (a) lake build PASS on the staging file, (b) Zulip account profile updated with GitHub link, (c) sanity check of post text against the Lean Zulip voice rules.

---

I'm putting together a small Mathlib4 PR adding two matrix-specific corollaries of the existing `IsSelfAdjoint.commute_cfcHom` theorem in `Mathlib/Analysis/CStarAlgebra/ContinuousFunctionalCalculus/Commute.lean`. The new file would live at `Mathlib/LinearAlgebra/Matrix/CFCCommute.lean` and it gives ergonomic access to the fact that `CFC.sqrt` of a positive-semidefinite matrix commutes with anything that commutes with the original matrix. The proofs are essentially one-line specializations — `PosSemidef` gives the self-adjointness via `PosSemidef.isHermitian`, and the rest is calling the general theorem.

Motivation: I'm working toward a follow-up PR that adds Uhlmann quantum fidelity `F(ρ, σ) = (Tr √(√ρ · σ · √ρ))²` on density matrices in `Mathlib/Analysis/Quantum/`. Several of the basic properties (value at coincidence, unitary invariance, the commuting case) need the matrix CFC commutation as a clean stepping stone. Splitting the prerequisite out as its own small PR seems cleaner than bundling.

I haven't seen anyone else working on either of these — quick search of the GitHub PR list and recent #mathlib4 threads turned up nothing on Uhlmann fidelity, Bures distance, or matrix-CFC commutation. Used Claude Code for the proof drafting and Mathlib API search; everything's hand-verified against current `master` source.

Question: any objections to the file path `Mathlib/LinearAlgebra/Matrix/CFCCommute.lean` for the prerequisite, or is there a better home for it under the existing CFC module hierarchy?
