# mathlib-prs

Staging area for MendozaLab-authored Lean 4 contributions to [mathlib4](https://github.com/leanprover-community/mathlib4). Each subdirectory is a self-contained Lake project pinned to a specific Mathlib release, where individual contributions are developed and tested before upstream submission to the leanprover-community/mathlib4 repository.

## Repository status

This repository holds in-development Lean 4 formal contributions. Each subdirectory is a standalone Lake project that targets a specific Mathlib version.

Contributions are staged in two phases:

- **Proof architecture**: Declarations with explicit axioms (cited to literature) and placeholder bodies. Axioms are used when supporting Mathlib infrastructure (e.g., matrix polar decomposition, CFC lemmas) has not yet landed. These files pass a local compilation gate and document their unproven claims transparently.

- **Complete formal proof**: All declarations closed (no axioms, no sorry). These files pass compilation and are ready for upstream submission.

Each subdirectory's own README documents its specific scope, axiom inventory, and compilation status.

## Active drafts

| Subdirectory | Mathlib pin | Target path | Build | Scope | Status |
|---|---|---|---|---|---|
| `uhlmann-fidelity` | v4.27.0 | `Mathlib/Analysis/Quantum/UhlmannFidelity.lean` | PASS | Proof architecture (1 definition + 3 proven theorems + 6 axioms) | Staged, not yet submitted |

## Building locally

Each subdirectory is self-contained. To build:

```bash
cd <subdirectory>
lake update    # one-time; downloads pinned Mathlib (~2–5 GB)
lake build     # subsequent builds use cached build artifacts
```

The `lake update` step downloads the pinned Mathlib version (specified in `lean-toolchain`). This may take 2–5 minutes and 2–5 GB of disk space on first run. Subsequent builds reuse cached artifacts and are much faster.

## Submission protocol

Contributions move through the following stages before upstream submission:

1. **Compilation gate**: The file must pass `lake build` against its pinned Mathlib version with no errors. Axioms and sorry placeholders are acceptable at this stage.

2. **Axiom inventory and audit**: Every axiom must carry an explicit comment naming the external theorem, authors, and publication reference. The axiom's mathematical content must be stated fully and accurately.

3. **Tactic realism check**: For any tactic proof, confirm that the tactic can actually prove the stated result. Hidden axioms (tactics that claim to prove something they cannot) are not allowed.

4. **Upstream submission**: Convert `axiom` declarations to `theorem ... := sorry` with the reference comment preserved, if preferred by Mathlib reviewers. Open a PR against [leanprover-community/mathlib4](https://github.com/leanprover-community/mathlib4) with the file path mirroring the subdirectory layout under `Mathlib/`.

## Conventions

- **License**: Apache License 2.0, matching Mathlib upstream. See [LICENSE](LICENSE).
- **Project layout**: One self-contained Lake project per subdirectory. Each has its own `lakefile.toml`, `lean-toolchain`, and `lake-manifest.json` pinning specific versions.
- **Version pinning**: Mathlib versions are pinned per subdirectory (no shared toolchain). This allows independent update schedules and testing.
- **Axioms in staging**: Axioms are allowed and encouraged in staging files when supporting Mathlib infrastructure is not yet available. Mandatory rule: every axiom must have a citation comment.
- **Build artifacts**: `.lake/` and `lake-manifest.json` changes are gitignored. Do not commit build artifacts.

## Author

Kenneth A. Mendoza ([MendozaLab](https://mendozalab.io))

## License

Apache License 2.0 — see [LICENSE](LICENSE).
