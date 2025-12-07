-- Automatically add closing tags for HTML and JSX
-- see: https://github.com/windwp/nvim-ts-autotag
return {
  'windwp/nvim-ts-autotag',
  event = { 'BufReadPost', 'BufNewFile', 'BufWritePre' },
  opts = {},
}
