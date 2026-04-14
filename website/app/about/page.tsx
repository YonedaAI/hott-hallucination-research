import type { Metadata } from 'next';
import Link from 'next/link';
import { papers } from '../../lib/papers';

export const metadata: Metadata = {
  title: 'About — YonedaAI Research Collective',
  description:
    'About the Homotopical Semantics Trilogy, YonedaAI Research Collective, and Magneton Labs LLC.',
};

export default function AboutPage() {
  return (
    <>
      {/* Hero */}
      <section
        className="hero-section"
        style={{ padding: '5rem 1.5rem 4rem', borderBottom: '1px solid var(--border)' }}
      >
        <div className="hero-grid" aria-hidden="true" />
        <div style={{ maxWidth: '800px', margin: '0 auto', position: 'relative', zIndex: 1 }}>
          <div className="part-badge" style={{ marginBottom: '1.5rem' }}>
            About
          </div>
          <h1
            style={{
              fontSize: 'clamp(1.8rem, 4vw, 2.75rem)',
              fontWeight: 800,
              letterSpacing: '-0.02em',
              color: 'var(--text)',
              marginBottom: '1rem',
              lineHeight: 1.2,
            }}
          >
            YonedaAI Research Collective
          </h1>
          <p
            style={{
              fontSize: '1.05rem',
              color: 'var(--text-muted)',
              lineHeight: 1.7,
              marginBottom: '1.5rem',
            }}
          >
            An independent research initiative developing rigorous mathematical foundations
            for understanding and eliminating hallucination in large language models.
          </p>
          <p className="tagline-quote">
            &ldquo;Hallucination is not a bug &mdash; it&rsquo;s a theorem.&rdquo;
          </p>
        </div>
      </section>

      <div style={{ maxWidth: '900px', margin: '0 auto', padding: '4rem 1.5rem' }}>
        {/* Mission */}
        <section style={{ marginBottom: '4rem' }}>
          <h2
            style={{
              fontSize: '1.35rem',
              fontWeight: 700,
              color: 'var(--text)',
              marginBottom: '1.25rem',
              paddingBottom: '0.5rem',
              borderBottom: '1px solid var(--border)',
            }}
          >
            The Central Thesis
          </h2>
          <p style={{ fontSize: '0.95rem', color: 'var(--text-muted)', lineHeight: 1.8, marginBottom: '1rem' }}>
            Every contemporary large language model implements a functor{' '}
            <code
              style={{
                background: 'rgba(168,85,247,0.12)',
                color: 'var(--accent-hover)',
                padding: '2px 6px',
                borderRadius: '4px',
                fontFamily: 'monospace',
              }}
            >
              F: Sem → Vect_R
            </code>{' '}
            from the semantic category (an ∞-groupoid with non-trivial homotopy groups) to
            finite-dimensional real vector spaces (a contractible space where all topological
            obstructions vanish). This functor necessarily collapses the higher categorical
            structure of meaning.
          </p>
          <p style={{ fontSize: '0.95rem', color: 'var(--text-muted)', lineHeight: 1.8, marginBottom: '1rem' }}>
            This collapse is not a flaw in any particular model — it is a structural
            inevitability. The Fundamental Obstruction Theorem establishes that{' '}
            <em style={{ color: 'var(--accent-secondary)' }}>
              no faithful functor exists from a semantically non-trivial category to a
              contractible codomain
            </em>
            . Hallucination is a theorem.
          </p>
          <p style={{ fontSize: '0.95rem', color: 'var(--text-muted)', lineHeight: 1.8 }}>
            The solution is not better statistics but richer mathematics: replacing the
            contractible codomain Vect with the ∞-topos Sem_∞, and replacing probabilistic
            generation with certified type inhabitation. The three papers develop this
            solution systematically.
          </p>
        </section>

        {/* The trilogy */}
        <section style={{ marginBottom: '4rem' }}>
          <h2
            style={{
              fontSize: '1.35rem',
              fontWeight: 700,
              color: 'var(--text)',
              marginBottom: '1.25rem',
              paddingBottom: '0.5rem',
              borderBottom: '1px solid var(--border)',
            }}
          >
            The Trilogy
          </h2>
          <div style={{ display: 'flex', flexDirection: 'column', gap: '1rem' }}>
            {papers.map((paper) => (
              <div
                key={paper.slug}
                style={{
                  background: 'var(--surface)',
                  border: '1px solid var(--border)',
                  borderRadius: '10px',
                  padding: '1.25rem',
                  display: 'flex',
                  gap: '1.25rem',
                  alignItems: 'flex-start',
                }}
              >
                <div
                  style={{
                    minWidth: '40px',
                    height: '40px',
                    borderRadius: '8px',
                    background: 'var(--accent-glow)',
                    border: '1px solid var(--border)',
                    display: 'flex',
                    alignItems: 'center',
                    justifyContent: 'center',
                    fontWeight: 800,
                    color: 'var(--accent)',
                    fontSize: '1rem',
                  }}
                >
                  {paper.partNumber}
                </div>
                <div style={{ flex: 1 }}>
                  <div
                    style={{
                      fontSize: '0.72rem',
                      color: 'var(--accent)',
                      fontWeight: 700,
                      textTransform: 'uppercase',
                      letterSpacing: '0.1em',
                      marginBottom: '4px',
                    }}
                  >
                    {paper.part} &middot; {paper.pages} pages
                  </div>
                  <Link
                    href={`/papers/${paper.slug}/`}
                    style={{
                      fontWeight: 700,
                      color: 'var(--text)',
                      textDecoration: 'none',
                      fontSize: '0.95rem',
                      display: 'block',
                      marginBottom: '4px',
                    }}
                  >
                    {paper.title}
                  </Link>
                  <div className="key-result" style={{ fontSize: '0.78rem', marginTop: '8px' }}>
                    {paper.keyResult}
                  </div>
                </div>
                <div style={{ display: 'flex', gap: '8px', flexShrink: 0 }}>
                  <Link href={`/papers/${paper.slug}/`} className="btn-secondary" style={{ padding: '6px 14px', fontSize: '0.8rem' }}>
                    Read
                  </Link>
                  <a href={`/pdf/${paper.slug}.pdf`} className="btn-pdf" download style={{ padding: '6px 14px', fontSize: '0.8rem' }}>
                    PDF
                  </a>
                </div>
              </div>
            ))}
          </div>
        </section>

        {/* Author */}
        <section style={{ marginBottom: '4rem' }}>
          <h2
            style={{
              fontSize: '1.35rem',
              fontWeight: 700,
              color: 'var(--text)',
              marginBottom: '1.25rem',
              paddingBottom: '0.5rem',
              borderBottom: '1px solid var(--border)',
            }}
          >
            Author
          </h2>
          <div
            style={{
              background: 'var(--surface)',
              border: '1px solid var(--border)',
              borderRadius: '12px',
              padding: '2rem',
            }}
          >
            <div style={{ fontWeight: 800, fontSize: '1.3rem', color: 'var(--text)', marginBottom: '0.35rem' }}>
              Matthew Long
            </div>
            <div style={{ fontSize: '0.875rem', color: 'var(--accent)', marginBottom: '1rem' }}>
              YonedaAI Research Collective &middot; Magneton Labs LLC
            </div>
            <p style={{ fontSize: '0.9rem', color: 'var(--text-muted)', lineHeight: 1.7, marginBottom: '1rem' }}>
              Matthew Long is the founder of Magneton Labs LLC and lead researcher at the
              YonedaAI Research Collective, a Chicago-based independent research initiative
              focused on the mathematical foundations of artificial intelligence. His work
              applies tools from algebraic topology, category theory, and homotopy type
              theory to fundamental problems in machine learning.
            </p>
            <p style={{ fontSize: '0.9rem', color: 'var(--text-muted)', lineHeight: 1.7 }}>
              The Homotopical Semantics Trilogy — three papers totalling 75 pages —
              represents the first complete mathematical framework proving that LLM
              hallucination is a structural theorem, not a statistical accident, and
              providing both a rigorous detection criterion and a certified generation
              alternative.
            </p>
          </div>
        </section>

        {/* Organization */}
        <section style={{ marginBottom: '4rem' }}>
          <h2
            style={{
              fontSize: '1.35rem',
              fontWeight: 700,
              color: 'var(--text)',
              marginBottom: '1.25rem',
              paddingBottom: '0.5rem',
              borderBottom: '1px solid var(--border)',
            }}
          >
            Organizations
          </h2>
          <div
            style={{
              display: 'grid',
              gridTemplateColumns: 'repeat(auto-fit, minmax(280px, 1fr))',
              gap: '1.25rem',
            }}
          >
            <div
              style={{
                background: 'var(--accent-glow)',
                border: '1px solid var(--border)',
                borderRadius: '10px',
                padding: '1.5rem',
              }}
            >
              <div style={{ fontWeight: 700, color: 'var(--text)', marginBottom: '0.35rem' }}>
                YonedaAI Research Collective
              </div>
              <p style={{ fontSize: '0.85rem', color: 'var(--text-muted)', lineHeight: 1.6 }}>
                An independent research collective dedicated to applying modern mathematics —
                category theory, homotopy theory, and type theory — to foundational questions
                in artificial intelligence. Named after the Yoneda Lemma, the fundamental
                result of category theory.
              </p>
            </div>
            <div
              style={{
                background: 'rgba(245,158,11,0.07)',
                border: '1px solid rgba(245,158,11,0.2)',
                borderRadius: '10px',
                padding: '1.5rem',
              }}
            >
              <div style={{ fontWeight: 700, color: 'var(--text)', marginBottom: '0.35rem' }}>
                Magneton Labs LLC
              </div>
              <div style={{ fontSize: '0.75rem', color: 'var(--text-dim)', marginBottom: '0.5rem' }}>
                Chicago, IL
              </div>
              <p style={{ fontSize: '0.85rem', color: 'var(--text-muted)', lineHeight: 1.6 }}>
                Research and development company focused on mathematically-grounded approaches
                to AI safety and reliability. Publisher of the Homotopical Semantics Trilogy.
              </p>
            </div>
          </div>
        </section>

        {/* Key concepts */}
        <section>
          <h2
            style={{
              fontSize: '1.35rem',
              fontWeight: 700,
              color: 'var(--text)',
              marginBottom: '1.25rem',
              paddingBottom: '0.5rem',
              borderBottom: '1px solid var(--border)',
            }}
          >
            Mathematical Background
          </h2>
          <p style={{ fontSize: '0.9rem', color: 'var(--text-muted)', lineHeight: 1.7, marginBottom: '1.25rem' }}>
            The framework draws on three mathematical traditions:
          </p>
          <div style={{ display: 'flex', flexDirection: 'column', gap: '1rem' }}>
            {[
              {
                title: 'Algebraic Topology',
                color: 'var(--success)',
                colorBg: 'rgba(34,211,238,0.08)',
                colorBorder: 'rgba(34,211,238,0.2)',
                desc: 'Homotopy groups π_n, homology H_n, persistent homology, simplicial complexes, Vietoris–Rips filtrations. Used in Part I to classify the five hallucination types as topological invariants of the semantic knowledge complex.',
              },
              {
                title: 'Dependent Type Theory',
                color: 'var(--accent)',
                colorBg: 'var(--accent-glow)',
                colorBorder: 'var(--border)',
                desc: 'Martin-Löf type theory, the Curry–Howard correspondence, proof search, type inhabitation, fibrations, dependent telescopes. Used in Part II to replace statistical sampling with certified proof construction.',
              },
              {
                title: 'Higher Topos Theory',
                color: 'var(--accent-secondary)',
                colorBg: 'rgba(245,158,11,0.07)',
                colorBorder: 'rgba(245,158,11,0.2)',
                desc: '∞-categories, ∞-toposes, adjoint functors, monads, sheaf cohomology, descent. Used in Part III to unify the topological and type-theoretic perspectives and prove the Completeness Theorem.',
              },
            ].map(({ title, color, colorBg, colorBorder, desc }) => (
              <div
                key={title}
                style={{
                  background: colorBg,
                  border: `1px solid ${colorBorder}`,
                  borderRadius: '10px',
                  padding: '1.25rem',
                  display: 'grid',
                  gridTemplateColumns: '160px 1fr',
                  gap: '1rem',
                  alignItems: 'start',
                }}
              >
                <div style={{ fontWeight: 700, color, fontSize: '0.9rem' }}>{title}</div>
                <p style={{ fontSize: '0.85rem', color: 'var(--text-muted)', lineHeight: 1.6, margin: 0 }}>
                  {desc}
                </p>
              </div>
            ))}
          </div>
        </section>
      </div>
    </>
  );
}
