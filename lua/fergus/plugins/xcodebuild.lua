return {
  "wojciech-kulik/xcodebuild.nvim",
  commit = "84419f4068381489654e07e25f32f038f1f674f2",
  dependencies = {
    "nvim-telescope/telescope.nvim",
    "MunifTanjim/nui.nvim",
  },
  config = function()
    require("xcodebuild").setup({
      code_coverage = {
        enabled = true,
      },
      integrations = {
        nvim_lsp = {
          enabled = true,
        },
      },
    })
    vim.keymap.set("n", "<leader>xl", "<cmd>XcodebuildToggleLogs<cr>", { desc = "Toggle Logs" })
    vim.keymap.set("n", "<leader>xb", "<cmd>XcodebuildBuild<cr>", { desc = "Build Project" })
    vim.keymap.set("n", "<leader>xr", "<cmd>XcodebuildBuildRun<cr>", { desc = "Build & Run Project" })
    vim.keymap.set("n", "<leader>xp", "<cmd>XcodebuildPicker<cr>", { desc = "Open Xcodebuild Picker" })
    vim.keymap.set("n", "<leader>xd", "<cmd>XcodebuildSelectDevice<cr>", { desc = "Open Xcodebuild Device Selector" })
  end
}
