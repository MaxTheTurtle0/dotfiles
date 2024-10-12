vim.g.mapleader = " "
vim.g.copilot_filetypes = {markdown = true}
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

local M = {}

M.general = {
    n = {
        ["<C-h>"] = { "<cmd> TmuxNavigateLeft<CR>", "window left" },
        ["<C-l>"] = { "<cmd> TmuxNavigateRight<CR>", "window right" },
        ["<C-j>"] = { "<cmd> TmuxNavigateDown<CR>", "window down" },
        ["<C-k>"] = { "<cmd> TmuxNavigateUp<CR>", "window up" },
    }
}

vim.keymap.set(
    "n",
    "<leader>er",
    "oif err != nil {<CR>}<Esc>Oreturn err<Esc>"
)


vim.keymap.set(
    "n",
    "<leader>ee",
    "oif err != nil {<CR>}<Esc>O"
)


vim.keymap.set("v", "K", ":m '>-2<CR>gv=gv")
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz")
vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz")
vim.keymap.set('n', '<leader>u', vim.cmd.UndotreeToggle)

vim.keymap.set("n", "<leader><leader>", function()
    vim.cmd("so")
end)

vim.api.nvim_set_keymap('i', '(', '()<Left>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('i', '{', '{}<Left>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('i', '[', '[]<Left>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('i', '"', '""<Left>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('i', "'", "''<Left>", { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', 'z', '<C-v>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>pr',':%s/', { noremap = true, silent = true })
