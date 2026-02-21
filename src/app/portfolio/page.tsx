import type { Metadata } from 'next';
import { getPortfolioConfig } from '@/lib/config';
import SectionCard from '@/components/ui/SectionCard';

export const metadata: Metadata = { title: 'Portfolio' };

export default function PortfolioPage() {
  const portfolio = getPortfolioConfig();

  return (
    <div className="px-8 py-16 max-w-layout mx-auto">
      <h1 className="font-heading text-4xl mb-4 organic-line">Portfolio</h1>
      <p className="text-text-secondary mt-8 mb-12">Explore work across all disciplines</p>
      <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
        {portfolio.sections.map(section => (
          <SectionCard key={section.slug} section={section} />
        ))}
      </div>
    </div>
  );
}
