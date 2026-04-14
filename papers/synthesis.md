# Synthesis: The Homotopical Semantics Trilogy

## A Unified Reading of Topological Detection, Type-Theoretic Generation, and the HoTT Hallucination Framework

**Matthew Long**
YonedaAI Research Collective / Magneton Labs LLC, Chicago IL
April 2026

---

## 1. Overview and Scope

This document synthesizes three research papers into a coherent whole, revealing cross-cutting themes, compositional structure, theorem dependencies, emergent properties, and future directions. The three papers form a trilogy:

- **Part I: Topological Hallucination Detection** (23 pages) -- The diagnostic theory. Establishes that hallucination is a topological phenomenon, classifying five failure modes via homotopy groups and homology of a simplicial knowledge complex.

- **Part II: Type-Theoretic Generation** (24 pages) -- The constructive theory. Replaces statistical generation with type inhabitation search in dependent type theory, providing five generation principles that jointly guarantee hallucination freedom.

- **Part III: HoTT Synthesis** (28 pages) -- The unification. Shows that detection and generation form an adjoint pair, constructs the semantic monad T = Detect . Generate, and proves the Completeness Theorem establishing that the combined system catches all hallucinations while never producing new ones.

Together these papers total approximately 75 pages and constitute a complete mathematical framework for understanding, detecting, and preventing LLM hallucination. This synthesis document maps the logical architecture connecting them.

---

## 2. The Central Diagnosis: A Category-Theoretic Mismatch

All three papers rest on a single foundational insight, stated most clearly in Part I and carried through the entire trilogy:

**The Fundamental Mismatch.** Every contemporary LLM implements a functor

```
F : Sem --> Vect_R^fin
```

from the semantic category (an infinity-groupoid with non-trivial homotopy groups) to finite-dimensional vector spaces (a contractible space where all topological obstructions vanish). This functor necessarily collapses the higher categorical structure of meaning.

This diagnosis appears in each paper with increasing sophistication:

| Paper | How the mismatch manifests | What it implies |
|-------|---------------------------|-----------------|
| Part I | F_* : pi_n(Sem) --> pi_n(Vect) = 0, so the model cannot see topological obstructions | Hallucination is structurally inevitable |
| Part II | F is not faithful: distinct justifications map to identical embeddings | Statistical generation is unsound |
| Part III | F does not preserve limits: F(lim^W D) != lim^W(F . D), so attention in Vect hallucinates | The entire pipeline -- generation, attention, verification -- must operate in Sem, not Vect |

The key hierarchy:

- Part I identifies the *problem* (topological collapse).
- Part II identifies the *solution* (type inhabitation in a richer codomain).
- Part III proves these are *dual* aspects of a single structure (the adjunction).

---

## 3. Cross-Cutting Themes

### 3.1 Theme 1: The Semantic infinity-Groupoid

The foundational data type -- the semantic type as a homotopy type -- appears identically in all three papers:

- **0-cells** (points a : A): valid propositions or claims
- **1-cells** (paths p : a =_A b): justifications or entailments
- **2-cells** (alpha : p = q): equivalences between justifications
- **n-cells**: higher coherence data

Each paper uses this structure differently:

- **Part I** reads the invariants *from* this structure (pi_0, pi_1, pi_2, H_n, holonomy) to detect hallucination.
- **Part II** constructs terms *in* this structure (via proof search) to generate valid claims.
- **Part III** observes that reading invariants and constructing terms are adjoint operations.

The Haskell formalization is shared across all three papers with a common `SemType` GADT:

```haskell
data SemType where
  Entity   :: String -> SemType
  Prop     :: String -> SemType
  PathType :: SemType -> SemTerm -> SemTerm -> SemType
  ProdType :: SemType -> SemType -> SemType
  SumType  :: SemType -> SemType -> SemType
  VoidType :: SemType
  UnitType :: SemType
```

This shared type system is not coincidental -- it reflects the fact that detection and generation are operations on the same mathematical object.

### 3.2 Theme 2: The Truncation Level as Measure of LLM Capacity

All three papers reference the truncation level table:

