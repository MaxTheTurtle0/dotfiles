local mark = require("harpoon.mark")
local ui = require("harpoon.ui")

vim.keymap.set("n", "<leader>a", mark.add_file)
vim.keymap.set("n", "<leader>q", ui.toggle_quick_menu)

vim.keymap.set("n", "<leader>1", function()
    mark.set_file(1)
end)

vim.keymap.set("n", "<leader>2", function()
    mark.set_file(2)
end)

vim.keymap.set("n", "<leader>3", function()
    mark.set_file(3)
end)

vim.keymap.set("n", "<leader>4", function()
    mark.set_file(4)
end)
