module.exports = {
  testMatch:[
    "**/__tests__/**/*.?(m)js?(x)",
    "**/?(*.)(spec|test).?(m)js?(x)"
  ],
  moduleFileExtensions: ["js", "jsx", "mjs"],
  transform: {
    '^.+\\.m?jsx?$': 'babel-jest',
  },
  testEnvironment: "node",
  moduleNameMapper: {
    "\\.(jpg|jpeg|png|gif|eot|otf|webp|svg|ttf|woff|woff2|mp4|webm|wav|mp3|m4a|aac|oga)$":
      "<rootDir>/__mocks__/fileMock.js",
    "\\.(css|less)$": "<rootDir>/__mocks__/styleMock.js",
  },
  transformIgnorePatterns: [
    "/node_modules/(?!@glennsl/bs-jest|bs-platform|@greenlabs|@rescript|rescript/).+\\.m?js$",
  ],
};
