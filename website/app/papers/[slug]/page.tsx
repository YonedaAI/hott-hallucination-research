import type { Metadata } from 'next';
import Link from 'next/link';
import Image from 'next/image';
import { papers, getPaperBySlug } from '../../../lib/papers';
import { TableOfContents } from '../../components/TableOfContents';

export async function generateStaticParams() {
  return papers.map((p) => ({ slug: p.slug }));
}

export async function generateMetadata({
  params,
}: {
  params: { slug: string };
}): Promise<Metadata> {
  const paper = getPaperBySlug(params.slug);
  if (!paper) return {};
  const description = paper.abstract.slice(0, 200) + '...';
  return {
    title: paper.title,
    description,
    openGraph: {
      title: paper.title,
      description,
      url: `/papers/${params.slug}`,
      images: [
        {
          url: paper.ogImage,
          width: 1200,
          height: 630,
          alt: `${paper.title} — YonedaAI`,
        },
      ],
      type: 'article',
      siteName: 'YonedaAI Research Collective',
      authors: ['Matthew Long'],
      publishedTime: '2026-04-14T00:00:00Z',
    },
    twitter: {
      card: 'summary_large_image',
      title: paper.title,
      description,
      images: [paper.ogImage],
      creator: '@yonedaai',
    },
  };
}

function PaperKeyTheorems({ slug }: { slug: string }) {
  const theorems: Record<string, { title: string; statement: string; type: string }[]> = {
    'topological-hallucination-detection': [
      {
        type: 'Theorem',
        title: 'Fundamental Obstruction Theorem (Theorem 4.1)',
        statement:
          'Let C be a category whose geometric realization |N(C)| is contractible (i.e., all homotopy groups vanish). Then no faithful functor F: Sem → C exists, where Sem is the semantic ∞-groupoid with non-trivial homotopy groups. In particular, no current LLM architecture — which implements F: Lang → Vect_R with Vect_R contractible — can faithfully represent semantic structure.',
      },
      {
        type: 'Theorem',
        title: 'Hallucination-Homology Theorem (Theorem 2.7)',
        statement:
          'Let K• be the simplicial knowledge complex. A claim σ is hallucinated if and only if [σ] ≠ 0 in H_n(K•; ℤ) for some n ≥ 0. Equivalently, σ is semantically valid if and only if σ represents a homological boundary — every n-dimensional inference pattern closes into a cycle of justified entailments.',
      },
      {
        type: 'Theorem',
        title: 'Persistent Hallucination Detection (Theorem 6.1)',
        statement:
          'The persistent homology PH(K•(ε)) of the Vietoris–Rips filtration provides a computable, stable invariant of the knowledge complex. A hallucination is detected as a persistent class: a homological feature that is born at scale ε₁ and does not die before scale ε₂ > ε₁, with lifetime (ε₂ − ε₁) > threshold.',
      },
    ],
    'type-theoretic-generation': [
      {
        type: 'Theorem',
        title: 'Soundness of Type-Theoretic Generation (Theorem 3.2)',
        statement:
          'Let Γ ⊢ a : A be a judgment derivable in T_Sem with derivation δ. Then a is semantically valid: the claim a is a grounded, non-hallucinated statement. More precisely, for every interpretation ⟦·⟧: T_Sem → Sem, we have ⟦a⟧ ∈ ⟦A⟧.',
      },
      {
        type: 'Theorem',
        title: 'Correct Abstention Theorem (Theorem 5.1)',
        statement:
          'If the goal type A is provably uninhabited in T_Sem (i.e., A ≃ ∅), then the generation procedure terminates with output ⊥ ("I cannot answer"). This is the unique type-theoretically correct response when no valid claim of type A exists. Returning any non-⊥ answer would constitute a hallucination.',
      },
      {
        type: 'Theorem',
        title: 'Weighted Limit Coherence (Theorem 7.1)',
        statement:
          'The categorical attention mechanism lim^W D — the weighted limit of diagram D: J → Sem with weight W: J^op → Set — preserves semantic coherence: if D is a coherent diagram (all 2-cells are invertible), then lim^W D is a valid semantic type, and the canonical projections π_j: lim^W D → D(j) are certified derivations.',
      },
    ],
    'hott-synthesis': [
      {
        type: 'Theorem',
        title: 'Detection-Generation Adjunction (Theorem 3.1)',
        statement:
          'The functors Generate: Claim → Sem and Detect: Sem → Claim form an adjoint pair Generate ⊣ Detect. The unit η: id_Claim → Detect ∘ Generate maps each claim to its verified version; the counit ε: Generate ∘ Detect → id_Sem is the semantic projection. A claim ĉ is hallucinated if and only if the counit component ε_ĉ is not an isomorphism.',
      },
      {
        type: 'Theorem',
        title: 'The Completeness Theorem (Theorem 7.5)',
        statement:
          'The combined HoTT hallucination framework is complete. The following are equivalent for any claim c: (i) c is non-hallucinated; (ii) c is a fixed point of the semantic monad T = Detect ∘ Generate; (iii) the HHC obstruction class [c] ∈ H¹(K•, F) vanishes; (iv) the generate-check-abstain loop converges to c. In particular, every hallucination is detected (Detection Completeness) and generation never produces undetected hallucinations (Generation Soundness).',
      },
      {
        type: 'Theorem',
        title: 'Sem_∞ is an ∞-Topos (Theorem 5.1)',
        statement:
          'The semantic universe Sem_∞ of all semantic types, equipped with the Grothendieck topology from the knowledge complex K•, satisfies all axioms of an ∞-topos: it has finite limits, is locally presentable, and satisfies descent. The internal logic of Sem_∞ is Homotopy Type Theory, making HoTT the correct ambient logic for reasoning about semantic correctness.',
      },
    ],
  };

  const items = theorems[slug] ?? [];
  if (items.length === 0) return null;

  return (
    <div style={{ marginTop: '2.5rem' }}>
      <h2
        id="key-theorems"
        style={{
          fontSize: '1.35rem',
          fontWeight: 700,
          color: 'var(--text)',
          marginBottom: '1rem',
          paddingBottom: '0.5rem',
          borderBottom: '1px solid var(--border)',
          scrollMarginTop: '90px',
        }}
      >
        Key Theorems
      </h2>
      <div style={{ display: 'flex', flexDirection: 'column', gap: '1.25rem' }}>
        {items.map((t) => (
          <div
            key={t.title}
            style={{
              background: 'rgba(168,85,247,0.07)',
              border: '1px solid rgba(168,85,247,0.25)',
              borderLeft: '3px solid var(--accent)',
              borderRadius: '8px',
              padding: '1.1rem 1.25rem',
            }}
          >
            <div
              style={{
                fontSize: '0.7rem',
                fontWeight: 700,
                color: 'var(--accent)',
                textTransform: 'uppercase',
                letterSpacing: '0.1em',
                marginBottom: '4px',
              }}
            >
              {t.type}
            </div>
            <div
              style={{
                fontWeight: 700,
                color: 'var(--text)',
                marginBottom: '8px',
                fontSize: '0.95rem',
              }}
            >
              {t.title}
            </div>
            <p
              style={{
                fontSize: '0.875rem',
                color: 'var(--text-muted)',
                lineHeight: 1.7,
                margin: 0,
              }}
            >
              {t.statement}
            </p>
          </div>
        ))}
      </div>
    </div>
  );
}

