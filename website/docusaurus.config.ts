import {themes as prismThemes} from 'prism-react-renderer';
import type {Config} from '@docusaurus/types';
import type * as Preset from '@docusaurus/preset-classic';
import type {PluginOptions as SearchLocalOptions} from '@easyops-cn/docusaurus-search-local';

const config: Config = {
  title: 'IELTS Mastery Hub',
  tagline: 'Prepare the way you\'ll sit it',
  favicon: 'img/favicon.ico',

  future: {
    v4: true,
  },

  url: 'https://ielts-mastery-hub.dev',
  baseUrl: '/',

  organizationName: 'open-lingua',
  projectName: 'ielts-mastery-hub',

  onBrokenLinks: 'throw',
  onBrokenMarkdownLinks: 'warn',

  i18n: {
    defaultLocale: 'en',
    locales: ['en'],
  },

  headTags: [
    {
      tagName: 'link',
      attributes: { rel: 'preconnect', href: 'https://fonts.googleapis.com' },
    },
    {
      tagName: 'link',
      attributes: { rel: 'preconnect', href: 'https://fonts.gstatic.com', crossorigin: 'anonymous' },
    },
    {
      tagName: 'link',
      attributes: {
        rel: 'stylesheet',
        href: 'https://fonts.googleapis.com/css2?family=Fraunces:opsz,wght@9..144,400;9..144,500;9..144,600;9..144,700&family=Hanken+Grotesk:wght@400;500;600;700&family=IBM+Plex+Mono:wght@400;500;600&display=swap',
      },
    },
  ],

  presets: [
    [
      'classic',
      {
        docs: {
          sidebarPath: './sidebars.ts',
        },
        blog: {
          showReadingTime: true,
          feedOptions: { type: ['rss', 'atom'], xslt: true },
          onInlineTags: 'warn',
          onInlineAuthors: 'warn',
          onUntruncatedBlogPosts: 'warn',
        },
        theme: {
          customCss: './src/css/custom.css',
        },
      } satisfies Preset.Options,
    ],
  ],

  themes: [
    [
      require.resolve('@easyops-cn/docusaurus-search-local'),
      {
        hashed: true,
        language: ['en'],
        indexDocs: true,
        indexBlog: true,
        indexPages: false,
        searchBarShortcutHint: true,
        searchResultLimits: 8,
      } satisfies SearchLocalOptions,
    ],
  ],

  themeConfig: {
    image: 'img/app-banner.png',
    colorMode: {
      respectPrefersColorScheme: true,
    },
    docs: {
      sidebar: {
        autoCollapseCategories: false,
      },
    },
    navbar: {
      title: 'IELTS Mastery Hub',
      logo: {
        alt: 'IELTS Mastery Hub Logo',
        src: 'img/app-logo.png',
        style: { borderRadius: '50%', background: '#fff', boxShadow: '0 0 0 1px rgba(27,42,94,.15)', padding: '2px' },
      },
      items: [
        { to: '/#audience', label: "Who it's for", position: 'left' },
        { to: '/#features', label: 'Features', position: 'left' },
        { to: '/#showcase', label: 'Inside the app', position: 'left' },
        { to: '/#steps', label: 'Get started', position: 'left' },
        { to: '/#tech', label: 'Built with', position: 'left' },
        {
          href: 'https://github.com/open-lingua/ielts-mastery-hub/releases',
          label: 'Download',
          position: 'right',
          className: 'navbar-download-btn',
        },
      ],
    },
    footer: {
      style: 'dark',
      links: [
        {
          title: 'Product',
          items: [
            { label: 'Features', to: '/#features' },
            { label: 'Download', href: 'https://github.com/open-lingua/ielts-mastery-hub/releases' },
            { label: 'Changelog', to: '/blog' },
            { label: 'Roadmap', href: 'https://github.com/open-lingua/ielts-mastery-hub/projects' },
          ],
        },
        {
          title: 'Docs',
          items: [
            { label: 'Getting Started', to: '/docs/intro' },
            { label: 'Configuration', to: '/docs/intro' },
            { label: 'Writing Module', to: '/docs/intro' },
            { label: 'API Reference', to: '/docs/intro' },
          ],
        },
        {
          title: 'Project',
          items: [
            { label: 'GitHub', href: 'https://github.com/open-lingua/ielts-mastery-hub' },
            { label: 'Issues', href: 'https://github.com/open-lingua/ielts-mastery-hub/issues' },
            { label: 'Contributing', href: 'https://github.com/open-lingua/ielts-mastery-hub/blob/main/CONTRIBUTING.md' },
            { label: 'License', href: 'https://github.com/open-lingua/ielts-mastery-hub/blob/main/LICENSE' },
          ],
        },
      ],
      copyright: `Copyright © ${new Date().getFullYear()} Open Lingua. MIT License.`,
    },
    prism: {
      theme: prismThemes.github,
      darkTheme: prismThemes.dracula,
    },
  } satisfies Preset.ThemeConfig,
};

export default config;
