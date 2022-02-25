module.exports = {
  root: true,
  parser: '@typescript-eslint/parser',
  plugins: ['@typescript-eslint'],
  extends: ["eslint:recommended", "plugin:@typescript-eslint/recommended", "prettier", "plugin:storybook/recommended"],
  rules: {
    "no-console": [2, {
      "allow": ["warn", "error"]
    }]
  },
  overrides: [{
    files: ["**/*.{js,jsx}"],
    parser: "@babel/eslint-parser",
    plugins: [],
    extends: ["eslint:recommended", "prettier"],
    env: {
      "es6": true,
      "browser": true,
      "node": true
    },
    rules: {
      "no-console": [2, {
        "allow": ["warn", "error"]
      }]
    }
  }]
};