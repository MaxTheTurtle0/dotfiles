local telescope = require('telescope')
local builtin = require('telescope.builtin')

telescope.setup{
    defaults = {
        sorting_strategy = "ascending",
        -- Ignore common directories for performance
        file_ignore_patterns = {"node_modules", ".git", "dist", "build"},
        -- Use ripgrep for grepping
        vimgrep_arguments = {
            'rg',
            '--color=never',
            '--no-heading',
            '--with-filename',
            '--line-number',
            '--column',
            '--smart-case'
        },
        prompt_prefix = "🔍 ",
        selection_caret = " ",
        path_display = {"smart"},
    },
    pickers = {
        find_files = {
            -- Use fd (faster than find) if installed
            find_command = {"fd", "--type", "f", "--hidden", "--exclude", ".git", "--exclude", "node_modules"}
        }
    },
    extensions = {
        fzf = {
            fuzzy = true,                    -- enable fuzzy matching
            override_generic_sorter = true,  -- override Telescope's generic sorter
            override_file_sorter = true,     -- override Telescope's file sorter
            case_mode = "smart_case",        -- or "ignore_case" or "respect_case"
        }
    }
}

-- Load the fzf extension if available
pcall(function() telescope.load_extension('fzf') end)

-- Keybindings
vim.keymap.set('n', '<leader>pf', builtin.find_files, {})
vim.keymap.set('n', '<C-p>', builtin.git_files, {})
vim.keymap.set('n', '<leader>ps', function()
    builtin.grep_string({
        search = vim.fn.input('Grep String > '),
    })
end)

