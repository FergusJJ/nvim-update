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
      formatters = {
        swift = {
          swiftformat = {
            command = "swiftformat",
            args = { "--config", "~/.config/nvim/.swiftformat", "--stdinpath", "$FILENAME" }
          }
        }
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

        local filetype = vim.bo[bufnr].filetype
        local bufname = vim.api.nvim_buf_get_name(bufnr)
        local formatters = conform.list_formatters(bufnr)
        local formatter_names = {}
        for _, f in ipairs(formatters) do
          table.insert(formatter_names, f.name .. (f.available and "" or "(unavailable)"))
        end

        local skipped = vim.tbl_contains(ignore_filetypes, filetype)

        local logfile = vim.fn.expand("~/.config/nvim/log/format.log")
        vim.fn.mkdir(vim.fn.fnamemodify(logfile, ":h"), "p")

        local logf = io.open(logfile, "a")
        if logf then
          logf:write(vim.json.encode({
            time = os.date("!%Y-%m-%dT%H:%M:%SZ"),
            bufnr = bufnr,
            buf = bufname,
            filetype = filetype,
            formatters = formatter_names,
            skipped = skipped,
          }) .. "\n")
          logf:close()
        end

        if skipped then
          return
        end

        return { timeout_ms = 500, lsp_fallback = true }
      end,
      log_level = vim.log.levels.ERROR
    })

    vim.keymap.set({ "n", "v" }, "<leader>f", function()
      local bufnr = vim.api.nvim_get_current_buf()
      local formatters = conform.list_formatters(bufnr)
      local formatter_names = {}
      for _, f in ipairs(formatters) do
        table.insert(formatter_names, f.name .. (f.available and "" or "(unavailable)"))
      end

      local logfile = vim.fn.expand("~/.config/nvim/log/format.log")
      vim.fn.mkdir(vim.fn.fnamemodify(logfile, ":h"), "p")
      local logf = io.open(logfile, "a")
      if logf then
        logf:write(vim.json.encode({
          time = os.date("!%Y-%m-%dT%H:%M:%SZ"),
          source = "keymap",
          bufnr = bufnr,
          buf = vim.api.nvim_buf_get_name(bufnr),
          filetype = vim.bo[bufnr].filetype,
          formatters = formatter_names,
        }) .. "\n")
        logf:close()
      end

      conform.format({
        lsp_fallback = true,
        async = false,
        timeout_ms = 2000,
      })
    end, { desc = "Format file or range (in visual mode)" })
  end,
}
