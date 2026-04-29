# PR Title

feat(Dynamics/Ergodic): add the Koopman operator on L2

# PR Body

This PR adds the Koopman operator associated with a measure-preserving transformation `T : X -> X`.

The operator is defined on `Lp C 2 mu` by precomposition, using the existing Mathlib linear isometry:

```lean
Lp.compMeasurePreservingₗᵢ C T hT
```

The contribution is a dynamics-facing API around that construction:

- `MeasureTheory.Koopman`
- `MeasureTheory.Koopman_apply`
- `MeasureTheory.Koopman_id`
- `MeasureTheory.Koopman_comp`
- `MeasureTheory.Koopman_const`
- `MeasureTheory.Koopman_iterate`

The composition statement is contravariant: since `U_T f = f ∘ T`, one has
`U_{T ∘ S} = U_S ∘ U_T`.

Verified locally with:

```bash
lake update
lake build Mathlib.Dynamics.Ergodic.Koopman
```

Build result:

```text
Build completed successfully (2166 jobs).
```

Mathlib revision tested: `95dcb74bf07a3a4f6828034c836a45b8fe7c6ca8`.

There are no executable `sorry` or `axiom` declarations in the added file.
