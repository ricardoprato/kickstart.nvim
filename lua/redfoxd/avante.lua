return {
  'yetone/avante.nvim',
  event = 'VeryLazy',
  lazy = false,
  version = false,
  ---@module 'avante'
  ---@type avante.Config
  opts = {
    input = {
      provider = 'dressing',
      provider_opts = {},
    },
    provider = 'copilot', -- Recommend using Claude
    auto_suggestions_provider = 'copilot',
    acp_providers = {
      ['gemini-cli'] = {
        command = 'gemini',
        args = {
          '--experimental-acp',
          '--allowed-tools=ShellTool',
        },
        env = {
          NODE_NO_WARNINGS = '1',
        },
      },
    },
  },
  build = 'make',
  -- build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" -- for windows
  dependencies = {
    opts = {},
    {
      -- support for image pasting
      'HakonHarnes/img-clip.nvim',
      event = 'VeryLazy',
      opts = {
        -- recommended settings
        default = {
          embed_image_as_base64 = false,
          prompt_for_file_name = false,
          drag_and_drop = {
            insert_mode = true,
          },
        },
      },
    },
    {
      -- Make sure to set this up properly if you have lazy=true
      'MeanderingProgrammer/render-markdown.nvim',
      opts = {
        file_types = { 'markdown', 'Avante' },
      },
      ft = { 'markdown', 'Avante' },
    },
    { 'zbirenbaum/copilot.lua' },
  },
}
