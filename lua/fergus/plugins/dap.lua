--:q
--
--


return {
  "mfussenegger/nvim-dap",
  dependencies = {
    "wojciech-kulik/xcodebuild.nvim"
  },
  config = function()
    local xcodebuild = require("xcodebuild.integrations.dap")
    xcodebuild.setup()

    vim.keymap.set("n", "<leader>dd", xcodebuild.build_and_debug, { desc = "Build & Debug" })
    vim.keymap.set("n", "<leader>dr", xcodebuild.debug_without_build, { desc = "Debug Without Building" })
    vim.keymap.set("n", "<leader>dt", xcodebuild.debug_tests, { desc = "Debug Tests" })
    vim.keymap.set("n", "<leader>dT", xcodebuild.debug_class_tests, { desc = "Debug Class Tests" })
    vim.keymap.set("n", "<leader>b", xcodebuild.toggle_breakpoint, { desc = "Toggle Breakpoint" })
    vim.keymap.set("n", "<leader>B", xcodebuild.toggle_message_breakpoint, { desc = "Toggle Message Breakpoint" })
    vim.keymap.set("n", "<leader>dx", xcodebuild.terminate_session, { desc = "Terminate Debugger" })
  end,
}
-- return {
--  "mfussenegger/nvim-dap",
--  dependencies = {
--    "williamboman/mason.nvim",
--    "jay-babu/mason-nvim-dap.nvim",
--    "wojciech-kulik/xcodebuild.nvim",
--  },
--  config = function()
--    local dap = require("dap")
--    local mason_dap = require("mason-nvim-dap")
--
--    dap.set_log_level("DEBUG")
--
--    mason_dap.setup({
--      ensure_installed = {
--        "delve",    -- Go
--        "codelldb", -- C++/Rust
--      },
--      automatic_installation = true,
--      handlers = {
--        function(config)
--          mason_dap.default_setup(config)
--        end,
--        -- Custom Go (Delve) config to ask for args
--        delve = function(config)
--          table.insert(config.configurations, 1, {
--            type = "delve",
--            name = "Debug File (Ask for Args)",
--            request = "launch",
--            program = "${file}",
--            args = function() return vim.split(vim.fn.input("args> "), " ") end,
--          })
--          mason_dap.default_setup(config)
--        end,
--      },
--    })
--
--    vim.keymap.set("n", "<leader>d:", dap.continue, { desc = "Debug: Continue" })
--    vim.keymap.set("n", "<leader>d>", dap.step_over, { desc = "Debug: Step Over" })
--    vim.keymap.set("n", "<leader>d_", dap.step_into, { desc = "Debug: Step Into" })
--    vim.keymap.set("n", "<leader>d<", dap.step_out, { desc = "Debug: Step Out" })
--    vim.keymap.set("n", "<leader>b", dap.toggle_breakpoint, { desc = "Debug: Toggle Breakpoint" })
--    vim.keymap.set("n", "<leader>B", function()
--      dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
--    end, { desc = "Debug: Set Conditional Breakpoint" })
--
--    vim.api.nvim_create_augroup("DapGroup", { clear = true })
--
--    local function navigate(args)
--      local buffer = args.buf
--      local win_ids = vim.api.nvim_list_wins()
--      for _, win_id in ipairs(win_ids) do
--        if vim.api.nvim_win_get_buf(win_id) == buffer then
--          vim.schedule(function()
--            if vim.api.nvim_win_is_valid(win_id) then
--              vim.api.nvim_set_current_win(win_id)
--            end
--          end)
--          return
--        end
--      end
--    end
--
--    local function focus_on_open(name)
--      return {
--        group = "DapGroup",
--        pattern = string.format("*%s*", name), -- Matches buffer names like *dap-repl*
--        callback = navigate
--      }
--    end
--
--    -- Apply focus logic to REPL and Watches
--    vim.api.nvim_create_autocmd("BufWinEnter", focus_on_open("dap-repl"))
--    vim.api.nvim_create_autocmd("BufWinEnter", focus_on_open("DAP Watches"))
--
--    -- Force wrap in REPL
--    vim.api.nvim_create_autocmd("BufEnter", {
--      group = "DapGroup",
--      pattern = "*dap-repl*",
--      callback = function() vim.wo.wrap = true end,
--    })
--  end,
--}
