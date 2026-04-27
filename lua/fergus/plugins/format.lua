return {
  "stevearc/conform.nvim",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local conform = require("conform")

    conform.setup({
      formatters_by_ft = {
        python = { "ruff", stop_after_first = true },
        javascript = { "prettierd", "eslint_d", stop_after_first = true },
        typescript = { "prettierd", "eslint_d", stop_after_first = true },
        javascriptreact = { "prettierd", "eslint_d", stop_after_first = true },
        typescriptreact = { "prettierd", "eslint_d", stop_after_first = true },
        json = { "prettierd", stop_after_first = true },
        jsonc = { "prettierd", stop_after_first = true },
        prisma = { "prettierd", stop_after_first = true },
        proto = { "NULL_LS_FORMATTING" },
        swift = { "swiftformat" },
      },
      -- Custom args would go here
      -- formatters = {
      --   swift = {
      --     swiftformat = {
      --       prepend_args = {}
      --     }
      --   }
      -- },
      format_on_save = function(bufnr)
        local ignore_filetypes = { "oil" }
        if vim.tbl_contains(ignore_filetypes, vim.bo[bufnr].filetype) then
          return
        end

        return { timeout_ms = 500, lsp_fallback = true }
      end,
      log_level = vim.log.levels.ERROR
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
