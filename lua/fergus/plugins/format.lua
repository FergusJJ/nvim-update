return {
  "stevearc/conform.nvim",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local conform = require("conform")

    conform.setup({
      formatters_by_ft = {
        python = { "ruff", stop_after_first = true },
        javascript = { "prettierd", stop_after_first = true },
        typescript = { "prettierd", "eslint_d", stop_after_first = false },
        javascriptreact = { "prettierd", stop_after_first = true },
        typescriptreact = { "prettierd", "eslint_d", stop_after_first = false },
        json = { "prettierd", stop_after_first = true },
        jsonc = { "prettierd", stop_after_first = true },
        prisma = { "prettierd", stop_after_first = true },
        swift = { "swiftformat" },
        proto = { "NULL_LS_FORMATTING" }
      },
      format_on_save = {
        timeout_ms = 2000,
        lsp_fallback = true,
      },
    })

    vim.keymap.set({ "n", "v" }, "<leader>mp", function()
      conform.format({
        lsp_fallback = true,
        async = false,
        timeout_ms = 2000,
      })
    end, { desc = "Format file or range (in visual mode)" })
  end,
}
