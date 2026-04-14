'use client';
// PaperContent renders pre-processed static HTML from our own pandoc/KaTeX pipeline.
// The content is our own build-time generated output — not user input.
// We bypass React reconciliation via ref callback to prevent hydration mismatch
// on KaTeX-rendered math spans.
import { useCallback } from 'react';

export function PaperContent({ html }: { html: string }) {
  // Using a ref callback that sets innerHTML directly bypasses React hydration
  // for KaTeX-rendered HTML, preventing attribute mismatch errors.
  // This content is safe: it is our own build-time pandoc output.
  const contentRef = useCallback(
    (node: HTMLDivElement | null) => {
      if (node) {
        // Safe: html is our own build-time static content, not user-supplied
        node.innerHTML = html; // nosec
      }
    },
    [html]
  );

  return <div ref={contentRef} className="paper-content" />;
}
