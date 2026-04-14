import Link from 'next/link';
import Image from 'next/image';
import { papers } from '../lib/papers';

export default function HomePage() {
  return (
    <>
      {/* Hero */}
      <section className="hero-section" style={{ padding: '6rem 1.5rem 5rem' }}>
        <div className="hero-grid" aria-hidden="true" />
        <div style={{ maxWidth: '1200px', margin: '0 auto', position: 'relative', zIndex: 1 }}>
          {/* Org label */}
          <div
            style={{
              display: 'inline-flex',
              alignItems: 'center',
              gap: '8px',
              background: 'var(--accent-glow)',
              border: '1px solid var(--border)',
              borderRadius: '100px',
              padding: '4px 16px',
              marginBottom: '1.5rem',
              fontSize: '0.78rem',
              fontWeight: 600,
              color: 'var(--accent)',
              letterSpacing: '0.05em',
            }}
          >
            <span
              style={{
                width: 8,
                height: 8,
                borderRadius: '50%',
                background: 'var(--accent)',
                display: 'inline-block',
                boxShadow: '0 0 6px var(--accent)',
              }}
            />
            YonedaAI Research Collective &mdash; April 2026
          </div>

          {/* Title */}
          <h1
            style={{
              fontSize: 'clamp(2rem, 5vw, 3.25rem)',
              fontWeight: 800,
              lineHeight: 1.15,
              letterSpacing: '-0.02em',
              color: 'var(--text)',
              maxWidth: '800px',
              marginBottom: '1.5rem',
            }}
          >
            The Homotopical{' '}
            <span
              style={{
                background: 'linear-gradient(135deg, var(--accent), #c084fc)',
                WebkitBackgroundClip: 'text',
                WebkitTextFillColor: 'transparent',
                backgroundClip: 'text',
              }}
            >
              Semantics Trilogy
            </span>
          </h1>

          {/* Tagline */}
          <p
            style={{
              fontSize: '1.15rem',
              color: 'var(--text-muted)',
              maxWidth: '680px',
              marginBottom: '0.75rem',
              lineHeight: 1.6,
            }}
          >
            A complete mathematical framework for understanding, detecting, and preventing
            LLM hallucination through algebraic topology, dependent type theory,
            and homotopy type theory.
          </p>

          <p className="tagline-quote" style={{ marginBottom: '2.5rem', maxWidth: '480px' }}>
            &ldquo;Hallucination is not a bug &mdash; it&rsquo;s a theorem.&rdquo;
          </p>

          {/* Stats row */}
          <div
            style={{
              display: 'flex',
              flexWrap: 'wrap',
              gap: '2.5rem',
              paddingTop: '0.5rem',
            }}
          >
            {[
              { num: '3', label: 'Research Papers' },
              { num: '75', label: 'Total Pages' },
              { num: '26', label: 'Key Theorems' },
              { num: '∞', label: 'Topos Structure' },
            ].map(({ num, label }) => (
              <div key={label}>
                <div className="stat-number" style={{ fontSize: '1.8rem' }}>
                  {num}
                </div>
                <div style={{ fontSize: '0.78rem', color: 'var(--text-dim)', marginTop: '2px' }}>
                  {label}
                </div>
              </div>
            ))}
          </div>
        </div>
      </section>

      {/* Papers grid */}
      <section
        style={{
          maxWidth: '1200px',
          margin: '0 auto',
          padding: '4rem 1.5rem',
        }}
      >
        <div style={{ marginBottom: '2.5rem' }}>
          <h2
            style={{
              fontSize: '1.35rem',
              fontWeight: 700,
              color: 'var(--text)',
              marginBottom: '0.5rem',
            }}
          >
            Research Papers
          </h2>
          <p style={{ fontSize: '0.9rem', color: 'var(--text-muted)' }}>
            Three papers forming a logically tight trilogy — Part I diagnoses, Part II prescribes, Part III unifies.
          </p>
        </div>

        <div
          style={{
            display: 'grid',
            gridTemplateColumns: 'repeat(auto-fill, minmax(340px, 1fr))',
            gap: '1.5rem',
          }}
        >
          {papers.map((paper) => (
            <article key={paper.slug} className="paper-card">
              {/* OG image as cover */}
              <div
                style={{
                  position: 'relative',
                  height: '180px',
                  overflow: 'hidden',
                  background: 'var(--code-bg)',
                }}
              >
                <Image
                  src={paper.ogImage}
                  alt={`Cover for ${paper.title}`}
                  fill
                  style={{ objectFit: 'cover', objectPosition: 'center top' }}
                  unoptimized
                />
                {/* Overlay gradient */}
                <div
                  style={{
                    position: 'absolute',
                    inset: 0,
                    background:
                      'linear-gradient(to bottom, transparent 40%, var(--surface) 100%)',
                  }}
                />
                {/* Part badge overlay */}
                <div
                  style={{ position: 'absolute', top: '12px', left: '12px' }}
                >
                  <span className="part-badge">{paper.part}</span>
                </div>
              </div>

              {/* Card body */}
              <div style={{ padding: '1.25rem' }}>
                <div
                  style={{
                    display: 'flex',
                    alignItems: 'center',
                    gap: '8px',
                    marginBottom: '0.75rem',
                  }}
                >
                  <span className="category-tag">{paper.category}</span>
                  <span
                    style={{ fontSize: '0.75rem', color: 'var(--text-dim)' }}
                  >
                    {paper.pages} pages
                  </span>
                </div>

                <h3
                  style={{
                    fontSize: '1rem',
                    fontWeight: 700,
                    color: 'var(--text)',
                    lineHeight: 1.4,
                    marginBottom: '0.75rem',
                  }}
                >
                  {paper.title}
                </h3>

                <p
                  style={{
                    fontSize: '0.85rem',
                    color: 'var(--text-muted)',
                    lineHeight: 1.6,
                    marginBottom: '0.75rem',
                    display: '-webkit-box',
                    WebkitLineClamp: 3,
                    WebkitBoxOrient: 'vertical',
                    overflow: 'hidden',
                  }}
                >
                  {paper.abstract.slice(0, 200)}...
                </p>

                <div className="key-result" style={{ marginBottom: '1.25rem' }}>
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

                {/* Actions */}
                <div style={{ display: 'flex', gap: '8px', flexWrap: 'wrap' }}>
                  <Link
                    href={`/papers/${paper.slug}/`}
                    className="btn-primary"
                    style={{ flex: '1', justifyContent: 'center', minWidth: '100px' }}
                  >
                    <svg width="15" height="15" viewBox="0 0 15 15" fill="none" aria-hidden="true">
                      <path d="M7.5 1L13 7.5L7.5 14M2 7.5h11" stroke="currentColor" strokeWidth="1.5" strokeLinecap="round" strokeLinejoin="round"/>
                    </svg>
                    Read
                  </Link>
                  <a
                    href={`/pdf/${paper.slug}.pdf`}
                    className="btn-pdf"
                    download
                  >
                    <svg width="15" height="15" viewBox="0 0 15 15" fill="none" aria-hidden="true">
                      <path d="M7.5 1v9m0 0L4 6.5m3.5 3.5L11 6.5M1 13h13" stroke="currentColor" strokeWidth="1.5" strokeLinecap="round" strokeLinejoin="round"/>
                    </svg>
                    PDF
                  </a>
                </div>
              </div>
            </article>
          ))}
        </div>
      </section>

      {/* Trilogy overview */}
      <section
        style={{
          background: 'var(--surface)',
          borderTop: '1px solid var(--border)',
          borderBottom: '1px solid var(--border)',
        }}
      >
        <div
          style={{
            maxWidth: '1200px',
            margin: '0 auto',
            padding: '4rem 1.5rem',
          }}
        >
          <h2
            style={{
              fontSize: '1.35rem',
              fontWeight: 700,
              color: 'var(--text)',
              marginBottom: '0.5rem',
            }}
          >
            The Logical Architecture
          </h2>
          <p
            style={{
              fontSize: '0.9rem',
              color: 'var(--text-muted)',
              marginBottom: '2.5rem',
              maxWidth: '600px',
            }}
          >
            Each paper builds on the previous, revealing an emergent structure only visible
            when all three are read together.
          </p>

          <div
            style={{
              display: 'grid',
              gridTemplateColumns: 'repeat(auto-fit, minmax(280px, 1fr))',
              gap: '1.5rem',
            }}
          >
            {[
              {
                part: 'Part I',
                label: 'Diagnosis',
                title: 'Topological Detection',
                color: 'var(--success)',
                colorBg: 'rgba(34,211,238,0.08)',
                colorBorder: 'rgba(34,211,238,0.25)',
                desc: 'Hallucination is structurally inevitable in any system mapping semantic space to a contractible codomain. Five failure modes ↔ five topological invariants.',
              },
              {
                part: 'Part II',
                label: 'Prescription',
                title: 'Type-Theoretic Generation',
                color: 'var(--accent)',
                colorBg: 'var(--accent-glow)',
                colorBorder: 'var(--border)',
                desc: 'Replace statistical sampling with type inhabitation. Five generation principles jointly guarantee hallucination-free output via proof search.',
              },
              {
                part: 'Part III',
                label: 'Unification',
                title: 'HoTT Synthesis',
                color: 'var(--accent-secondary)',
                colorBg: 'rgba(245,158,11,0.08)',
                colorBorder: 'rgba(245,158,11,0.25)',
                desc: 'Detection and generation form an adjoint pair. The semantic monad T = Detect∘Generate proves the Completeness Theorem — every hallucination is caught.',
              },
            ].map(({ part, label, title, color, colorBg, colorBorder, desc }) => (
              <div
                key={part}
                style={{
                  background: colorBg,
                  border: `1px solid ${colorBorder}`,
                  borderRadius: '10px',
                  padding: '1.25rem',
                }}
              >
                <div
                  style={{
                    display: 'flex',
                    alignItems: 'center',
                    gap: '8px',
                    marginBottom: '0.75rem',
                  }}
                >
                  <span
                    style={{
                      fontSize: '0.68rem',
                      fontWeight: 700,
                      color,
                      textTransform: 'uppercase',
                      letterSpacing: '0.1em',
                    }}
                  >
                    {part}
                  </span>
                  <span
                    style={{
                      fontSize: '0.68rem',
                      color: 'var(--text-dim)',
                      textTransform: 'uppercase',
                      letterSpacing: '0.1em',
                    }}
                  >
                    &mdash; {label}
                  </span>
                </div>
                <h3
                  style={{
                    fontSize: '1rem',
                    fontWeight: 700,
                    color: 'var(--text)',
                    marginBottom: '0.5rem',
                  }}
                >
                  {title}
                </h3>
                <p
                  style={{
                    fontSize: '0.85rem',
                    color: 'var(--text-muted)',
                    lineHeight: 1.6,
                  }}
                >
                  {desc}
                </p>
              </div>
            ))}
          </div>
        </div>
      </section>

      {/* Author CTA */}
      <section style={{ maxWidth: '1200px', margin: '0 auto', padding: '4rem 1.5rem' }}>
        <div
          style={{
            display: 'flex',
            flexWrap: 'wrap',
            alignItems: 'center',
            justifyContent: 'space-between',
            gap: '1.5rem',
            background: 'var(--surface)',
            border: '1px solid var(--border)',
            borderRadius: '14px',
            padding: '2rem 2.5rem',
          }}
        >
          <div>
            <div
              style={{
                fontSize: '0.75rem',
                fontWeight: 700,
                color: 'var(--accent)',
                textTransform: 'uppercase',
                letterSpacing: '0.1em',
                marginBottom: '0.4rem',
              }}
            >
              Author
            </div>
            <div
              style={{ fontSize: '1.15rem', fontWeight: 700, color: 'var(--text)' }}
            >
              Matthew Long
            </div>
            <div style={{ fontSize: '0.875rem', color: 'var(--text-muted)', marginTop: '2px' }}>
              YonedaAI Research Collective &middot; Magneton Labs LLC, Chicago IL
            </div>
          </div>
          <Link href="/about/" className="btn-primary">
            About the Research
          </Link>
        </div>
      </section>
    </>
  );
}
