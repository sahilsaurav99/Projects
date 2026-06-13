module.exports = {
  root: true,
  parser: '@typescript-eslint/parser',
  plugins: ['@typescript-eslint', 'import'],
  extends: ['eslint:recommended', 'plugin:@typescript-eslint/recommended', 'prettier'],
  rules: { '@typescript-eslint/no-unused-vars': ['error', { argsIgnorePattern: '^_' }] },
};
