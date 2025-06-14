-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- General Neovim Options: These are fast and don't typically impact startup
-- significantly. Keep them at the top.
vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.smartindent = true

vim.opt.termguicolors = true

-- Set up persistent undo
vim.opt.undodir = os.getenv("HOME") .. "/.undodir"
vim.opt.undofile = true

-- Create the undodir if it doesn't exist
local undodir = vim.fn.expand(vim.opt.undodir:get()[1])
if vim.fn.isdirectory(undodir) == 0 then
    vim.fn.mkdir(undodir, "p")
end

vim.opt.scrolloff = 8

-- Keymaps: These are also generally fine to be defined upfront.
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

-- M.general seems like it's not being used, consider removing it if so.
-- local M = {}
-- M.general = {
--     n = {
--         ["<C-h>"] = { "<cmd> TmuxNavigateLeft<CR>", "window left" },
--         ["<C-l>"] = { "<cmd> TmuxNavigateRight<CR>", "window right" },
--         ["<C-j>"] = { "<cmd> TmuxNavigateDown<CR>", "window down" },
--         ["<C-k>"] = { "<cmd> TmuxNavigateUp<CR>", "window up" },
--     }
-- }

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

-- lazy.nvim plugin setup
return require("lazy").setup({
    -- Colorscheme:
    -- 'tokyonight.nvim' is often loaded on startup for immediate visual feedback.
    -- `lazy = false` and `priority = 1000` are good for colorschemes. [1, 7]
    {
        "folke/tokyonight.nvim",
        lazy = false,
        priority = 1000,
        config = function()
            vim.cmd("colorscheme tokyonight")
        end,
    },

    -- vim-tmux-navigator:
    -- This plugin is used for seamless Tmux pane and Neovim window navigation.
    -- It can be lazy-loaded on the keymaps you have defined for it (C-h, C-l, C-j, C-k).
    -- You currently have these keymaps defined outside of the lazy.nvim spec.
    -- It's better to define them within the plugin's `keys` table for lazy-loading.
    {
        "christoomey/vim-tmux-navigator",
        keys = {
            { "<C-h>", "<cmd>TmuxNavigateLeft<CR>", desc = "Window left" },
            { "<C-l>", "<cmd>TmuxNavigateRight<CR>", desc = "Window right" },
            { "<C-j>", "<cmd>TmuxNavigateDown<CR>", desc = "Window down" },
            { "<C-k>", "<cmd>TmuxNavigateUp<CR>", desc = "Window up" },
        },
    },

    -- telescope.nvim:
    -- This is a prime candidate for lazy-loading on its command. [9]
    -- The `tag` and `dependencies` are correctly defined.
    {
        "nvim-telescope/telescope.nvim",
        tag = "0.1.8",
        cmd = "Telescope", -- Load when :Telescope is run
        dependencies = { "nvim-lua/plenary.nvim" },
    },
    -- telescope-fzf-native.nvim:
    -- This is a dependency of telescope and should be loaded when telescope loads.
    -- The `cond` is good for platform-specific builds.
    {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
        cond = function()
            return vim.fn.executable("make") == 1
        end,
        -- No explicit lazy-loading needed here as it's a dependency.
        -- It will be loaded when `telescope.nvim` is loaded.
    },

    -- nvim-treesitter:
    -- This can be lazy-loaded on various events, such as `BufReadPre` for
    -- syntax highlighting. The `build` step is correct.
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        event = { "BufReadPre", "BufNewFile" }, -- Load when reading/creating a buffer
        config = function()
            require("nvim-treesitter.configs").setup({
                -- Your treesitter configurations here
                ensure_installed = { "lua", "vim", "markdown", "go" }, -- Example languages
                highlight = { enable = true },
                indent = { enable = true },
            })
        end,
    },

    -- trouble.nvim:
    -- Lazy-load on its command.
    {
        "folke/trouble.nvim",
        cmd = { "TroubleToggle", "Trouble" }, -- Load when Trouble commands are run
        config = function()
            require("trouble").setup {}
        end,
    },

    -- lsp-zero.nvim:
    -- LSP setup is critical, but the components can be lazy-loaded.
    -- `lsp-zero` itself often handles the lazy-loading of its dependencies
    -- (lspconfig, mason, cmp, luasnip).
    -- A common approach is to load LSP when opening a file (`BufReadPre`)
    -- or when inserting text (`InsertEnter`).
    {
        "VonHeikemen/lsp-zero.nvim",
        branch = "v2.x",
        event = { "BufReadPre", "BufNewFile", "BufEnter" }, -- Load when entering/reading a buffer
        dependencies = {
            "neovim/nvim-lspconfig",
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",
            "hrsh7th/nvim-cmp",
            "hrsh7th/cmp-nvim-lsp",
            "L3MON4D3/LuaSnip",
        },
        config = function()
            -- Minimal setup for lsp-zero. You would typically have more here.
            local lsp = require("lsp-zero")
            lsp.setup()
            -- Example: Enable keybindings for LSP
            lsp.on_attach(function(client, bufnr)
                lsp.defaults.cmp_mappings(vim.api.nvim_buf_set_keymap, bufnr)
                lsp.defaults.lsp_mappings(vim.api.nvim_buf_set_keymap, bufnr)
            end)
        end,
    },

    -- vim-go:
    -- Lazy-load for Go filetypes.
    {
        "fatih/vim-go",
        ft = "go",
    },

    -- harpoon:
    -- Lazy-load on its commands or keymaps.
    {
        "theprimeagen/harpoon",
        cmd = { "Harpoon", "HarpoonAdd", "HarpoonMenu" },
        keys = {
            { "<leader>a", "<cmd>lua require('harpoon.mark').add_file()<CR>", desc = "Harpoon add file" },
            { "<leader>q", "<cmd>lua require('harpoon.ui').toggle_quick_menu()<CR>", desc = "Harpoon toggle menu" },
        },
        config = function()
            -- No specific setup needed for harpoon itself beyond keymaps if defined here.
        end,
    },

    -- undotree:
    -- Lazy-load on its command or keymap.
    {
        "mbbill/undotree",
        cmd = "UndotreeToggle", -- Load when :UndotreeToggle is run
        keys = { { "<leader>u", "<cmd>UndotreeToggle<CR>", desc = "Toggle Undotree" } },
        -- No specific config needed as it's a Vim plugin.
    },

    -- gitsigns.nvim:
    -- Can be loaded on `BufReadPre` or `BufEnter` for immediate feedback
    -- on git changes when opening a file.
    {
        "lewis6991/gitsigns.nvim",
        event = { "BufReadPre", "BufEnter" },
        config = function()
            require("gitsigns").setup()
        end,
    },
})
