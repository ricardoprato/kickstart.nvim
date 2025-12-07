return {
  'MeanderingProgrammer/render-markdown.nvim',
  ft = 'markdown',
  keys = {
    { '<leader>cp', ':RenderMarkdown buf_toggle<CR>', { desc = 'Markdown Toggle' } },
  },
  opts = {},
}
