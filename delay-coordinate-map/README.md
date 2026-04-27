# Delay-coordinate map

Staging directory for a Mathlib4 pull request that adds the delay-coordinate map associated with a transformation `T : X → X` and an observation function `φ : X → ℝ`. Defined by `x ↦ (φ(x), φ(Tx), φ(T²x), …, φ(Tⁿ x))` for delay length `n + 1`.

The delay-coordinate map is the named object underlying the Takens embedding theorem (1981) and its Sauer–Yorke–Casdagli generalisation (1991). This contribution adds the named object and its basic continuity / iteration properties only — the embedding theorem itself requires substantial follow-up infrastructure (Whitney embedding, Thom transversality, Baire-category genericity) and is out of scope.

## Status

| Gate | Status |
|---|---|
| Compilation gate (lake build PASS against Mathlib v4.27.0) | Pending — first build run not yet executed |
| Sorry count target for v1 | 0 (proofs are mechanical) |
| Upstream PR | Not yet submitted |

## Scope

One definition + three theorems in the `Dynamics` namespace:

- `delayCoordinateMap T φ n` — the length-`(n + 1)` delay-coordinate map
- `delayCoordinateMap_zero` — length-1 case
- `delayCoordinateMap_continuous` — continuity under continuity hypotheses on `T` and `φ`
- `delayCoordinateMap_succ` — recursive / extension structure

## Out of scope (reserved for follow-up PRs and infrastructure)

- Takens embedding theorem (genericity of `φ` makes delay-coordinate map of length `2 dim M + 1` an embedding `M ↪ ℝ^(2 dim M+1)`) — requires Whitney embedding theorem, Thom transversality, and Baire-category genericity infrastructure not currently in Mathlib
- Sauer–Yorke–Casdagli generalisation to fractal-dimension state spaces
- Smooth-manifold immersion / embedding versions
- General `ℝᵏ`-valued observation functions (this file is `ℝ`-valued; the natural generalisation is straightforward but not load-bearing for the named object)

## Mathlib infrastructure dependencies

- `Mathlib.Dynamics.FixedPoints.Basic` — for `Function.iterate` (`T^[n]` notation)
- `Mathlib.Topology.Basic` — for `Continuous`
- `Mathlib.Data.Fin.Basic` — for `Fin (n + 1)` index type

## Building

```bash
cd delay-coordinate-map
lake update    # downloads pinned Mathlib v4.27.0 (~2-5 GB on first run)
lake build     # subsequent builds use cached artifacts
```

## Downstream uses (post-merge)

- The named object `delayCoordinateMap` is the input to any future Takens-style theorem in Mathlib. Once Whitney embedding and transversality land (separate, substantial future contributions), the embedding theorem itself becomes statable directly in terms of this map.
- Time-series analysis / Koopman-mode decomposition / dynamical-systems data analysis: the delay-coordinate map is the standard reconstruction used in scientific computing and machine learning on dynamical-systems data; having it in Mathlib gives those literatures a Lean-citable foundation.

## References

- F. Takens, *Detecting strange attractors in turbulence*, in Dynamical Systems and Turbulence, Warwick 1980, Lecture Notes in Mathematics vol. 898, Springer 1981, pp. 366–381.
- T. Sauer, J. A. Yorke, and M. Casdagli, *Embedology*, Journal of Statistical Physics 65 (1991), 579–616.
- H. D. I. Abarbanel, *Analysis of Observed Chaotic Data*, Springer 1996. Chapter 4.

## Tooling and acknowledgments

This file was prepared with assistance from Anthropic's Claude (Claude Code CLI) for proof drafting, Mathlib API search, and tactic iteration. All theorem statements and proof tactics are author-verified against Mathlib v4.27.0 source. The author is responsible for the final content.
