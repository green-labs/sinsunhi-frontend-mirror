import "styles/main.css";

// Note:
// Just renaming $$default to ResApp alone
// doesn't help FastRefresh to detect the
// React component, since an alias isn't attached
// to the original React component function name.
import ResApp from "src/App.mjs";
import React from "react";
import Head from "next/head";

// Note:
// We need to wrap the make call with
// a Fast-Refresh conform function name,
// (in this case, uppercased first letter)
//
// If you don't do this, your Fast-Refresh will
// not work!
export default function App(props) {
  return (
    <>
      <Head>
        {/* Viewport는 _app.js에 선언되어야 한다 - by Next (https://nextjs.org/docs/messages/no-document-viewport-meta) */}
        <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0" />
      </Head>
      <ResApp {...props} />
    </>
  );
}
