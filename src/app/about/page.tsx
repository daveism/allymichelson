import Image from 'next/image';
import type { Metadata } from 'next';
import { getAboutContent } from '@/lib/content';

export const metadata: Metadata = { title: 'About' };

export default async function AboutPage() {
  const about = await getAboutContent();

  return (
    <div className="px-8 py-16 max-w-3xl mx-auto">
      {about.profileImage && (
        <div className="relative w-48 h-48 rounded-full overflow-hidden mb-8 mx-auto border-2 border-border">
          <Image src={about.profileImage} alt="Profile" fill className="object-cover" priority />
        </div>
      )}
      <div className="prose-custom" dangerouslySetInnerHTML={{ __html: about.content }} />
      {about.cvDownload && (
        <div className="mt-8">
          <a href={about.cvDownload} className="btn btn-primary no-underline" download>Download CV</a>
        </div>
      )}
    </div>
  );
}
