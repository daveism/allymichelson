/** @type {import('next').NextConfig} */
const nextConfig = {
  output: 'export',
  basePath: '/allymichelson',
  images: {
    unoptimized: true,
  },
  trailingSlash: true,
  env: {
    NEXT_PUBLIC_BASE_PATH: '/allymichelson',
  },
};

module.exports = nextConfig;