| Level | Name | Semantic Interpretation | LLM Capacity |
|-------|------|------------------------|-------------|
| -2 | Contractible | Unique referent (rigid designator) | Yes |
| -1 | Mere proposition | True/false, no internal structure | Yes |
| 0 | Set | Claims with unique justifications | Partial |
| 1 | Groupoid | Multiple justifications | No |
| n | n-groupoid | n-th order coherence | No |
| infinity | infinity-groupoid | Full semantic structure | No |

Current LLMs operate as though all types are (-1)-truncated. Each paper addresses a different consequence:

- **Part I**: The collapse from level n to level -1 destroys the topological invariants (pi_n) that distinguish valid inference from hallucination.
- **Part II**: Generation at level n requires constructing n-dimensional derivation trees, which statistical sampling cannot do.
- **Part III**: The infinity-topos Sem_infinity provides the ambient universe where all truncation levels coexist, and the internal logic (HoTT) can reason about them uniformly.

### 3.3 Theme 3: The Knowledge Complex K_bullet

The simplicial knowledge complex is another structure that appears in all three papers, serving different roles:

- **Part I**: K_bullet is the object whose homology detects hallucination. The Hallucination-Homology Theorem (sigma is hallucinated iff [sigma] != 0 in H_n) is the central detection criterion.
- **Part II**: K_bullet provides the grounding for the `Ground` inference rule. The knowledge base K supplies the sources that anchor derivation trees.
- **Part III**: K_bullet is equipped with a Grothendieck topology, becoming the site over which the semantic sheaf F is defined. Detection becomes section-existence checking; generation becomes section construction.

### 3.4 Theme 4: The Five-Fold Classification

The five hallucination types and the five generation principles form a precise duality:

| Hallucination Type (Part I) | Topological Invariant | Generation Principle (Part II) | How it prevents this hallucination |
|-----------------------------|--------------------|-------------------------------|----------------------------------|
| Circular reasoning | pi_1 != 0 | Generation as type inhabitation | Proof search cannot produce non-contractible loops |
| Unjustified inference | pi_0 disconnection | Abstention on empty types | If types are in different components, inhabitation fails; system abstains |
| Inconsistent justifications | pi_2 != 0 | Certified derivations | Derivation tree makes justification structure explicit; conflation impossible |
| Fabricated entity chain | H_n != 0 | Context as fibration | Fibered context prevents locally-consistent-but-globally-unfounded chains |
| Compositional drift | Holonomy != id | Attention as weighted limit | Categorical attention detects non-trivial transport; fails on incoherent diagrams |

This five-by-five correspondence is not stated explicitly in any single paper. It only becomes visible when all three are viewed together. Each generation principle is the constructive dual of its corresponding detection criterion.

### 3.5 Theme 5: Abstention as a First-Class Operation

All three papers treat abstention (returning "I don't know") not as a failure but as the correct semantic response when the goal type is uninhabited:

- **Part I**: When the path type ||a =_A b|| = 0, there is genuinely no justification, and claiming one is hallucination.
- **Part II**: When type A is uninhabited, the system returns bot. This is correct behavior, not an error. Four levels of abstention are distinguished (provably uninhabited, search-exhausted, contextually uninhabited, knowledge-bounded).
- **Part III**: The GCA (Generate-Check-Abstain) loop formalizes abstention as a monadic operation. When the semantic monad T does not converge to a fixed point, the system abstains.

---

## 4. Compositional Structure: How the Papers Build on Each Other

### 4.1 Part I --> Part II: From Diagnosis to Prescription

Part I establishes that hallucination is a structural inevitability of any system whose representation space is contractible (the Fundamental Obstruction Theorem). Part II takes this as the starting point and asks: what would a system look like whose representation space is *not* contractible?

The answer: replace F : Sem --> Vect with the identity functor id : Sem --> Sem. Instead of mapping semantic types to vectors and then sampling, operate directly on semantic types via proof search. The five generation principles are precisely the constructive responses to the five topological obstructions identified in Part I.

**Key dependency**: Part II's Soundness Theorem (Theorem 3.1: if the generation procedure returns a term a with derivation delta, then Gamma |- a : A is valid) depends on the type theory T_Sem being well-defined, which in turn depends on the semantic type structure formalized in Part I.

### 4.2 Part II --> Part III: From Construction to Duality

