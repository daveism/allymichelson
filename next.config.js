/** @type {import('next').NextConfig} */
const nextConfig = {
  output: 'export',
  // Uncomment basePath for GitHub Pages (username.github.io/repo-name)
  // Remove when using a custom domain
  basePath: '/allymichelson',
  images: {
    unoptimized: true,
  },
  trailingSlash: true,
};

module.exports = nextConfig;
