export interface Paper {
  slug: string;
  title: string;
  part: string;
  partNumber: number;
  abstract: string;
  pages: number;
  keyResult: string;
  category: string;
  ogImage: string;
  coverImage?: string;
}

export const papers: Paper[] = [
  {
    slug: 'topological-hallucination-detection',
    title: 'Topological Hallucination Detection: A Homotopy-Theoretic Classification of LLM Failure Modes',
    part: 'Part I',
    partNumber: 1,
    abstract: `We establish a rigorous, complete classification of large language model (LLM) hallucination failure modes through the lens of algebraic topology and homotopy type theory (HoTT). Our central diagnosis is that current LLM architectures implement a functor F: Lang → Vect_R from the category of linguistic expressions to finite-dimensional real vector spaces, thereby collapsing the higher categorical structure of semantic space—which is naturally an ∞-groupoid with non-trivial homotopy groups—into a contractible codomain where all topological obstructions vanish identically. We prove that this structural collapse is the root cause of hallucination. We develop five rigorous proof cases showing that each fundamental hallucination type corresponds to a specific topological invariant: (1) circular reasoning detected by π₁ ≠ 0; (2) unjustified inference detected by π₀ (disconnection); (3) inconsistent justifications detected by π₂ (incoherent 2-cells); (4) fabricated entity chains detected by Hₙ ≠ 0 (homological holes); and (5) compositional drift detected by non-trivial holonomy on the semantic fibration. We prove the Fundamental Obstruction Theorem: no faithful functor exists from a semantically non-trivial category to a contractible codomain. We formulate the Univalence Constraint showing that statistical similarity does not entail semantic equivalence. We bridge theory to practice via persistent homology on Vietoris–Rips filtrations and provide a complete Haskell formalization with executable detectors for all five hallucination types.`,
    pages: 23,
    keyResult: '5 hallucination types ↔ homotopy invariants (π₀, π₁, π₂, Hₙ, holonomy)',
    category: 'cs.AI / math.AT',
    ogImage: '/images/og/topological-hallucination-detection-og.png',
  },
  {
    slug: 'type-theoretic-generation',
    title: 'Type-Theoretic Generation: Hallucination-Free Language Generation via Dependent Type Theory',
    part: 'Part II',
    partNumber: 2,
    abstract: `We develop a foundational framework for hallucination-free language generation grounded in dependent type theory and categorical semantics. Our central thesis is that language generation should be reconceived as type inhabitation rather than statistical sampling: instead of computing argmax P(t | ctx), a correct language model computes argmin C(a) subject to the constraint Γ ⊢ a : A, where C is a cost function and the constraint enforces type-correctness in a dependent type theory of semantic meaning. We establish five generation principles that jointly guarantee hallucination freedom: (1) Generation as Type Inhabitation, recasting next-token prediction as proof search; (2) Certified Derivations, equipping every generated term with a polynomial-time-checkable derivation tree via the Curry–Howard correspondence; (3) Abstention on Empty Types, replacing hallucination with the type-theoretically correct response ⊥ when the goal type is uninhabited; (4) Context as Fibration, modeling the context window as a dependent telescope forming a fibration p: E → B; and (5) Attention as Weighted Limit, replacing softmax-weighted sums in Vect with weighted limits in the semantic category Sem. We prove that this framework is sound (every generated term is semantically valid) and complete relative to the knowledge base (every derivable claim is generable). The framework is formalized in Haskell with GADTs and dependent types, providing executable specifications for all core constructs.`,
    pages: 24,
    keyResult: '5 generation principles replacing sampling with proof search',
    category: 'cs.AI / math.LO',
    ogImage: '/images/og/type-theoretic-generation-og.png',
  },
  {
    slug: 'hott-synthesis',
    title: 'The HoTT Hallucination Framework: A Unified Theory of Semantic Correctness via Homotopy Type Theory',
    part: 'Part III',
    partNumber: 3,
    abstract: `We present a unified framework for semantic correctness in large language models (LLMs) that synthesizes two complementary research threads: topological detection of hallucination via homotopy groups and homology, and type-theoretic generation via certified inhabitation search in Homotopy Type Theory (HoTT). Our central construction is the detection-generation duality: detection is the problem of checking whether a global section of a semantic sheaf exists, while generation is the problem of constructing such a section. We prove these operations form an adjoint pair Generate ⊣ Detect on the semantic category Sem, and that the composite T = Detect ∘ Generate is a monad on Sem—the semantic monad—whose unit maps semantic types to their verified versions and whose multiplication collapses redundant verification. We formalize the ambient mathematical universe as an ∞-topos of semantic types, where objects are homotopy types, morphisms are certified derivations, and the internal logic is HoTT itself. Within this framework, we prove the Completeness Theorem: the Hallucination–Homotopy Correspondence (HHC) together with type-theoretic generation yields a complete system in which every hallucination is detected and generation never produces undetected hallucinations. We provide a concrete proof-of-concept architecture wrapping an LLM with a type-checking layer implementing a generate-check-abstain loop, with persistent homology for real-time topological monitoring. The framework is formalized in Haskell.`,
    pages: 28,
    keyResult: 'Detection-generation adjunction, semantic monad T = Detect ∘ Generate, Completeness Theorem',
    category: 'cs.AI / math.AT',
    ogImage: '/images/og/hott-synthesis-og.png',
    coverImage: '/images/covers/hott-synthesis-cover.png',
  },
];

export function getPaperBySlug(slug: string): Paper | undefined {
  return papers.find((p) => p.slug === slug);
}