Part II provides the generation machinery but does not address how detection and generation interact. Part III observes that the relationship is not mere complementarity but categorical adjunction:

```
Generate -| Detect : Sem --> Claim
```

This is an emergent property: neither Part I's detection nor Part II's generation alone reveals the adjoint structure. The adjunction only becomes visible when both are formalized as functors on the same categories.

### 4.3 Part I --> Part III: From Homology to Cohomology

Part I works with homology: H_n(K_bullet; Z) detects "holes" (missing justifications). Part III dualizes to cohomology: H^n(K_bullet, F) detects "obstructions" (failures of local-to-global consistency). The Universal Coefficient Theorem connects them:

```
0 --> Ext^1(H_{n-1}, Z) --> H^n(K_bullet; Z) --> Hom(H_n, Z) --> 0
```

This is not just a mathematical nicety. Homology is the detection perspective (finding holes); cohomology is the sheaf-theoretic perspective (checking section existence). They are the same obstruction viewed from dual vantage points -- precisely the detection-generation duality.

### 4.4 The Compositional Hierarchy

```
Part I (Detection)
  |
  | provides: topological invariants, knowledge complex, 
  | obstruction theory, the "why" of hallucination
  |
  v
Part II (Generation)
  |
  | provides: type inhabitation, certified derivations,
  | abstention, the "how" of correct generation
  |
  v
Part III (Synthesis)
  |
  | provides: adjunction, semantic monad, infinity-topos,
  | sheaf-theoretic unification, completeness theorem
  |
  v
[Complete Framework]
```

Each level genuinely builds on the previous. Part III could not be written without both Part I and Part II, because:

- The adjunction requires both Detect (from Part I) and Generate (from Part II) to be formalized as functors.
- The Completeness Theorem requires both detection soundness/completeness (Part I) and generation soundness (Part II).
- The semantic monad T = Detect . Generate literally composes the two functors.

---

## 5. The Dependency Graph of Theorems

### 5.1 Foundation Layer (Part I)

1. **Semantic Type (Definition 2.1)**: Foundational for everything.
2. **Non-Faithfulness of F (Proposition 2.4)**: Establishes that F collapses distinct morphisms.
3. **Contractibility of Vect (Proposition 2.5)**: Establishes that pi_n(Vect) = 0.
4. **Non-Contractibility of Sem (Proposition 2.6)**: Establishes that pi_n(Sem) != 0.
5. **Hallucination-Homology Theorem (Theorem 2.7)**: sigma is hallucinated iff [sigma] != 0 in H_n.
6. **Five Proof Cases (Section 3)**: Complete classification.
7. **Fundamental Obstruction Theorem (Theorem 4.1)**: No faithful functor Sem --> C exists for contractible C.
8. **Univalence Constraint (Section 5)**: Statistical similarity != semantic equivalence.
9. **Persistent Hallucination Detection (Theorem 6.1)**: Bridge to practical computation.

### 5.2 Construction Layer (Part II)

10. **Type Inhabitation Problem (Definition 3.1)**: Replaces "most likely token" with "does this type have an inhabitant?"
11. **Soundness of Type-Theoretic Generation (Theorem 3.2)**: Generated terms are valid. Depends on the type theory being well-founded (uses 1).
12. **Polynomial-Time Verification (Theorem 4.2)**: Derivation checking is O(||delta|| * |A|). Independent of Part I.
13. **Correct Abstention (Theorem 5.1)**: Returns bot when type is uninhabited. Depends on completeness of proof search (11).
14. **Fibration Soundness (Theorem 6.1)**: Generation output is in the fiber. Depends on semantic fibration structure from Part I.
15. **Weighted Limit Preserves Coherence (Theorem 7.1)**: Categorical attention is correct or abstains. Depends on diagram coherence.
16. **Hybrid Soundness (Theorem 8.1)**: Wrapping LLM with verifier is sound. Depends on 12.

### 5.3 Unification Layer (Part III)

