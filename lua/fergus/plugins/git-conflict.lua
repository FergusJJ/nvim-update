return {
    "akinsho/git-conflict.nvim",
    version = "*",
    event = "BufReadPre",
    config = function()
        require("git-conflict").setup({
            default_mappings = false,
            disable_diagnostics = true,
        })

        -- Merge conflict resolution (git-conflict.nvim)
        vim.keymap.set("n", "<leader>gmo", "<cmd>GitConflictChooseOurs<CR>", { desc = "Take ours (LOCAL)" })
        vim.keymap.set("n", "<leader>gmt", "<cmd>GitConflictChooseTheirs<CR>", { desc = "Take theirs (REMOTE)" })
        vim.keymap.set("n", "<leader>gmb", "<cmd>GitConflictChooseBoth<CR>", { desc = "Take both" })
        vim.keymap.set("n", "<leader>gm0", "<cmd>GitConflictChooseNone<CR>", { desc = "Take none" })
        vim.keymap.set("n", "<leader>gmn", "<cmd>GitConflictNextConflict<CR>", { desc = "Next conflict" })
        vim.keymap.set("n", "<leader>gmN", "<cmd>GitConflictPrevConflict<CR>", { desc = "Previous conflict" })
        vim.keymap.set("n", "<leader>gmq", "<cmd>GitConflictListQf<CR>", { desc = "List conflicts in quickfix" })
    end,
}
