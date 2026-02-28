'use client';

import { useState } from 'react';
import Link from 'next/link';
import { usePathname } from 'next/navigation';
import type { NavItem } from '@/lib/types';

interface Props {
  items: NavItem[];
  siteTitle: string;
}

export default function Navigation({ items, siteTitle }: Props) {
  const pathname = usePathname();
  const [open, setOpen] = useState(false);

  const isActive = (p: string) => {
    if (p === '/') return pathname === '/';
    return pathname.startsWith(p);
  };

  return (
    <>
      <button
        className="fixed top-6 left-6 z-50 lg:hidden flex flex-col gap-1.5"
        onClick={() => setOpen(!open)}
        aria-label="Toggle menu"
      >
        <span className={`block w-6 h-0.5 bg-text-primary transition-transform duration-300 ${open ? 'rotate-45 translate-y-2' : ''}`} />
        <span className={`block w-6 h-0.5 bg-text-primary transition-opacity duration-300 ${open ? 'opacity-0' : ''}`} />
        <span className={`block w-6 h-0.5 bg-text-primary transition-transform duration-300 ${open ? '-rotate-45 -translate-y-2' : ''}`} />
      </button>

      <nav className={`
        fixed top-0 left-0 h-full w-64 bg-bg z-40
        flex flex-col pt-12 px-8
        transition-transform duration-300
        lg:translate-x-0 border-r border-border
        ${open ? 'translate-x-0' : '-translate-x-full'}
      `}>
        <Link
          href="/"
          className="font-heading text-2xl text-text-primary no-underline mb-8 hover:text-text-primary"
          onClick={() => setOpen(false)}
        >
          {siteTitle}
        </Link>

        <div className="flex flex-col gap-1 -mx-3">
          {items.map(item => (
            <Link
              key={item.path}
              href={item.path}
              onClick={() => setOpen(false)}
              className={`
                block w-full px-3 py-2 rounded
                font-accent text-sm tracking-widest uppercase no-underline
                transition-all duration-200
                ${isActive(item.path)
                  ? 'text-accent-secondary bg-bg-alt'
                  : 'text-text-secondary hover:text-accent-secondary hover:bg-bg-alt'}
              `}
            >
              {item.label}
            </Link>
          ))}
        </div>

        <div className="mt-auto mb-8">
          <div className="w-16 h-0.5 bg-gradient-to-r from-accent-primary via-accent-tertiary to-accent-secondary rounded" />
        </div>
      </nav>

      {open && (
        <div
          className="fixed inset-0 bg-black/60 z-30 lg:hidden"
          onClick={() => setOpen(false)}
        />
      )}
    </>
  );
}
