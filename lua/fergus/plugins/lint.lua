return {
  "mfussenegger/nvim-lint",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local lint = require("lint")

    lint.linters_by_ft = {
      javascript = { "oxlint", "eslint_d" },
      typescript = { "oxlint", "eslint_d" },
      javascriptreact = { "oxlint", "eslint_d" },
      typescriptreact = { "oxlint", "eslint_d" },
      -- swift = { "swiftlint" }
    }

    local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })

    vim.api.nvim_create_autocmd({
      "BufWritePost",
      "BufReadPost",
      "InsertLeave",
    }, {
      group = lint_augroup,
      callback = function()
        lint.try_lint()
      end,
    })

    vim.keymap.set("n", "<leader>ml", function()
      lint.try_lint()
    end, { desc = "Trigger linting for current file" })
  end,
}
