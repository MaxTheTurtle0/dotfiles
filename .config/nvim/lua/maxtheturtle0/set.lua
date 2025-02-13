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
