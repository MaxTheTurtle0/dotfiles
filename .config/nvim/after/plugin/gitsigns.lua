local gs = require('gitsigns')

-- Navigation
vim.keymap.set('n', ']c', gs.next_hunk, { desc = 'Next hunk' })
vim.keymap.set('n', '[c', gs.prev_hunk, { desc = 'Previous hunk' })

-- Stage and reset
vim.keymap.set('n', '<leader>gs', gs.stage_hunk, { desc = 'Stage hunk' })
vim.keymap.set('n', '<leader>gu', gs.undo_stage_hunk, { desc = 'Undo stage hunk' })
vim.keymap.set('n', '<leader>gr', gs.reset_hunk, { desc = 'Reset hunk' })

-- Line blame toggle

vim.keymap.set('n', '<leader>gb', gs.toggle_current_line_blame, { desc = 'Toggle line blame' })
