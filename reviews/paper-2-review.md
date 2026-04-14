# Formal Review: Paper 2

**Paper:** Type-Theoretic Generation: Hallucination-Free Language Generation via Dependent Type Theory
**Author:** Matthew Long, YonedaAI Research Collective / Magneton Labs LLC
**Reviewer:** Code Review Agent
**Date:** 2026-04-14
**Rating:** Weak Accept

---

## I. PAPER REVIEW

### 1. Mathematical Rigor of the Five Generation Principles

**P1 -- Generation as Type Inhabitation (Section 3)**

The formulation is sound in intent. The replacement of `argmax P(t | ctx)` with `argmin C(a)` subject to `Gamma |- a : A` is well-motivated. However, the cost function `C(a)` is introduced in Equation (2) but never formally defined anywhere in the paper. Without a formal definition of `C`, the optimization problem is not well-posed. **Significant gap in formalization.**

**P2 -- Certified Derivations (Section 4)**

Theorem 4.1 (Polynomial-Time Verification) is the strongest result and its proof is largely correct. However, Proposition 2.1 (Decidability of Type Checking) conflates decidability in MLTT and HoTT. Type checking in the presence of univalence is one of the key open problems motivating cubical type theory. The paper cannot simultaneously claim HoTT foundations and cite straightforward MLTT decidability without addressing this tension.

**P3 -- Abstention on Empty Types (Section 5)**

Theorem 5.1 (Correct Abstention) as stated is circular: "if A is uninhabited, the search returns bottom." The substantive claim -- that the search correctly identifies uninhabited types -- is only addressed by depth-bounded completeness (Proposition 3.2). Should be re-stated as a conditional soundness result.

**P4 -- Context as Fibration (Section 6)**

The most mathematically substantive part. Definition 6.1 is clear and Theorem 6.1 is correctly proven. One gap: Definition 6.3 (Fiber Coherence) defines a very strong condition that is never used in any subsequent theorem.

**P5 -- Attention as Weighted Limit (Section 7)**

Conceptually novel but weakest proof. Theorem 7.1 conflates two directions: coherent diagram implies limit exists (requires completeness of Sem, which is not established), and incoherent diagram implies no limit (correctly proven). Proposition 7.2 hand-waves about F not preserving limits.

### 2. Logical Flow

Well-organized progression. One structural weakness: the interaction between P4 (fibration) and P5 (attention) is underexplored. The HoTT-LM in Definition 8.1 lists four components but there is no formal statement about how categorical attention feeds into the generator. **Missing compositional theorem.**

### 3. Completeness of Theorems

- **Soundness (Theorem 3.1):** Proven.
- **Polynomial verification (Theorem 4.1):** Proven, with univalence caveat.
- **Correct abstention (Theorem 5.1):** Conditional only.
- **Fibration soundness (Theorem 6.1):** Proven.
- **Weighted limit coherence (Theorem 7.1):** Partially proven.
- **Hybrid soundness (Theorem 8.1):** Proven, conditional on verifier.

### 4. Novelty Relative to Paper 1

Genuine constructive advance: formal proof search algorithm, derivation algebra as first-class data, hybrid architecture over existing LLMs. However, `Sem` remains undefined as a precise mathematical object across both papers.

### 5. Practicality of the HoTT-LM Architecture

The hybrid architecture (Section 8.3) is the most practically actionable contribution. However, the "parsing gap" -- converting natural language to semantic types -- is severely underweighted. The framework is hallucination-free only if the semantic type is correctly determined, which is a very strong precondition.

### 6. Notation Consistency with Paper 1

Mostly consistent. Minor divergences: `\Type` font (`\mathcal{U}` vs `\mathsf{Type}`), `\Grpd` infinity symbol (bold vs non-bold), `\refl` font family.

### 7. Bibliography

All references real and appropriate. One concern: `cohen2018cubical` page range (195-340) seems unusually long for a journal article.

---

## II. CODE REVIEW

### 1. Faithfulness to the Paper

**Significant divergences:**

- Paper shows `PathType :: SemType -> SemTerm -> SemTerm -> SemType`. Actual code: `PathType SemType String String`. Cannot represent paths between compound terms.
- `DepType` (dependent function types) appears in paper listing but is entirely absent from code. `FuncType` in code is non-dependent. **The code does not implement dependent types despite the paper's central claim.**
- `GADTs`, `DataKinds`, `RankNTypes` pragmas are declared but unused.

### 2. Correctness

