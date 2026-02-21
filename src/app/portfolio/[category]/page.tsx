import type { Metadata } from 'next';
import { getPortfolioConfig } from '@/lib/config';
import { getArtPiecesByCategory, getAllCategorySlugs } from '@/lib/content';
import ArtGrid from '@/components/art/ArtGrid';

interface Props {
  params: { category: string };
}

export function generateStaticParams() {
  return getAllCategorySlugs().map(category => ({ category }));
}

export function generateMetadata({ params }: Props): Metadata {
  const portfolio = getPortfolioConfig();
  const section = portfolio.sections.find(s => s.slug === params.category);
  return {
    title: section?.title || params.category.toUpperCase(),
    description: section?.description,
  };
}

export default async function CategoryPage({ params }: Props) {
  const portfolio = getPortfolioConfig();
  const section = portfolio.sections.find(s => s.slug === params.category);
  const pieces = await getArtPiecesByCategory(params.category);

  return (
    <div className="px-8 py-16 max-w-layout mx-auto">
      <h1 className="font-heading text-4xl mb-2 organic-line">
        {section?.title || params.category.toUpperCase()}
      </h1>
      {section?.description && (
        <p className="text-text-secondary mt-6 mb-12">{section.description}</p>
      )}
      <ArtGrid pieces={pieces} />
    </div>
  );
}
