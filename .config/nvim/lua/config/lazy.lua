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

vim.keymap.set('n', '<leader>y', '"+y', opts)

-- visual (and block visual) selection -> yank to + register
vim.keymap.set('v', '<leader>y', '"+y', opts)
-- or explicitly for visual-block too:
vim.keymap.set('x', '<leader>y', '"+y', opts)

-- convenience: yank whole line to clipboard
vim.keymap.set('n', '<leader>Y', '"+yy', opts)

-- Create the undodir if it doesn't exist
local undodir = vim.fn.expand(vim.opt.undodir:get()[1])
if vim.fn.isdirectory(undodir) == 0 then
    vim.fn.mkdir(undodir, "p")
end

vim.opt.scrolloff = 8

vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

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
    },

    -- trouble.nvim:
    -- Lazy-load on its command.
    {
      "folke/trouble.nvim",
      opts = {}, -- for default options, refer to the configuration section for custom setup.
      cmd = "Trouble",
      keys = {
        {
          "<leader>xx",
          "<cmd>Trouble diagnostics toggle<cr>",
          desc = "Diagnostics (Trouble)",
        },
        {
          "<leader>xX",
          "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
          desc = "Buffer Diagnostics (Trouble)",
        },
        {
          "<leader>cs",
          "<cmd>Trouble symbols toggle focus=false<cr>",
          desc = "Symbols (Trouble)",
        },
        {
          "<leader>cl",
          "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
          desc = "LSP Definitions / references / ... (Trouble)",
        },
        {
          "<leader>xL",
          "<cmd>Trouble loclist toggle<cr>",
          desc = "Location List (Trouble)",
        },
        {
          "<leader>xQ",
          "<cmd>Trouble qflist toggle<cr>",
          desc = "Quickfix List (Trouble)",
        },
      },
    },
    -- LSP, DAP, and Formatting
{
    -- Mason: The plugin that manages LSP servers, DAPs, linters, etc.
    -- We load it on startup (`lazy = false`) to ensure the :Mason command
    -- is always available.
    'williamboman/mason.nvim',
    lazy = false,
    config = true, -- This just runs the default config for mason.
},
{
    -- mason-lspconfig: The bridge between Mason and lspconfig.
    -- It reads the servers you have installed with Mason and helps
    -- lspconfig start them.
    'williamboman/mason-lspconfig.nvim',
    -- No need for lazy-loading triggers; it's a dependency of lspconfig.
},

-- Autocompletion Engine
{
    'hrsh7th/nvim-cmp',
    event = 'InsertEnter', -- Load when you enter insert mode
    dependencies = {
        'hrsh7th/cmp-nvim-lsp', -- Source for LSP completions
        'L3MON4D3/LuaSnip',     -- Snippet engine
    },
    config = function()
        local cmp = require('cmp')
        local luasnip = require('luasnip')

        cmp.setup({
            snippet = {
                expand = function(args)
                    luasnip.lsp_expand(args.body)
                end,
            },
            -- Your custom window borders from your original config
            window = {
                completion = cmp.config.window.bordered(),
                documentation = cmp.config.window.bordered(),
            },
            mapping = cmp.mapping.preset.insert({
                ['<C-Space>'] = cmp.mapping.complete(),
                ['<CR>'] = cmp.mapping.confirm({ select = true }),
                ['<C-u>'] = cmp.mapping.scroll_docs(-4),
                ['<C-d>'] = cmp.mapping.scroll_docs(4),
            }),
            -- Your sources from your original config
            sources = {
                { name = 'nvim_lsp' },
                { name = 'luasnip' },
            },
        })
    end,
},

-- The main LSP configuration driver
{
    'neovim/nvim-lspconfig',
    event = { 'BufReadPre', 'BufNewFile' }, -- Load when you open a file
    dependencies = {
        'hrsh7th/cmp-nvim-lsp',
        'williamboman/mason.nvim',
        'williamboman/mason-lspconfig.nvim',
    },
    config = function()
        -- THIS IS WHERE WE PUT YOUR CUSTOM CONFIGS

        -- 1. Your custom floating preview with padding
        do
            local orig_open_floating_preview =
                vim.lsp.util.open_floating_preview

            vim.lsp.util.open_floating_preview = function(
                contents,
                syntax,
                opts,
                ...
            )
                opts = vim.tbl_extend(
                    'force',
                    { border = 'rounded' },
                    opts or {}
                )
                if type(contents) == 'string' then
                    contents = vim.split(contents, '\n', { plain = true })
                end
                table.insert(contents, 1, '')
                table.insert(contents, '')
                for i, line in ipairs(contents) do
                    contents[i] = ' ' .. line .. ' '
                end
                return orig_open_floating_preview(
                    contents,
                    syntax,
                    opts,
                    ...
                )
            end
        end

        -- 2. Set up LSP capabilities to work with nvim-cmp
        local capabilities =
            require('cmp_nvim_lsp').default_capabilities()

        -- 3. Your custom keymaps, placed inside the LspAttach autocommand
        -- This is the best practice, as it only sets the keymaps for buffers
        -- where an LSP server is actually running.
        vim.api.nvim_create_autocmd('LspAttach', {
            group = vim.api.nvim_create_augroup(
                'UserLspConfig',
                {}
            ),
            callback = function(ev)
                local opts = { buffer = ev.buf, remap = false }
                -- Your keymaps from after/plugin/lsp.lua
                vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
                vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
                vim.keymap.set(
                    'n',
                    '<leader>vws',
                    vim.lsp.buf.workspace_symbol,
                    opts
                )
                vim.keymap.set(
                    'n',
                    '<leader>vd',
                    vim.diagnostic.open_float,
                    opts
                )
                vim.keymap.set(
                    'n',
                    '[d',
                    vim.diagnostic.goto_next,
                    opts
                )
                vim.keymap.set(
                    'n',
                    ']d',
                    vim.diagnostic.goto_prev,
                    opts
                )
                vim.keymap.set(
                    'n',
                    '<leader>vca',
                    vim.lsp.buf.code_action,
                    opts
                )
                vim.keymap.set(
                    'n',
                    '<leader>vrr',
                    vim.lsp.buf.references,
                    opts
                )
                vim.keymap.set(
                    'n',
                    '<leader>vrn',
                    vim.lsp.buf.rename,
                    opts
                )
                vim.keymap.set(
                    'i',
                    '<C-h>',
                    vim.lsp.buf.signature_help,
                    opts
                )
            end,
        })

        -- 4. Configure mason-lspconfig to set up servers
        require('mason-lspconfig').setup({
            -- A list of servers to automatically install if they're not already.
            -- Example: ensure_installed = { "gopls", "lua_ls", "tsserver" }
            ensure_installed = {},
            handlers = {
                -- The default handler for servers.
                function(server_name)
                    require('lspconfig')[server_name].setup({
                        capabilities = capabilities,
                    })
                end,

                -- You can add custom handlers for specific servers here.
                -- For example, for gopls:
                -- ["gopls"] = function()
                --     require('lspconfig').gopls.setup({
                --         capabilities = capabilities,
                --         settings = {
                --             gopls = {
                --                 -- your custom settings
                --             }
                --         }
                --     })
                -- end,
            },
        })

        -- Keep the signcolumn open to avoid width-jumps
        vim.opt.signcolumn = 'yes'
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
        },
    })
