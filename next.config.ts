import type { NextConfig } from "next";

const nextConfig: NextConfig = {
  output: "standalone",
  images: {
    // domains: ['fakestoreapi.com'],
    remotePatterns: [
      {
        protocol: "https",
        hostname: "fastly.picsum.photos", // 外部画像のドメイン
        // pathname: '/images/**', // 必要に応じてパスを指定
      },
      {
        protocol: "https",
        hostname: "www.google.com",
      },
    ],
  },
  /* config options here */
};

export default nextConfig;
