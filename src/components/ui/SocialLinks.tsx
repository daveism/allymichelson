import type { SiteConfig } from '@/lib/types';

interface Props {
  config: SiteConfig;
  showLabels?: boolean;
}

const socialIcons: Record<string, React.ReactNode> = {
  instagram: (
    <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
      <rect x="2" y="2" width="20" height="20" rx="5" ry="5" />
      <path d="M16 11.37A4 4 0 1 1 12.63 8 4 4 0 0 1 16 11.37z" />
      <line x1="17.5" y1="6.5" x2="17.51" y2="6.5" />
    </svg>
  ),
};

export default function SocialLinks({ config, showLabels = false }: Props) {
  const btnClass = showLabels
    ? 'inline-flex items-center gap-2 px-4 py-2 rounded-btn bg-[#b8a7c8] text-text-primary no-underline hover:bg-[#a08db5] transition-all duration-200'
    : 'inline-flex items-center justify-center w-10 h-10 rounded-btn bg-surface text-text-primary no-underline hover:text-accent-primary transition-all duration-200';

  return (
    <div className="flex flex-wrap gap-3">
      <a href={`mailto:${config.email}`} aria-label="Email" className={btnClass}>
        <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
          <rect x="2" y="4" width="20" height="16" rx="2" />
          <path d="m22 7-8.97 5.7a1.94 1.94 0 0 1-2.06 0L2 7" />
        </svg>
        {showLabels && <span className="text-sm font-accent">{config.email}</span>}
      </a>
      {Object.entries(config.social).map(([name, url]) => (
        <a
          key={name}
          href={url}
          target="_blank"
          rel="noopener noreferrer"
          aria-label={name}
          className={btnClass}
        >
          {socialIcons[name] || null}
          {showLabels && <span className="text-sm font-accent capitalize">{name}</span>}
        </a>
      ))}
    </div>
  );
}
