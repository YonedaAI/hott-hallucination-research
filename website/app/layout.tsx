import type { Metadata } from 'next';
import { Space_Grotesk } from 'next/font/google';
import './globals.css';
import Header from './components/Header';
import Footer from './components/Footer';

const spaceGrotesk = Space_Grotesk({
  subsets: ['latin'],
  variable: '--font-space-grotesk',
  display: 'swap',
});

// Resolve base URL from Vercel env vars, custom env, or fallback
const siteUrl = process.env.NEXT_PUBLIC_SITE_URL
  || (process.env.VERCEL_PROJECT_PRODUCTION_URL && `https://${process.env.VERCEL_PROJECT_PRODUCTION_URL}`)
  || (process.env.VERCEL_URL && `https://${process.env.VERCEL_URL}`)
  || 'http://localhost:3000';

export const metadata: Metadata = {
  metadataBase: new URL(siteUrl),
  title: {
    default: 'YonedaAI Research Collective — Hallucination is a Theorem',
    template: '%s | YonedaAI Research',
  },
  description:
    'A homotopy type theory framework for detecting and preventing LLM hallucination. Three papers by Matthew Long, YonedaAI Research Collective / Magneton Labs LLC.',
  keywords: [
    'Homotopy Type Theory',
    'HoTT',
    'LLM Hallucination',
    'Algebraic Topology',
    'Dependent Type Theory',
    'Semantic Correctness',
    'AI Safety',
  ],
  authors: [{ name: 'Matthew Long' }],
  creator: 'YonedaAI Research Collective',
  openGraph: {
    type: 'website',
    siteName: 'YonedaAI Research Collective',
    title: 'YonedaAI Research Collective — Hallucination is a Theorem',
    description:
      'A homotopy type theory framework for detecting and preventing LLM hallucination. 75 pages, 21 theorems, 3 verified Haskell modules.',
    images: [
      {
        url: '/images/og/hott-synthesis-og.png',
        width: 1200,
        height: 630,
        alt: 'HoTT Hallucination Research — YonedaAI',
      },
    ],
  },
  twitter: {
    card: 'summary_large_image',
    title: 'YonedaAI Research — Hallucination is a Theorem',
    description:
      'A homotopy type theory framework for detecting and preventing LLM hallucination.',
    images: ['/images/og/hott-synthesis-og.png'],
    creator: '@yonedaai',
  },
};

export default function RootLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <html lang="en" className={spaceGrotesk.variable}>
      <body
        style={{
          backgroundColor: 'var(--bg)',
          color: 'var(--text)',
          fontFamily: 'var(--font-space-grotesk), "Space Grotesk", system-ui, sans-serif',
        }}
      >
        <Header />
        <main>{children}</main>
        <Footer />
      </body>
    </html>
  );
}
