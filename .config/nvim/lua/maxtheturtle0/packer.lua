local fn = vim.fn
local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({
        'git', 'clone', 'https://github.com/wbthomason/packer.nvim', install_path
    })
    vim.api.nvim_command 'packadd packer.nvim'
end

local ok, packer = pcall(require, "packer")
if not ok then return end

vim.cmd [[packadd packer.nvim]] 

return packer.startup(function(use)
    -- Packer can manage itself 
    use 'wbthomason/packer.nvim'
    use 'ThePrimeagen/vim-be-good'
    use 'folke/tokyonight.nvim'
    -- use 'github/copilot.vim'
    use 'christoomey/vim-tmux-navigator'

    -- Telescope and its dependencies
    use {
        'nvim-telescope/telescope.nvim', tag = '0.1.8',
        requires = { {'nvim-lua/plenary.nvim'} }
    }
    -- Fzf-native extension for Telescope
    use {
        'nvim-telescope/telescope-fzf-native.nvim',
        run = 'make',
        cond = vim.fn.executable('make') == 1
    }

    use ('nvim-treesitter/nvim-treesitter', {run = ':TSUpdate'})

    use({
        "folke/trouble.nvim",
        config = function()
            require("trouble").setup {}
        end
    })

    use {
        'VonHeikemen/lsp-zero.nvim',
        branch = 'v2.x',
        requires = {
            {'neovim/nvim-lspconfig'},
            {'williamboman/mason.nvim'},
            {'williamboman/mason-lspconfig.nvim'},
            {'hrsh7th/nvim-cmp'},
            {'hrsh7th/cmp-nvim-lsp'},
            {'L3MON4D3/LuaSnip'},
        }
    }

    use 'fatih/vim-go'
    use 'theprimeagen/harpoon'
    use 'mbbill/undotree'

    use {
        'lewis6991/gitsigns.nvim',
        config = function()
            require('gitsigns').setup()
        end
    }

end)
