import Link from 'next/link';

export default function Footer() {
  return (
    <footer className="site-footer" style={{ marginTop: '5rem' }}>
      <div
        style={{
          maxWidth: '1200px',
          margin: '0 auto',
          padding: '3rem 1.5rem 2rem',
        }}
      >
        <div
          style={{
            display: 'grid',
            gridTemplateColumns: 'repeat(auto-fit, minmax(220px, 1fr))',
            gap: '2.5rem',
            marginBottom: '2.5rem',
          }}
        >
          {/* Brand */}
          <div>
            <div
              style={{
                fontSize: '1rem',
                fontWeight: 700,
                color: 'var(--text)',
                marginBottom: '0.5rem',
              }}
            >
              YonedaAI Research Collective
            </div>
            <div
              style={{
                fontSize: '0.8rem',
                color: 'var(--text-dim)',
                marginBottom: '0.75rem',
              }}
            >
              Magneton Labs LLC — Chicago, IL
            </div>
            <p
              className="tagline-quote"
              style={{ fontSize: '0.82rem', marginTop: '0.75rem' }}
            >
              &ldquo;Hallucination is not a bug &mdash; it&rsquo;s a theorem.&rdquo;
            </p>
          </div>

          {/* Papers */}
          <div>
            <div
              style={{
                fontSize: '0.75rem',
                fontWeight: 700,
                color: 'var(--accent)',
                textTransform: 'uppercase',
                letterSpacing: '0.1em',
                marginBottom: '0.75rem',
              }}
            >
              Papers
            </div>
            <div
              style={{ display: 'flex', flexDirection: 'column', gap: '0.5rem' }}
            >
              <Link
                href="/papers/topological-hallucination-detection/"
                style={{
                  fontSize: '0.82rem',
                  color: 'var(--text-muted)',
                  textDecoration: 'none',
                }}
              >
                Part I: Topological Detection
              </Link>
              <Link
                href="/papers/type-theoretic-generation/"
                style={{
                  fontSize: '0.82rem',
                  color: 'var(--text-muted)',
                  textDecoration: 'none',
                }}
              >
                Part II: Type-Theoretic Generation
              </Link>
              <Link
                href="/papers/hott-synthesis/"
                style={{
                  fontSize: '0.82rem',
                  color: 'var(--text-muted)',
                  textDecoration: 'none',
                }}
              >
                Part III: HoTT Synthesis
              </Link>
            </div>
          </div>

          {/* Links */}
          <div>
            <div
              style={{
                fontSize: '0.75rem',
                fontWeight: 700,
                color: 'var(--accent)',
                textTransform: 'uppercase',
                letterSpacing: '0.1em',
                marginBottom: '0.75rem',
              }}
            >
              Resources
            </div>
            <div
              style={{ display: 'flex', flexDirection: 'column', gap: '0.5rem' }}
            >
              <Link
                href="/about/"
                style={{
                  fontSize: '0.82rem',
                  color: 'var(--text-muted)',
                  textDecoration: 'none',
                }}
              >
                About the Research
              </Link>
              <a
                href="https://magnetonlabs.com"
                target="_blank"
                rel="noopener noreferrer"
                style={{
                  fontSize: '0.82rem',
                  color: 'var(--text-muted)',
                  textDecoration: 'none',
                }}
              >
                Magneton Labs LLC
              </a>
            </div>
          </div>
        </div>

        {/* Bottom bar */}
        <div
          style={{
            borderTop: '1px solid var(--border)',
            paddingTop: '1.5rem',
            display: 'flex',
            flexWrap: 'wrap',
            justifyContent: 'space-between',
            alignItems: 'center',
            gap: '0.75rem',
          }}
        >
          <div style={{ fontSize: '0.78rem', color: 'var(--text-dim)' }}>
            &copy; 2026 Magneton Labs LLC. All rights reserved.
          </div>
          <div style={{ fontSize: '0.78rem', color: 'var(--text-dim)' }}>
            Author:{' '}
            <span style={{ color: 'var(--text-muted)', fontWeight: 500 }}>
              Matthew Long
            </span>{' '}
            &mdash; April 2026
          </div>
        </div>
      </div>
    </footer>
  );
}
