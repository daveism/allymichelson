import type { Config } from 'tailwindcss';

const config: Config = {
  content: ['./src/**/*.{js,ts,jsx,tsx,mdx}'],
  theme: {
    extend: {
      colors: {
        bg: 'var(--color-bg)',
        'bg-alt': 'var(--color-bg-alt)',
        surface: 'var(--color-surface)',
        'text-primary': 'var(--color-text-primary)',
        'text-secondary': 'var(--color-text-secondary)',
        'text-muted': 'var(--color-text-muted)',
        accent: {
          primary: 'var(--color-accent-primary)',
          secondary: 'var(--color-accent-secondary)',
          tertiary: 'var(--color-accent-tertiary)',
        },
        hover: 'var(--color-hover)',
        active: 'var(--color-active)',
        focus: 'var(--color-focus)',
        border: 'var(--color-border)',
        'border-hover': 'var(--color-border-hover)',
        error: 'var(--color-error)',
        success: 'var(--color-success)',
      },
      fontFamily: {
        heading: 'var(--font-heading)',
        body: 'var(--font-body)',
        accent: 'var(--font-accent)',
      },
      maxWidth: {
        layout: 'var(--layout-max-width)',
      },
      borderRadius: {
        card: 'var(--card-radius)',
        btn: 'var(--btn-radius)',
      },
    },
  },
  plugins: [],
};

export default config;