17. **Detection-Generation Adjunction (Theorem 3.1)**: Generate -| Detect. Depends on both Detect (from 5, 6, 7) and Generate (from 10, 11) being well-defined functors.
18. **Monad Laws (Theorem 4.1)**: T = Detect . Generate satisfies monad laws. Depends on 17.
19. **Sem_infinity is an infinity-Topos (Theorem 5.1)**: Depends on the HoTT axioms and 1.
20. **Hallucination as Sheaf Obstruction (Theorem 6.1)**: o(s) in H^1(K_bullet, F) != 0. Depends on 5 (homological version) and the sheaf structure.
21. **Cohomological HHC (Theorem 6.4)**: Refines 6 via Universal Coefficient Theorem.
22. **Detection Soundness (Theorem 7.1)**: Uses 5.
23. **Detection Completeness (Theorem 7.2)**: Uses 6 (exhaustiveness of classification).
24. **Generation Soundness (Theorem 7.3)**: Uses 11 (type-theoretic generation soundness).
25. **The Completeness Theorem (Theorem 7.5)**: The capstone. Uses 22, 23, 24, and 17 (the adjunction). Proves the four equivalent characterizations of non-hallucinated claims.
26. **Fixed Points of T (Corollary 7.6)**: Non-hallucinated claims = fixed points of the semantic monad. Uses 25 and 18.

### 5.4 Critical Path

The logical critical path through the trilogy is:

```
Semantic Type (1) 
  --> Hallucination-Homology Theorem (5) 
  --> Fundamental Obstruction Theorem (7)
  --> Type Inhabitation Problem (10) 
  --> Soundness of Generation (11)
  --> Detection-Generation Adjunction (17)
  --> Completeness Theorem (25)
```

Each step depends essentially on its predecessors. The Completeness Theorem is the summit, requiring the entire edifice below it.

---

## 6. Emergent Properties: What Only the Combined Framework Reveals

### 6.1 The Five-by-Five Duality Table

As noted in Section 3.4, the precise pairing of each hallucination type with its preventing generation principle only becomes visible when Parts I and II are read together. No single paper states this correspondence in its complete form.

### 6.2 Hallucination as Adjunction Failure

Part III's Corollary 3.6 states: a claim a-hat is hallucinated if and only if the counit epsilon_{a-hat} is not an isomorphism. This characterization is impossible without both the detection functor (Part I) and the generation functor (Part II). It provides the most elegant single criterion for hallucination: the generate-detect round-trip does not return to the starting point.

### 6.3 Fixed Points = Truth

Corollary 7.6 of Part III states that non-hallucinated claims are precisely the fixed points of the semantic monad T. This is a deep result: truth (in the sense of semantic validity) is characterized as a fixed-point property of an endofunctor. This connects the hallucination problem to classical fixed-point theory and domain theory in the Eilenberg-Moore category.

### 6.4 The Homology-Cohomology Bridge

Part I works with homology (detecting holes from below). Part III introduces the cohomological perspective (detecting obstructions from above). The Universal Coefficient Theorem connecting them (Theorem 6.4 of Part III) is an emergent relationship that neither paper individually motivates. It reveals that detection and generation are not just adjoint but *Poincare dual* in a precise sense: homology detects what is missing; cohomology detects what prevents gluing.

### 6.5 The Presheaf Model

Part III's discussion of presheaf models (Section 11.3) shows that the infinity-topos Sem_infinity can be modeled concretely as:

```
Sem_infinity ~ PSh(C) = [C^op, infinity-Grpd]
```

where C is the category of contexts. This connects the abstract framework to concrete Kripke-Joyal semantics: "A is true at Gamma" means A(Gamma) is inhabited. This model-theoretic connection is only meaningful when all three threads (types, topology, sheaves) are in play simultaneously.

### 6.6 The GCA Loop as Monadic Computation

The Generate-Check-Abstain loop (Part III, Construction 8.2) implements the semantic monad as a practical algorithm. Its convergence to a fixed point (or to abstention) is guaranteed by the monad laws. This is an emergent computational pattern: the abstract categorical structure (adjunction, monad) directly determines the algorithm's control flow.

---

## 7. The Unified Mathematical Framework

The three papers share a common mathematical universe that can be summarized in a single diagram:

