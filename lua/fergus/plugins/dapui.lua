return {
  "rcarriga/nvim-dap-ui",
  dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },

  config = function()
    local dapui = require("dapui")
    local function make_layout(name, pos, size)
      return {
        elements = { { id = name } },
        enter = true,
        size = size or 40,
        position = pos or "right",
      }
    end

    local name_to_layout = {
      repl        = { layout = make_layout("repl", "right"), index = 0 },
      stacks      = { layout = make_layout("stacks", "right"), index = 0 },
      scopes      = { layout = make_layout("scopes", "right", 80), index = 0 },
      watches     = { layout = make_layout("watches", "right"), index = 0 },
      breakpoints = { layout = make_layout("breakpoints", "right"), index = 0 },
      console     = { layout = make_layout("console", "bottom", 10), index = 0 },
    }

    local layouts_list = {}
    for name, config in pairs(name_to_layout) do
      table.insert(layouts_list, config.layout)
      name_to_layout[name].index = #layouts_list
    end

    dapui.setup({ layouts = layouts_list })

    local function toggle_debug_ui(name)
      dapui.close()

      local config = name_to_layout[name]
      if not config then return end

      local uis = vim.api.nvim_list_uis()[1]
      if uis then config.layout.size = 40 end -- Reset to default or calculate dynamic

      dapui.toggle({ layout = config.index })
    end

    vim.keymap.set("n", "<leader>dlr", function() toggle_debug_ui("repl") end, { desc = "DAP: Toggle REPL" })
    vim.keymap.set("n", "<leader>ds", function() toggle_debug_ui("stacks") end, { desc = "DAP: Toggle Stacks" })
    vim.keymap.set("n", "<leader>dw", function() toggle_debug_ui("watches") end, { desc = "DAP: Toggle Watches" })
    vim.keymap.set("n", "<leader>db", function() toggle_debug_ui("breakpoints") end, { desc = "DAP: Toggle Breakpoints" })
    vim.keymap.set("n", "<leader>dS", function() toggle_debug_ui("scopes") end, { desc = "DAP: Toggle Scopes" })
    vim.keymap.set("n", "<leader>dC", function() toggle_debug_ui("console") end, { desc = "DAP: Toggle Console" })
    vim.keymap.set({ "n", "v" }, "<leader>de", function() dapui.eval(nil, { enter = true }) end,
      { desc = "DAP: Eval under cursor" })
  end
}
