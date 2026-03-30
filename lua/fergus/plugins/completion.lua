return {
  "saghen/blink.cmp",
  version = "1.*",
  dependencies = {
    "L3MON4D3/LuaSnip",
    "rafamadriz/friendly-snippets",
  },

  opts = {
    keymap = {
      preset = 'default',
      ['<C-space>'] = { 'show', 'show_documentation', 'hide_documentation' },
      ['<C-p>'] = { 'select_prev', 'fallback_to_mappings' },
      ['<C-n>'] = { 'select_next', 'fallback_to_mappings' },
      ['<C-y>'] = { 'select_and_accept', 'fallback' },
    },

    appearance = {
      nerd_font_variant = 'mono',
    },

    snippets = {
      preset = 'luasnip',
    },

    sources = {
      default = { 'lazydev', 'lsp', 'path', 'snippets', 'buffer' },
      providers = {
        lazydev = {
          name = 'LazyDev',
          module = 'lazydev.integrations.blink',
          score_offset = 100,
        },
      },
    },

    completion = {
      documentation = { auto_show = true },
    },

    fuzzy = {
      implementation = 'prefer_rust_with_warning',
    },
  },

  opts_extend = { 'sources.default' },
}
