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
      swift = { "swiftlint" }
    }

    local swiftlint_disabled = {
      ["Identifier Name Violation"] = true,
      ["Type Body Length Violation"] = true,
    }

    local logfile = vim.fn.expand("~/.config/nvim/log/lint.log")
    vim.fn.mkdir(vim.fn.fnamemodify(logfile, ":h"), "p")

    lint.linters.swiftlint = require("lint.util").wrap(lint.linters.swiftlint, function(diagnostic)
      local logf = io.open(logfile, "a")
      -- lazy match - capture everything up to the first colon
      local rule = diagnostic.code or diagnostic.message:match("^(.-):")
      if logf then
        logf:write(vim.json.encode(diagnostic) .. "\n")
        logf:close()
      end
      if rule and swiftlint_disabled[rule] then
        return nil
      end
      return diagnostic
    end)

    local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })

    vim.api.nvim_create_autocmd({
      "BufWritePost",
      "BufReadPost",
      "InsertLeave",
      "TextChanged"
    }, {
      group = lint_augroup,
      callback = function()
        if not vim.endswith(vim.fn.bufname(), "swiftinterface") then
          require("lint").try_lint()
        end
      end,
    })

    vim.keymap.set("n", "<leader>ml", function()
      require("lint").try_lint()
    end, { desc = "Lint current file" })
  end,
}
