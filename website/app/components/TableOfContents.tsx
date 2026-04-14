'use client';
import { useState, useEffect } from 'react';

interface Heading {
  id: string;
  text: string;
  level: number;
}

export function TableOfContents({ headings }: { headings: Heading[] }) {
  const [activeId, setActiveId] = useState('');
  const [isOpen, setIsOpen] = useState(false);

  useEffect(() => {
    const onScroll = () => {
      const scrollY = window.scrollY + 100;
      let current = '';
      for (const { id } of headings) {
        const el = document.getElementById(id);
        if (el && el.offsetTop <= scrollY) {
          current = id;
        }
      }
      setActiveId(current);
    };
    window.addEventListener('scroll', onScroll, { passive: true });
    onScroll();
    return () => window.removeEventListener('scroll', onScroll);
  }, [headings]);

  if (headings.length === 0) return null;

  return (
    <>
      {/* Mobile toggle */}
      <button
        className="toc-mobile-btn"
        onClick={() => setIsOpen(!isOpen)}
        aria-expanded={isOpen}
        aria-label="Toggle table of contents"
        style={{ marginBottom: '1rem' }}
      >
        <svg
          width="16"
          height="16"
          viewBox="0 0 16 16"
          fill="none"
          stroke="currentColor"
          strokeWidth="1.5"
          strokeLinecap="round"
          aria-hidden="true"
        >
          <line x1="2" y1="4" x2="14" y2="4" />
          <line x1="2" y1="8" x2="10" y2="8" />
          <line x1="2" y1="12" x2="12" y2="12" />
        </svg>
        Table of Contents
        <svg
          width="12"
          height="12"
          viewBox="0 0 12 12"
          fill="none"
          stroke="currentColor"
          strokeWidth="1.5"
          strokeLinecap="round"
          aria-hidden="true"
          style={{ transform: isOpen ? 'rotate(180deg)' : 'none', transition: 'transform 0.2s' }}
        >
          <path d="M2 4l4 4 4-4" />
        </svg>
      </button>

      {/* TOC nav */}
      <nav
        className="toc-nav"
        aria-label="Table of contents"
        style={{ display: isOpen ? 'block' : undefined }}
      >
        <div
          style={{
            fontSize: '0.7rem',
            fontWeight: 700,
            color: 'var(--text-dim)',
            textTransform: 'uppercase',
            letterSpacing: '0.1em',
            padding: '0 12px',
            marginBottom: '0.75rem',
          }}
        >
          Contents
        </div>
        {headings.map(({ id, text, level }) => (
          <a
            key={id}
            href={`#${id}`}
            className={`toc-item${level === 3 ? ' toc-sub' : ''}${activeId === id ? ' toc-active' : ''}`}
            onClick={(e) => {
              e.preventDefault();
              document.getElementById(id)?.scrollIntoView({ behavior: 'smooth', block: 'start' });
              setIsOpen(false);
            }}
          >
            {text}
          </a>
        ))}
      </nav>

      <style>{`
        @media (min-width: 1024px) {
          .toc-mobile-btn { display: none !important; }
          .toc-nav { display: block !important; }
        }
        @media (max-width: 1023px) {
          .toc-nav { display: none; position: static !important; max-height: none !important; }
          .toc-nav[style*="block"] { display: block !important; }
        }
      `}</style>
    </>
  );
}