```
                  F (lossy)
    Sem -----------------------> Vect
     |                            |
     | pi_n                       | pi_n = 0
     v                            v
  pi_n(Sem) != 0  ---F*--->     0
     |
     | [Part I: Detection]
     v
  H_n(K_bullet) <---> H^n(K_bullet, F)  [Part III: Sheaf Duality]
     |                     |
     |                     | [Section existence]
     v                     v
  Generate --|         |-- Detect        [Part II & III: Adjunction]
             |         |
             v         v
           T = Detect . Generate         [Part III: Semantic Monad]
             |
             v
        Fixed points = Truth             [Part III: Completeness]
```

### 7.1 The Three Levels of Abstraction

**Level 1: Algebraic Topology (Part I)**

Semantic space is a topological space with non-trivial invariants. The functor F : Sem --> Vect collapses these invariants. Hallucination = non-trivial class in pi_n or H_n. Detection = computing these invariants. Persistent homology provides the bridge to computation.

**Level 2: Dependent Type Theory (Part II)**

Semantic space is a universe of types. Claims are terms; validity is type-checking. Generation is proof search; abstention is empty type recognition. The Curry-Howard correspondence makes derivations into first-class data.

**Level 3: Higher Topos Theory (Part III)**

Semantic space is an infinity-topos whose internal logic is HoTT. Detection and generation are internal operations (type-checking and proof search) connected by an adjunction. The sheaf-theoretic formulation unifies the topological (Level 1) and type-theoretic (Level 2) perspectives under one roof.

These three levels are not alternatives but layers of a single framework, with each level providing structure that the others lack:

- Level 1 provides the *diagnostic invariants* (what goes wrong).
- Level 2 provides the *constructive content* (how to do it right).
- Level 3 provides the *ambient universe* (where both operate) and the *structural relationships* (how they compose).

---

## 8. The Haskell Formalization: Shared Architecture

### 8.1 Common Core

All three Haskell modules (TopologicalDetection.hs, TypeTheoreticGen.hs, HoTTSynthesis.hs) share the same core data types:

- `SemType`: Entity, Prop, PathType, ProdType, SumType, VoidType, UnitType
- `SemTerm`: Grounded, Inferred, PathWitness, Refl, Hallucinated
- `Source`: Empirical, Documentary, Axiomatic, Derived
- `Justification`: Entailment, Definition, Analogy, Statistical
- `PathEvidence`: Definitional, Propositional, ByUnivalence, NoEvidence

This shared vocabulary makes the composition concrete: the output types of one module are the input types of another.

### 8.2 Module-Specific Extensions

**TopologicalDetection.hs** adds:
- `TopologicalObstruction` (the five obstruction types)
- `KnowledgeComplex` (vertices, edges, faces)
- Five detector functions (detectCircularReasoning, detectDisconnection, etc.)
- Simplicial homology computation (boundary operators, cycle/boundary checks)

**TypeTheoreticGen.hs** adds:
- `Derivation` (AxiomD, IntroD, ElimD, etc.)
- `inhabit` (proof search function)
- `verify` (derivation verification)
- `CatAttention` (categorical attention with coherence checking)

**HoTTSynthesis.hs** unifies both and adds:
- `SemanticM` (the semantic monad, as a Haskell Monad instance)
- `detect` / `generate` (the adjoint pair)
- `gcaLoop` (the Generate-Check-Abstain loop)
- `findObstructions` (integrated five-detector pipeline)

### 8.3 Compositional Structure in Code

The compositional structure is directly visible in the code:

```haskell
-- The semantic monad: T = Detect . Generate
semanticT :: SemTerm -> SemanticM SemTerm
semanticT claim = do
  detResult <- detect claim    -- Part I
  case detResult of
    Verified     -> return claim
    Obstructed _ -> do
      gen <- generate goalType  -- Part II
      case gen of
        Just (term, _) -> return term
        Nothing        -> abstain   -- Part II, Principle P3
```

The monad laws (Part III, Theorem 4.1) are enforced by the `Monad` instance for `SemanticM`, which accumulates topological obstructions through the monadic bind.

---

## 9. Open Problems and Future Directions

### 9.1 Problems Raised by Individual Papers

**From Part I:**
- Efficient persistent homology for real-time generation monitoring
- Computability limits of type-checking in full dependent type theory
- Construction of the knowledge complex K_bullet from imperfect, incomplete data