**Bug: `typeCheck` for `InL`/`InR` is unsound (lines 190-191)**
Accepts any injected sub-term without checking its type against the sum's component type. `InL (Hallucinated "x")` would be accepted for any sum type. **Direct counterexample to Theorem 3.1.**

**Bug: `verifyDerivation` catch-all returns `True` (line 364)**
Accepts all unmatched term/type/derivation combinations. Makes the certified derivation guarantee (P2) hollow.

**Bug: `hallucinationMeasure` does not normalize**
Returns raw probability sum, not guaranteed in [0,1].

**Bug: `ctxSearch` returns `UnitTerm` for non-Entity/non-Prop types**
When matching type is found but is PathType or ProdType, returns `UnitTerm` -- wrong type.

**Issue: `abstentionLevel` collapses 3 of 4 paper-defined levels into one**
`KnowledgeBounded` constructor defined but never returned.

**Issue: Weighted limit computation ignores weights**
`diagWeights` stored but never used in `checkDiagramCoherence` or `categoricalAttend`.

### 3. Code Quality

Strengths: clear module structure, type signatures on all top-level functions, good use of `<|>` in `inhabit`.

Weaknesses: unused language pragmas, `decomposeSearch` uses `ElimD` for product introduction (naming mismatch), `checkDiagramCoherence` returns first diagram object instead of computing a limit.

### 4. Demo Coverage

All five principles demonstrated in sequence -- a genuine strength. P5 demo (coherent vs. incoherent diagram) is the strongest. However, P2 demo does not demonstrate the formal distinction because `verifyDerivation` catch-all accepts everything.

---

## III. OVERALL ASSESSMENT

### Strengths

1. Conceptual clarity of the five principles.
2. Hybrid architecture (Section 8.3) is practically actionable today.
3. Curry-Howard correspondence table (Section 4) is a pedagogical highlight.
4. Honest acknowledgment of limitations (Section 9.3).
5. Incoherent diagram example (Example 7.1, Mona Lisa) is memorable and illustrative.
6. Bibliography quality is excellent.

### Weaknesses

1. **The cost function C(a) is undefined.** The paper's central reformulation (Equation 2) involves minimizing C but C is never defined.
2. **Univalence and decidable type checking are in tension.** Not simultaneously achievable with current tools.
3. **`Sem` is never defined as a mathematical object.** Every key theorem appeals to properties of Sem but it is only described motivationally.
4. **The code does not implement dependent types.** No Pi-types, no Sigma-types with actual dependency. Undermines the value of the Haskell formalization.
5. **The `InL`/`InR` soundness bug is a direct counterexample to Theorem 3.1** as implemented.
6. **The weighted limit computation ignores weights.**

### Concrete Improvements Required

**Paper:**
1. Add formal definition of C(a).
2. Clarify HoTT vs MLTT for the decidability claim (two-layer approach).
3. Provide precise categorical definition of Sem.
4. Weaken Theorem 5.1 to conditional soundness.
5. Add theorem connecting P4 (fibration) and P5 (attention).
6. Fix `\Type` macro inconsistency with Paper 1.

**Code:**
1. Fix `InL`/`InR` type check to verify sub-terms.
2. Replace `verifyDerivation` catch-all with explicit cases.
3. Fix `ctxSearch` to return correct term type.
4. Implement weighted limit computation using `diagWeights`.
5. Normalize `hallucinationMeasure` to [0,1].
6. Remove unused GADT/DataKinds pragmas or actually use them.

### Score Table

| Criterion | Score (1-5) | Notes |
|---|---|---|
| Mathematical rigor | 3 | P1,P2 strong; P3 overstated; P5 has gap |
| Logical flow | 4 | Well-structured; P4-P5 interaction missing |
| Completeness of theorems | 3 | 4/6 fully proven |
| Novelty vs Paper 1 | 4 | Genuine constructive advance |
| Practicality | 3 | Hybrid arch strong; parsing gap underweighted |
| Notation consistency | 3 | Minor macro divergences |
| Bibliography | 5 | Excellent |
| Code faithfulness | 2 | PathType, Pi-types, Sigma-types missing |
| Code correctness | 2 | InL/InR bug, verifyDerivation catch-all |
| Code quality | 3 | Good structure; unused pragmas |
| Demo coverage | 4 | All 5 principles shown |

**Final rating: Weak Accept.** The theoretical contribution is genuine. The Haskell code contains a falsifiable counterexample to the paper's main soundness theorem and does not implement dependent types despite that being the paper's central claim. These issues should be addressed before final publication.
