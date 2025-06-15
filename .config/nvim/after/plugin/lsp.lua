-- lsp.lua
local lsp = require('lsp-zero').preset({
  name               = 'recommended',
  set_lsp_keymaps    = false,
  manage_nvim_cmp    = false,
})

-- ╭─────────────────────────────────────────────────────────╮
-- │ Override the default floating‐preview to add padding │
-- ╰─────────────────────────────────────────────────────────╯
do
  local orig_open_floating_preview = vim.lsp.util.open_floating_preview

  vim.lsp.util.open_floating_preview = function(contents, syntax, opts, ...)
    -- ensure opts always exists, defaulting to a rounded border
    opts = vim.tbl_extend('force', { border = 'rounded' }, opts or {})

    -- if the server gave us a single string, split it into lines
    if type(contents) == 'string' then
      contents = vim.split(contents, '\n', { plain = true })
    end

    -- insert a blank line at the top and bottom
    table.insert(contents, 1, '')
    table.insert(contents, '')

    -- add a single‐space gutter left & right of every line
    for i, line in ipairs(contents) do
      contents[i] = ' ' .. line .. ' '
    end

    -- call the original with our padded contents
    return orig_open_floating_preview(contents, syntax, opts, ...)
  end
end

-- ╭────────────────────────────────────────────────╮
-- │ on_attach: your custom LSP keybindings here │
-- ╰────────────────────────────────────────────────╯
lsp.on_attach(function(client, bufnr)
  local opts = { buffer = bufnr, remap = false }
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
  vim.keymap.set('n', '<leader>vws', vim.lsp.buf.workspace_symbol, opts)
  vim.keymap.set('n', '<leader>vd', vim.diagnostic.open_float, opts)
  vim.keymap.set('n', '[d', vim.diagnostic.goto_next, opts)
  vim.keymap.set('n', ']d', vim.diagnostic.goto_prev, opts)
  vim.keymap.set('n', '<leader>vca', vim.lsp.buf.code_action, opts)
  vim.keymap.set('n', '<leader>vrr', vim.lsp.buf.references, opts)
  vim.keymap.set('n', '<leader>vrn', vim.lsp.buf.rename, opts)
  vim.keymap.set('i', '<C-h>', vim.lsp.buf.signature_help, opts)
end)

-- ╭─────────────────────────────────────────────────────────╮
-- │ nvim-cmp setup (borders are still handled here too) │
-- ╰─────────────────────────────────────────────────────────╯
local cmp = require('cmp')
cmp.setup({
  window = {
    completion    = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  },
  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert(),
  sources = {
    { name = 'nvim_lsp' },
  },
})

-- keep the signcolumn open to avoid width‐jumps
vim.opt.signcolumn = 'yes'

-- merge cmp_nvim_lsp capabilities before any lspconfig setups
local lspconfig = require('lspconfig')
lspconfig.util.default_config.capabilities = vim.tbl_deep_extend(
  'force',
  lspconfig.util.default_config.capabilities,
  require('cmp_nvim_lsp').default_capabilities()
)

-- finally kick off the servers
lsp.setup()