**From Part II:**
- Efficient proof search for natural language types
- Type inference from natural language queries
- Extension to creative/fictional generation via modal types

**From Part III:**
- Efficient type inhabitation guided by LLM probability distributions
- Higher-dimensional hallucination (pi_n for n >= 3 -- do they arise?)
- Quantitative sheaf cohomology at scale

### 9.2 Problems That Emerge from the Synthesis

**The Parsing Oracle Problem.** All three papers assume the existence of a mapping from natural language to semantic types. Part II acknowledges this as a limitation; Part III inherits it. Solving this problem -- essentially building a reliable "natural language to HoTT" compiler -- may be as hard as the original generation problem. However, the framework suggests that an imperfect parser combined with a sound verifier (the hybrid architecture of Part II, Section 8) can still guarantee soundness, trading completeness for safety.

**The Abstention-Coverage Tradeoff.** The combined framework guarantees zero hallucination rate but may abstain too aggressively. The four abstention levels (Part II, Definition 5.2) provide a graduated response, but the optimal balance between coverage and safety is an empirical question that the theoretical framework does not resolve.

**Graded Type Theories.** Real-world semantic validity is often graded, not binary. The framework operates with crisp type inhabitation. Future work could explore graded type theories or fuzzy types where inhabitation comes in degrees, potentially connecting to the probabilistic information that LLMs do capture well.

**Multi-Modal Semantic Types.** Part III's conclusion suggests extending the infinity-topos to multi-modal types (text + image + audio). The framework is mathematically well-suited to this (the infinity-topos structure is agnostic to the "content" of types), but the practical challenges of constructing knowledge complexes and performing proof search over multi-modal data are substantial.

**Cubical Implementation.** All three papers mention cubical type theory as providing constructive content for the univalence axiom. A cubical implementation of the framework would make the path operations (transport, composition, inversion) computationally effective, enabling direct implementation of the semantic monad.

### 9.3 The Grand Challenge

The overarching open problem is:

**Can an LLM be wrapped in a type-theoretic layer efficiently enough for real-time generation, with a knowledge complex rich enough to cover open-domain queries, while maintaining zero hallucination rate?**

The theoretical framework says yes in principle (the Completeness Theorem). The practical question is whether the computational overhead (proof search, homology computation, derivation verification) can be made tractable at scale. The hybrid architecture (Part II, Section 8; Part III, Section 8) is the pragmatic answer: let the LLM generate candidates, and use the type-theoretic layer for verification only. This trades completeness for efficiency while preserving soundness.

---

## 10. Reading Guide

### 10.1 Recommended Reading Order

**For readers with a background in algebraic topology or homotopy theory:**
Part I --> Part III --> Part II

Start with the topological diagnosis (Part I), which is the most mathematically self-contained. Then read the synthesis (Part III), which lifts the topological invariants into the topos-theoretic setting. Finally read Part II for the constructive content.

**For readers with a background in type theory or programming language theory:**
Part II --> Part I --> Part III

Start with the type-theoretic generation framework (Part II), which uses familiar concepts (dependent types, Curry-Howard, proof search). Then read Part I to understand the topological obstructions that the type system prevents. Finally read Part III for the categorical unification.

**For readers with a background in machine learning or NLP:**
Part I (Sections 1-3) --> Part II (Sections 1-5) --> Part III (Sections 1-2, 7-8) --> remaining sections

Start with the motivating diagnosis and the five hallucination types (Part I, first half). Then read the five generation principles (Part II, first half). Then read the completeness theorem and the POC architecture (Part III). Return to the full mathematical details afterward.

**For a mathematical reader seeking the logical skeleton:**
Part I Section 4 (Fundamental Obstruction Theorem) --> Part II Section 3 (Soundness Theorem) --> Part III Section 7 (Completeness Theorem)

These three theorems form the backbone. Everything else is either building toward them or deriving consequences from them.

### 10.2 Prerequisites

