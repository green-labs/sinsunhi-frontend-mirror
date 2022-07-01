import * as Sentry from "@sentry/nextjs"

if(process.env.NEXT_PUBLIC_VERCEL_ENV === "production"){
  Sentry.init({
    dsn: process.env.NEXT_PUBLIC_SENTRY_DSN,
    ignoreErrors: [],
    environment: process.env.NEXT_PUBLIC_VERCEL_ENV,
    tracesSampleRate: 0.2
  })
}
