import type { SiteConfig } from '@/lib/types';
import SocialLinks from '@/components/ui/SocialLinks';

interface Props {
  config: SiteConfig;
}

export default function Footer({ config }: Props) {
  return (
    <footer className="border-t border-border mt-16 py-12 px-8">
      <div className="max-w-layout mx-auto flex flex-col sm:flex-row justify-between items-center gap-8">
        <SocialLinks config={config} />
        <div className="text-text-muted text-xs">
          &copy; {new Date().getFullYear()} {config.author}
        </div>
      </div>
    </footer>
  );
}
