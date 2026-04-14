'use client';
import Link from 'next/link';
import { useState } from 'react';

export default function Header() {
  const [menuOpen, setMenuOpen] = useState(false);

  return (
    <header className="site-header">
      <div
        style={{
          maxWidth: '1200px',
          margin: '0 auto',
          padding: '0 1.5rem',
          height: '64px',
          display: 'flex',
          alignItems: 'center',
          justifyContent: 'space-between',
        }}
      >
        {/* Logo / Site Title */}
        <Link
          href="/"
          style={{ textDecoration: 'none', display: 'flex', alignItems: 'center', gap: '10px' }}
        >
          {/* Topology icon — simplified */}
          <svg
            width="28"
            height="28"
            viewBox="0 0 28 28"
            fill="none"
            aria-hidden="true"
          >
            <circle cx="14" cy="14" r="12" stroke="var(--accent)" strokeWidth="1.5" />
            <circle cx="14" cy="14" r="6" stroke="var(--accent)" strokeWidth="1" opacity="0.6" />
            <circle cx="14" cy="14" r="2" fill="var(--accent)" opacity="0.9" />
            <path
              d="M14 2 C18 8, 22 10, 26 14 C22 18, 18 20, 14 26 C10 20, 6 18, 2 14 C6 10, 10 8, 14 2Z"
              stroke="var(--accent-secondary)"
              strokeWidth="0.8"
              fill="none"
              opacity="0.5"
            />
          </svg>
          <div>
            <div
              style={{
                fontSize: '0.95rem',
                fontWeight: 700,
                color: 'var(--text)',
                lineHeight: 1.2,
                letterSpacing: '-0.01em',
              }}
            >
              YonedaAI
            </div>
            <div
              style={{
                fontSize: '0.65rem',
                color: 'var(--text-dim)',
                letterSpacing: '0.05em',
                textTransform: 'uppercase',
              }}
            >
              Research Collective
            </div>
          </div>
        </Link>

        {/* Desktop nav */}
        <nav
          style={{ display: 'flex', alignItems: 'center', gap: '2rem' }}
          className="hidden-mobile"
        >
          <Link
            href="/"
            style={{
              fontSize: '0.875rem',
              color: 'var(--text-muted)',
              textDecoration: 'none',
              fontWeight: 500,
              transition: 'color 0.15s',
            }}
            onMouseEnter={(e) =>
              ((e.target as HTMLElement).style.color = 'var(--text)')
            }
            onMouseLeave={(e) =>
              ((e.target as HTMLElement).style.color = 'var(--text-muted)')
            }
          >
            Papers
          </Link>
          <Link
            href="/about/"
            style={{
              fontSize: '0.875rem',
              color: 'var(--text-muted)',
              textDecoration: 'none',
              fontWeight: 500,
              transition: 'color 0.15s',
            }}
            onMouseEnter={(e) =>
              ((e.target as HTMLElement).style.color = 'var(--text)')
            }
            onMouseLeave={(e) =>
              ((e.target as HTMLElement).style.color = 'var(--text-muted)')
            }
          >
            About
          </Link>
          <a
            href="https://magnetonlabs.com"
            target="_blank"
            rel="noopener noreferrer"
            style={{
              fontSize: '0.875rem',
              color: 'var(--text-muted)',
              textDecoration: 'none',
              fontWeight: 500,
              transition: 'color 0.15s',
            }}
            onMouseEnter={(e) =>
              ((e.target as HTMLElement).style.color = 'var(--text)')
            }
            onMouseLeave={(e) =>
              ((e.target as HTMLElement).style.color = 'var(--text-muted)')
            }
          >
            Magneton Labs
          </a>
        </nav>

        {/* Mobile hamburger */}
        <button
          onClick={() => setMenuOpen(!menuOpen)}
          aria-label="Toggle menu"
          style={{
            display: 'none',
            background: 'none',
            border: 'none',
            cursor: 'pointer',
            color: 'var(--text-muted)',
            padding: '4px',
          }}
          className="show-mobile"
        >
          <svg
            width="22"
            height="22"
            viewBox="0 0 22 22"
            fill="none"
            stroke="currentColor"
            strokeWidth="2"
            strokeLinecap="round"
          >
            {menuOpen ? (
              <>
                <line x1="4" y1="4" x2="18" y2="18" />
                <line x1="18" y1="4" x2="4" y2="18" />
              </>
            ) : (
              <>
                <line x1="3" y1="7" x2="19" y2="7" />
                <line x1="3" y1="11" x2="19" y2="11" />
                <line x1="3" y1="15" x2="19" y2="15" />
              </>
            )}
          </svg>
        </button>
      </div>

      {/* Mobile nav dropdown */}
      {menuOpen && (
        <div
          style={{
            borderTop: '1px solid var(--border)',
            padding: '1rem 1.5rem',
            display: 'flex',
            flexDirection: 'column',
            gap: '1rem',
          }}
        >
          <Link
            href="/"
            onClick={() => setMenuOpen(false)}
            style={{ color: 'var(--text-muted)', textDecoration: 'none', fontWeight: 500 }}
          >
            Papers
          </Link>
          <Link
            href="/about/"
            onClick={() => setMenuOpen(false)}
            style={{ color: 'var(--text-muted)', textDecoration: 'none', fontWeight: 500 }}
          >
            About
          </Link>
          <a
            href="https://magnetonlabs.com"
            target="_blank"
            rel="noopener noreferrer"
            style={{ color: 'var(--text-muted)', textDecoration: 'none', fontWeight: 500 }}
          >
            Magneton Labs
          </a>
        </div>
      )}

      <style>{`
        @media (max-width: 640px) {
          .hidden-mobile { display: none !important; }
          .show-mobile { display: block !important; }
        }
        @media (min-width: 641px) {
          .show-mobile { display: none !important; }
        }
      `}</style>
    </header>
  );
}
