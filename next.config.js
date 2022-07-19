const bsconfig = require("./bsconfig.json");

const { withSentryConfig } = require("@sentry/nextjs");
const withPlugins = require("next-compose-plugins");
const withImages = require("next-images");

const transpileModules = ["rescript"]
  .concat(bsconfig["bs-dependencies"])
  .concat(["echarts", "zrender"]);
const withTM = require("next-transpile-modules")(transpileModules);

const config = {
  pageExtensions: ["jsx", "js"],
  fileExtensions: ["jpg", "jpeg", "gif"],
  env: {
    ENV: process.env.NODE_ENV,
  },
  webpack: (config, options) => {
    const { isServer } = options;

    if (!isServer) {
      // We shim fs for things like the blog slugs component
      // where we need fs access in the server-side part
      config.resolve.fallback = {
        fs: false,
        path: false,
        process: false,
      };
    }

    // We need this additional rule to make sure that mjs files are
    // correctly detected within our src/ folder
    config.module.rules.push({
      test: /\.m?js$/,
      use: options.defaultLoaders.babel,
      exclude: /node_modules/,
      type: "javascript/auto",
      resolve: {
        fullySpecified: false,
      },
    });

    const fileLoaderRule = config.module.rules.find(
      (rule) => rule.test && rule.test.test(".svg")
    );

    fileLoaderRule.exclude = /\.(svg)$/;

    config.module.rules.push({
      test: /\.svg$/i,
      type: "asset/resource",
      resourceQuery: { not: [/react/] }, // "....svg?react" 형태의 리소스 쿼리를 제외한다.
    });
    config.module.rules.push({
      test: /\.svg$/i,
      resourceQuery: /react/, // *.svg?react
      use: [
        {
          loader: "@svgr/webpack",
        },
      ],
    });

    return config;
  },
  webpack5: true,
  eslint: {
    dirs: ["src"],
    ignoreDuringBuilds: true,
  },
  images: {
    domains: [
      "dev-public.freshmarket-farmmorning.co.kr",
      "staging-public.freshmarket-farmmorning.co.kr",
      "prod-public.freshmarket-farmmorning.co.kr",
      "stg-public.freshmarket-farmmorning.co.kr",
    ],
  },
  experimental: {
    runtime: "nodejs",
    scrollRestoration: true,
    images: { layoutRaw: true },
  },
};

if (process.env.NEXT_PUBLIC_VERCEL_ENV !== "production") {
  config.sentry = {
    disableServerWebpackPlugin: true,
    disableClientWebpackPlugin: true,
  };
}

const sentryWebpackPluginOptions = {
  silent: true,
};

module.exports = withPlugins(
  [
    [withSentryConfig(config, sentryWebpackPluginOptions)],
    [withTM],
    [
      withImages,
      {
        inlineImageLimit: false,
      },
    ],
  ],
  config
);
