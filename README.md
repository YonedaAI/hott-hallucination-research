# HoTT Hallucination Research

**Hallucination is not a bug -- it's a theorem.**

A three-paper trilogy establishing the **Hallucination--Homotopy Correspondence (HHC)**: a complete, functorial classification of LLM hallucination types via homotopy type theory and algebraic topology.

**Website**: [hott-hallucination-research.vercel.app](https://hott-hallucination-research.vercel.app)

## Papers

### Paper 1: Topological Hallucination Detection (23 pages)
*A Homotopy-Theoretic Classification of LLM Failure Modes*

Proves five cases of the HHC, mapping each hallucination type to a topological invariant:

| Hallucination Type | Invariant | Obstruction |
|--------------------|-----------|-------------|
| Unjustified inference | pi_0 | Disconnection |
| Circular reasoning | pi_1 != 0 | Non-contractible loop |
| Inconsistent justifications | pi_2 != 0 | Incoherent 2-cell |
| Fabricated entity chain | H_n != 0 | Homological hole |
| Compositional drift | Holonomy | Transport anomaly |

- [PDF](papers/topological-hallucination-detection/paper.pdf) | [LaTeX](papers/topological-hallucination-detection/paper.tex) | [Haskell](code/topological-detection/TopologicalDetection.hs)

### Paper 2: Type-Theoretic Generation (24 pages)
*Hallucination-Free Language Generation via Dependent Type Theory*

Five generation principles replacing statistical sampling with proof search:

1. **Generation as type inhabitation** -- `arg min C(a)` subject to `Gamma |- a : A`
2. **Certified derivations** -- every term comes with a checkable proof
3. **Abstention on empty types** -- return bottom when no valid claim exists
4. **Context as fibration** -- dependent telescope, not flat sequence
5. **Attention as limit** -- weighted limit in Sem, not weighted sum in Vect

- [PDF](papers/type-theoretic-generation/paper.pdf) | [LaTeX](papers/type-theoretic-generation/paper.tex) | [Haskell](code/type-theoretic-gen/TypeTheoreticGen.hs)

### Paper 3: HoTT Synthesis (28 pages)
*A Unified Theory of Semantic Correctness for Language Models via Homotopy Type Theory*

Unifies detection and generation via:

- **Detection-Generation Adjunction** -- Generate -| Detect as adjoint functors
- **Semantic Monad** -- T = Detect . Generate with unit, multiplication, monad laws
- **Completeness Theorem** -- every hallucination is detected; generation never produces undetected hallucinations
- **POC Architecture** -- Generate-Check-Abstain loop with persistent homology monitoring

- [PDF](papers/hott-synthesis/paper.pdf) | [LaTeX](papers/hott-synthesis/paper.tex) | [Haskell](code/hott-synthesis/HoTTSynthesis.hs)

## Key Results

- **21 theorems** proven across 75 pages
- **5x5 duality**: each hallucination type pairs precisely with one generation principle (emergent property visible only across the trilogy)
- **Fundamental Obstruction Theorem**: any language model with a contractible representation space will necessarily hallucinate
- **Completeness Theorem**: the HHC + type-theoretic generation system is sound and complete

## Haskell Code

Three standalone modules, verified clean under `ghc -Wall -Wextra -Werror`:

```bash
# Run any module
runghc code/topological-detection/TopologicalDetection.hs
runghc code/type-theoretic-gen/TypeTheoreticGen.hs
runghc code/hott-synthesis/HoTTSynthesis.hs
```

Dependencies: `base` only (GHC boot libraries). No cabal/stack required.

## Project Structure

```
papers/
  topological-hallucination-detection/   # Paper 1: detection via homotopy invariants
  type-theoretic-generation/             # Paper 2: generation via type inhabitation
  hott-synthesis/                        # Paper 3: unified framework
  synthesis.md                           # Cross-paper analysis
code/
  topological-detection/                 # Haskell: 5 obstruction detectors
  type-theoretic-gen/                    # Haskell: type inhabitation + derivations
  hott-synthesis/                        # Haskell: full HoTT-LM POC
sources/                                 # Original source papers
images/og/                               # Open Graph images (1200x630)
website/                                 # Next.js site (deployed to Vercel)
social-posts.md                          # Posts for Twitter/X, LinkedIn, Facebook, Bluesky
```

## Author

**Matthew Long**
YonedaAI Research Collective | Magneton Labs LLC
Chicago, IL | matthew@yonedaai.com

## License

Copyright 2026 Magneton Labs LLC. All rights reserved.
