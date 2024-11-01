return {
  'danymat/neogen',
  opts = {
    snippet_engine = 'luasnip',
    languages = {
      python = {
        template = {
          annotation_convention = 'reST',
        },
      },
    },
  },
  keys = {
    { '<leader>ln', ':lua require("neogen").generate()<CR>', desc = '[N]eogen' },
  },
}
