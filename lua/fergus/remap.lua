vim.g.mapleader = " "
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

vim.keymap.set("n", "J", "mzJ`z")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

--paste without overwriting register
vim.keymap.set("x", "<leader>p", [["_dP]])

vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])

vim.keymap.set({ "n", "v" }, "<leader>D", [["_d]])

vim.keymap.set("n", "Q", "<nop>")
vim.keymap.set("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>")
vim.keymap.set("n", "<leader>f", vim.lsp.buf.format)
vim.keymap.set("i", "<C-f>", vim.lsp.buf.format)

vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])

vim.keymap.set("n", "<leader>op", ":vsp<CR>")

vim.keymap.set("n", "<leader><leader>", function()
  vim.cmd("so")
end)

-- Merge conflict resolution (fugitive 3-way split)
vim.keymap.set("n", "<leader>gms", "<cmd>Gvdiffsplit!<CR>", { desc = "Start merge split" })
vim.keymap.set("n", "<leader>gml", "<cmd>diffget //2<CR>", { desc = "Take left (LOCAL)" })
vim.keymap.set("n", "<leader>gmr", "<cmd>diffget //3<CR>", { desc = "Take right (REMOTE)" })
vim.keymap.set("n", "<leader>gmn", "]c", { desc = "Next conflict hunk" })
vim.keymap.set("n", "<leader>gmN", "[c", { desc = "Previous conflict hunk" })
vim.keymap.set("n", "<leader>gmw", "<cmd>Gwrite<CR>", { desc = "Write and stage resolved file" })
