module.exports = {
  env: {
    browser: true,
    es2021: true
  },
  extends: [
    "next",
  ],
  parserOptions: {
    ecmaFeatures: {
      jsx: true
    },
    ecmaVersion: 12,
    sourceType: "module"
  },
  plugins: ["react-hooks"],
  rules: {
    "react-hooks/rules-of-hooks": "warn", // Checks rules of Hooks
    "react-hooks/exhaustive-deps": "warn" // Checks effect dependencies
  }
}