function FiveCorrespondence({ slug }: { slug: string }) {
  if (slug === 'topological-hallucination-detection') {
    const rows = [
      { type: 'Circular reasoning', invariant: 'π₁ ≠ 0', desc: 'Non-contractible loop in semantic path space' },
      { type: 'Unjustified inference', invariant: 'π₀ disconnection', desc: 'No path between disconnected semantic components' },
      { type: 'Inconsistent justifications', invariant: 'π₂ ≠ 0', desc: 'Incoherent 2-cells: non-equivalent justification paths' },
      { type: 'Fabricated entity chain', invariant: 'Hₙ ≠ 0', desc: 'Homological hole — missing grounding simplex' },
      { type: 'Compositional drift', invariant: 'Holonomy ≠ id', desc: 'Non-trivial transport along semantic fibration' },
    ];
    return (
      <div style={{ marginTop: '2.5rem' }}>
        <h2
          id="homotopy-correspondence"
          style={{
            fontSize: '1.35rem',
            fontWeight: 700,
            color: 'var(--text)',
            marginBottom: '1rem',
            paddingBottom: '0.5rem',
            borderBottom: '1px solid var(--border)',
            scrollMarginTop: '90px',
          }}
        >
          Hallucination–Homotopy Correspondence
        </h2>
        <div style={{ overflowX: 'auto' }}>
          <table style={{ width: '100%', borderCollapse: 'collapse', fontSize: '0.875rem' }}>
            <thead>
              <tr>
                {['Hallucination Type', 'Topological Invariant', 'Geometric Meaning'].map((h) => (
                  <th
                    key={h}
                    style={{
                      background: 'var(--surface)',
                      color: 'var(--accent)',
                      fontWeight: 700,
                      padding: '10px 14px',
                      textAlign: 'left',
                      borderBottom: '2px solid var(--border)',
                    }}
                  >
                    {h}
                  </th>
                ))}
              </tr>
            </thead>
            <tbody>
              {rows.map((r, i) => (
                <tr key={i}>
                  <td style={{ padding: '9px 14px', borderBottom: '1px solid var(--border)', color: 'var(--text)', fontWeight: 600 }}>
                    {r.type}
                  </td>
                  <td style={{ padding: '9px 14px', borderBottom: '1px solid var(--border)', color: 'var(--accent-secondary)', fontFamily: 'monospace' }}>
                    {r.invariant}
                  </td>
                  <td style={{ padding: '9px 14px', borderBottom: '1px solid var(--border)', color: 'var(--text-muted)' }}>
                    {r.desc}
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      </div>
    );
  }

  if (slug === 'type-theoretic-generation') {
    const rows = [
      { principle: 'P1: Generation as Type Inhabitation', replaces: 'argmax P(t|ctx)', guarantee: 'Every output has a valid type derivation' },
      { principle: 'P2: Certified Derivations', replaces: 'Black-box generation', guarantee: 'O(|δ|·|A|) polynomial-time verifiable proof' },
      { principle: 'P3: Abstention on Empty Types', replaces: 'Forced hallucination', guarantee: 'Returns ⊥ when A is uninhabited' },
      { principle: 'P4: Context as Fibration', replaces: 'Flat token window', guarantee: 'Dependent telescope Γ = (x₁:A₁, x₂:A₂(x₁), ...)' },
      { principle: 'P5: Attention as Weighted Limit', replaces: 'Softmax in Vect', guarantee: 'Categorical coherence preserved under aggregation' },
    ];
    return (
      <div style={{ marginTop: '2.5rem' }}>
        <h2
          id="generation-principles"
          style={{
            fontSize: '1.35rem',
            fontWeight: 700,
            color: 'var(--text)',
            marginBottom: '1rem',
            paddingBottom: '0.5rem',
            borderBottom: '1px solid var(--border)',
            scrollMarginTop: '90px',
          }}
        >
          Five Generation Principles
        </h2>
        <div style={{ overflowX: 'auto' }}>
          <table style={{ width: '100%', borderCollapse: 'collapse', fontSize: '0.875rem' }}>
            <thead>
              <tr>
                {['Principle', 'Replaces', 'Guarantee'].map((h) => (
                  <th
                    key={h}
                    style={{
                      background: 'var(--surface)',
                      color: 'var(--accent)',
                      fontWeight: 700,
                      padding: '10px 14px',
                      textAlign: 'left',
                      borderBottom: '2px solid var(--border)',
                    }}
                  >
                    {h}
                  </th>
                ))}
              </tr>
            </thead>
            <tbody>
              {rows.map((r, i) => (
                <tr key={i}>
                  <td style={{ padding: '9px 14px', borderBottom: '1px solid var(--border)', color: 'var(--text)', fontWeight: 600 }}>
                    {r.principle}
                  </td>
                  <td style={{ padding: '9px 14px', borderBottom: '1px solid var(--border)', color: 'var(--text-dim)', fontFamily: 'monospace', fontSize: '0.82rem' }}>
                    {r.replaces}
                  </td>
                  <td style={{ padding: '9px 14px', borderBottom: '1px solid var(--border)', color: 'var(--text-muted)' }}>
                    {r.guarantee}
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      </div>
    );
  }

  if (slug === 'hott-synthesis') {
    const rows = [
      { detection: 'π₁ ≠ 0 (Circular reasoning)', generation: 'P1: Type Inhabitation', how: 'Proof search cannot produce non-contractible loops' },
      { detection: 'π₀ disconnection', generation: 'P3: Abstention on ∅', how: 'Inhabitation fails across semantic components; system abstains' },
      { detection: 'π₂ ≠ 0 (Inconsistent justifications)', generation: 'P2: Certified Derivations', how: 'Derivation tree makes justification structure explicit' },
      { detection: 'Hₙ ≠ 0 (Fabricated chains)', generation: 'P4: Context as Fibration', how: 'Fibered context prevents locally-consistent-but-globally-unfounded chains' },
      { detection: 'Holonomy ≠ id (Compositional drift)', generation: 'P5: Attention as Weighted Limit', how: 'Categorical attention detects non-trivial transport' },
    ];
    return (
      <div style={{ marginTop: '2.5rem' }}>
        <h2
          id="five-by-five-duality"
          style={{
            fontSize: '1.35rem',
            fontWeight: 700,
            color: 'var(--text)',
            marginBottom: '0.75rem',
            paddingBottom: '0.5rem',
            borderBottom: '1px solid var(--border)',
            scrollMarginTop: '90px',
          }}
        >
          Five-by-Five Duality Table
        </h2>
        <p style={{ fontSize: '0.875rem', color: 'var(--text-muted)', marginBottom: '1rem' }}>
          Each hallucination type (Part I) has a dual preventing generation principle (Part II). This correspondence is only visible when all three papers are read together.
        </p>
        <div style={{ overflowX: 'auto' }}>
          <table style={{ width: '100%', borderCollapse: 'collapse', fontSize: '0.875rem' }}>
            <thead>
              <tr>
                {['Detection Criterion (Part I)', 'Generation Principle (Part II)', 'Prevention Mechanism'].map((h) => (
                  <th
                    key={h}
                    style={{
                      background: 'var(--surface)',
                      color: 'var(--accent)',
                      fontWeight: 700,
                      padding: '10px 14px',
                      textAlign: 'left',
                      borderBottom: '2px solid var(--border)',
                    }}
                  >
                    {h}
                  </th>
                ))}
              </tr>
            </thead>
            <tbody>
              {rows.map((r, i) => (
                <tr key={i}>
                  <td style={{ padding: '9px 14px', borderBottom: '1px solid var(--border)', color: 'var(--success)', fontFamily: 'monospace', fontSize: '0.82rem' }}>
                    {r.detection}
                  </td>
                  <td style={{ padding: '9px 14px', borderBottom: '1px solid var(--border)', color: 'var(--accent)', fontWeight: 600 }}>
                    {r.generation}
                  </td>
                  <td style={{ padding: '9px 14px', borderBottom: '1px solid var(--border)', color: 'var(--text-muted)' }}>
                    {r.how}
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      </div>
    );
  }

  return null;
}

export default function PaperPage({ params }: { params: { slug: string } }) {
  const paper = getPaperBySlug(params.slug);
  if (!paper) return <div style={{ padding: '4rem', color: 'var(--text-muted)' }}>Paper not found.</div>;

  const idx = papers.findIndex((p) => p.slug === params.slug);
  const prev = idx > 0 ? papers[idx - 1] : null;
  const next = idx < papers.length - 1 ? papers[idx + 1] : null;

  const headings = [
    { id: 'abstract', text: 'Abstract', level: 2 },
    { id: 'key-theorems', text: 'Key Theorems', level: 2 },
    ...(paper.slug === 'topological-hallucination-detection'
      ? [{ id: 'homotopy-correspondence', text: 'HHC Table', level: 2 }]
      : paper.slug === 'type-theoretic-generation'
      ? [{ id: 'generation-principles', text: 'Generation Principles', level: 2 }]
      : paper.slug === 'hott-synthesis'
      ? [{ id: 'five-by-five-duality', text: 'Duality Table', level: 2 }]
      : []),
    { id: 'download', text: 'Download', level: 2 },
  ];

  return (
    <>
      {/* Paper hero */}
      <section
        style={{
          background: 'var(--surface)',
          borderBottom: '1px solid var(--border)',
          padding: '3rem 1.5rem',
        }}
      >
        <div style={{ maxWidth: '1200px', margin: '0 auto' }}>
          {/* Breadcrumb */}
          <div
            style={{
              display: 'flex',
              alignItems: 'center',
              gap: '6px',
              marginBottom: '1.5rem',
              fontSize: '0.82rem',
              color: 'var(--text-dim)',
            }}
          >
            <Link href="/" style={{ color: 'var(--accent)', textDecoration: 'none' }}>
              Research
            </Link>
            <span>/</span>
            <span style={{ color: 'var(--text-muted)' }}>{paper.part}</span>
          </div>

          <div
            style={{
              display: 'grid',
              gridTemplateColumns: paper.coverImage ? '1fr 200px' : '1fr',
              gap: '2rem',
              alignItems: 'start',
            }}
          >
            <div>
              <div style={{ display: 'flex', gap: '8px', flexWrap: 'wrap', marginBottom: '1rem' }}>
                <span className="part-badge">{paper.part}</span>
                <span className="category-tag">{paper.category}</span>
                <span
                  style={{
                    fontSize: '0.75rem',
                    color: 'var(--text-dim)',
                    alignSelf: 'center',
                  }}
                >
                  {paper.pages} pages
                </span>
              </div>

              <h1
                style={{
                  fontSize: 'clamp(1.4rem, 3vw, 2rem)',
                  fontWeight: 800,
                  color: 'var(--text)',
                  lineHeight: 1.25,
                  marginBottom: '1rem',
                  letterSpacing: '-0.015em',
                }}
              >
                {paper.title}
              </h1>

              <div style={{ fontSize: '0.9rem', color: 'var(--text-muted)', marginBottom: '0.4rem' }}>
                <strong style={{ color: 'var(--text)' }}>Matthew Long</strong>
              </div>
              <div style={{ fontSize: '0.82rem', color: 'var(--text-dim)', marginBottom: '1.5rem' }}>
                YonedaAI Research Collective &middot; Magneton Labs LLC &middot; April 2026
              </div>

              <div className="key-result" style={{ maxWidth: '600px', marginBottom: '1.5rem' }}>
                <span
                  style={{
                    fontSize: '0.68rem',
                    fontWeight: 700,
                    color: 'var(--text-dim)',
                    textTransform: 'uppercase',
                    letterSpacing: '0.07em',
                    display: 'block',
                    marginBottom: '2px',
                  }}
                >
                  Key result
                </span>
                {paper.keyResult}
              </div>

              <div style={{ display: 'flex', gap: '10px', flexWrap: 'wrap' }}>
                <a
                  href={`/pdf/${paper.slug}.pdf`}
                  className="btn-pdf"
                  download
                >
                  <svg width="15" height="15" viewBox="0 0 15 15" fill="none" aria-hidden="true">
                    <path d="M7.5 1v9m0 0L4 6.5m3.5 3.5L11 6.5M1 13h13" stroke="currentColor" strokeWidth="1.5" strokeLinecap="round" strokeLinejoin="round"/>
                  </svg>
                  Download PDF
                </a>
              </div>
            </div>

            {paper.coverImage && (
              <div
                style={{
                  position: 'relative',
                  height: '260px',
                  borderRadius: '10px',
                  overflow: 'hidden',
                  border: '1px solid var(--border)',
                }}
              >
                <Image
                  src={paper.coverImage}
                  alt={`Cover of ${paper.title}`}
                  fill
                  style={{ objectFit: 'cover' }}
                  unoptimized
                />
              </div>
            )}
          </div>
        </div>
      </section>

      {/* Content area */}
      <div
        style={{
          maxWidth: '1200px',
          margin: '0 auto',
          padding: '3rem 1.5rem',
          display: 'grid',
          gridTemplateColumns: '1fr 260px',
          gap: '3rem',
          alignItems: 'start',
        }}
        className="paper-layout"
      >
        {/* Main content */}
        <article>
          {/* Abstract */}
          <div>
            <h2
              id="abstract"
              style={{
                fontSize: '1.35rem',
                fontWeight: 700,
                color: 'var(--text)',
                marginBottom: '1rem',
                paddingBottom: '0.5rem',
                borderBottom: '1px solid var(--border)',
                scrollMarginTop: '90px',
              }}
            >
              Abstract
            </h2>
            <p
              style={{
                fontSize: '0.95rem',
                color: 'var(--text-muted)',
                lineHeight: 1.8,
              }}
            >
              {paper.abstract}
            </p>
          </div>

          {/* Key Theorems */}
          <PaperKeyTheorems slug={paper.slug} />

          {/* Five correspondence table */}
          <FiveCorrespondence slug={paper.slug} />

          {/* Download section */}
          <div
            id="download"
            style={{
              marginTop: '3rem',
              padding: '2rem',
              background: 'var(--surface)',
              border: '1px solid var(--border)',
              borderRadius: '12px',
              scrollMarginTop: '90px',
            }}
          >
            <h2
              style={{
                fontSize: '1.1rem',
                fontWeight: 700,
                color: 'var(--text)',
                marginBottom: '0.75rem',
              }}
            >
              Download Full Paper
            </h2>
            <p
              style={{
                fontSize: '0.875rem',
                color: 'var(--text-muted)',
                marginBottom: '1.25rem',
              }}
            >
              The complete {paper.pages}-page paper in PDF format, including all proofs,
              Haskell formalizations, and appendices.
            </p>
            <a
              href={`/pdf/${paper.slug}.pdf`}
              className="btn-pdf"
              download
              style={{ fontSize: '1rem', padding: '12px 28px' }}
            >
              <svg width="18" height="18" viewBox="0 0 18 18" fill="none" aria-hidden="true">
                <path d="M9 1v11m0 0L5 7.5m4 4.5L13 7.5M1 16h16" stroke="currentColor" strokeWidth="1.5" strokeLinecap="round" strokeLinejoin="round"/>
              </svg>
              Download PDF ({paper.pages} pages)
            </a>
          </div>

          {/* Prev / Next navigation */}
          <div
            style={{
              display: 'grid',
              gridTemplateColumns: prev && next ? '1fr 1fr' : '1fr',
              gap: '1rem',
              marginTop: '3rem',
            }}
          >
            {prev && (
              <Link href={`/papers/${prev.slug}/`} className="paper-nav-link">
                <svg width="16" height="16" viewBox="0 0 16 16" fill="none" stroke="currentColor" strokeWidth="1.5" strokeLinecap="round" aria-hidden="true">
                  <path d="M10 4L6 8l4 4" />
                </svg>
                <div>
                  <div style={{ fontSize: '0.68rem', color: 'var(--text-dim)', textTransform: 'uppercase', letterSpacing: '0.08em' }}>
                    Previous
                  </div>
                  <div style={{ fontWeight: 600, color: 'var(--text)', fontSize: '0.875rem' }}>
                    {prev.part}: {prev.title.split(':')[0]}
                  </div>
                </div>
              </Link>
            )}
            {next && (
              <Link
                href={`/papers/${next.slug}/`}
                className="paper-nav-link"
                style={{ justifyContent: prev ? 'flex-end' : 'flex-start', textAlign: prev ? 'right' : 'left' }}
              >
                <div>
                  <div style={{ fontSize: '0.68rem', color: 'var(--text-dim)', textTransform: 'uppercase', letterSpacing: '0.08em' }}>
                    Next
                  </div>
                  <div style={{ fontWeight: 600, color: 'var(--text)', fontSize: '0.875rem' }}>
                    {next.part}: {next.title.split(':')[0]}
                  </div>
                </div>
                <svg width="16" height="16" viewBox="0 0 16 16" fill="none" stroke="currentColor" strokeWidth="1.5" strokeLinecap="round" aria-hidden="true">
                  <path d="M6 4l4 4-4 4" />
                </svg>
              </Link>
            )}
          </div>
        </article>

        {/* Sidebar TOC */}
        <aside className="paper-sidebar">
          <TableOfContents headings={headings} />

          {/* Quick info */}
          <div
            style={{
              marginTop: '2rem',
              padding: '1rem',
              background: 'var(--surface)',
              border: '1px solid var(--border)',
              borderRadius: '10px',
              fontSize: '0.8rem',
            }}
          >
            <div style={{ fontWeight: 700, color: 'var(--accent)', marginBottom: '0.75rem', fontSize: '0.7rem', textTransform: 'uppercase', letterSpacing: '0.1em' }}>
              Paper Info
            </div>
            {[
              { label: 'Series', value: 'Homotopical Semantics Trilogy' },
              { label: 'Part', value: paper.part },
              { label: 'Pages', value: String(paper.pages) },
              { label: 'Category', value: paper.category },
              { label: 'Published', value: 'April 2026' },
              { label: 'Platform', value: 'GrokRxiv' },
            ].map(({ label, value }) => (
              <div
                key={label}
                style={{
                  display: 'flex',
                  justifyContent: 'space-between',
                  gap: '8px',
                  padding: '5px 0',
                  borderBottom: '1px solid var(--border)',
                }}
              >
                <span style={{ color: 'var(--text-dim)' }}>{label}</span>
                <span style={{ color: 'var(--text-muted)', fontWeight: 500, textAlign: 'right' }}>
                  {value}
                </span>
              </div>
            ))}
          </div>
        </aside>
      </div>

      <style>{`
        .paper-layout {
          grid-template-columns: 1fr 260px;
        }
        @media (max-width: 1023px) {
          .paper-layout {
            grid-template-columns: 1fr !important;
          }
          .paper-sidebar {
            order: -1;
            position: static !important;
            max-height: none !important;
            overflow-y: visible !important;
          }
        }
      `}</style>
    </>
  );
}
