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
    { '<leader>cn', ':lua require("neogen").generate()<CR>', desc = 'Generate Annotations ([N]eogen)' },
  },
}