- **Essential**: Basic category theory (functors, natural transformations, adjunctions). Familiarity with algebraic topology at the level of fundamental groups and homology.
- **Helpful**: Homotopy type theory (identity types, univalence, truncation levels). Dependent type theory (Martin-Lof type theory, Curry-Howard correspondence).
- **For full depth**: infinity-categories (Lurie's Higher Topos Theory), sheaf cohomology (Mac Lane and Moerdijk), persistent homology (Edelsbrunner and Harer).
- **For the code**: Haskell with GADTs and DataKinds extensions.

### 10.3 Key Definitions to Internalize

Before reading any paper, ensure you understand:

1. **Semantic type as homotopy type** (all three papers, Definition 2.1 / Definition 2.1 / Definition 2.1): The 0-cells/1-cells/2-cells/n-cells structure.
2. **The functor F : Sem --> Vect** (Part I, Definition 2.4): The lossy embedding that LLMs implement.
3. **Type inhabitation** (Part II, Definition 3.1): The reformulation of generation as proof search.
4. **The knowledge complex K_bullet** (Part I, Definition 2.5): The simplicial set whose homology detects hallucination.

---

## 11. Summary of Key Results

### 11.1 The Fundamental Obstruction Theorem (Part I)

*No faithful functor from a semantically non-trivial category to a contractible codomain exists.* This is the foundational negative result: hallucination is a theorem, not a bug.

### 11.2 The Hallucination-Homotopy Correspondence (Part I)

*Five hallucination types correspond bijectively to five topological invariants:* pi_0 (disconnection), pi_1 (circular reasoning), pi_2 (inconsistent justifications), H_n (fabricated chains), holonomy (compositional drift). The correspondence is functorial.

### 11.3 The Soundness Theorem (Part II)

*If type-theoretic generation returns a term a with derivation delta, then a is semantically valid.* This is the foundational positive result: the type-theoretic alternative provably avoids hallucination.

### 11.4 The Abstention Theorem (Part II)

*When the goal type A is uninhabited, the system returns bot. This is the unique correct response.* Abstention is not failure; it is type-theoretically mandated behavior.

### 11.5 The Detection-Generation Adjunction (Part III)

*Generate -| Detect : Sem --> Claim.* Detection and generation are adjoint functors. This is the central structural insight: they are not independent operations but two sides of a single categorical coin.

### 11.6 The Semantic Monad (Part III)

*T = Detect . Generate is a monad on Sem* with unit eta (claim-and-verify), multiplication mu (collapse redundant verification), and the property that T-algebras are self-verifying semantic types.

### 11.7 The Completeness Theorem (Part III)

*The combined system is complete: (i) every hallucination is detected, (ii) generation never produces hallucinations, (iii) non-hallucinated claims are fixed points of T.* This is the capstone result of the trilogy.

---

## 12. Conclusion

The three papers form a logically tight trilogy:

- **Part I** establishes that hallucination is *inevitable* in current architectures (a negative result).
- **Part II** establishes that hallucination is *avoidable* in type-theoretic architectures (a positive result).
- **Part III** establishes that detection and generation are *dual* operations whose composition (the semantic monad) provides a *complete* system (a unification result).

The emergent insight of the trilogy -- visible only when all three papers are read together -- is that the hallucination problem is not a deficiency of particular models but a consequence of operating in the wrong mathematical universe. The solution is not better statistics but richer mathematics: replacing the contractible codomain Vect with the infinity-topos Sem_infinity, and replacing probabilistic generation with certified type inhabitation. The adjunction Generate -| Detect and the semantic monad T provide the organizing principle for this replacement.

The framework is formalized in Haskell across three modules sharing a common type system, demonstrating that the mathematics is not merely abstract but computationally concrete. The POC architecture (Part III) shows how to wrap existing LLMs with a type-checking layer, providing a pragmatic path from theory to practice.

The central message: *the topology of meaning must be respected, not collapsed.*

---

## Appendix: File Locations

### Papers (LaTeX source)
- Part I: `papers/topological-hallucination-detection/paper.tex`
- Part II: `papers/type-theoretic-generation/paper.tex`
- Part III: `papers/hott-synthesis/paper.tex`

### Haskell Formalizations
- Part I: `code/topological-detection/TopologicalDetection.hs`
- Part II: `code/type-theoretic-gen/TypeTheoreticGen.hs`
- Part III: `code/hott-synthesis/HoTTSynthesis.hs`

### Knowledge Base
- `.knowledge-base.md`
