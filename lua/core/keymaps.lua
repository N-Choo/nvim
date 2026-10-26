-- Set leader key
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Disable the spacebar key's default behavior in Normal and Visual modes
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- For conciseness
local opts = { noremap = true, silent = true }

-- save file
vim.keymap.set('n', '<C-s>', '<cmd> w <CR>', opts)

-- save file without auto-formatting
vim.keymap.set('n', '<leader>sn', '<cmd>noautocmd w <CR>', opts)

-- toggle auto-format-on-save
vim.keymap.set('n', '<leader>fa', function()
  vim.g.autoformat_on_save = not vim.g.autoformat_on_save
  vim.g.rustfmt_autosave = vim.g.autoformat_on_save and 1 or 0
  vim.notify('Auto-format on save: ' .. (vim.g.autoformat_on_save and 'ON' or 'OFF'), vim.log.levels.INFO)
end, { desc = 'Toggle auto-format on save' })

-- quit file
vim.keymap.set('n', '<C-q>', '<cmd> q <CR>', opts)

-- delete single character without copying into register
vim.keymap.set('n', 'x', '"_x', opts)

-- Vertical scroll and center
vim.keymap.set('n', '<C-d>', '<C-d>zz', opts)
vim.keymap.set('n', '<C-u>', '<C-u>zz', opts)

-- Find and center
vim.keymap.set('n', 'n', 'nzzzv', opts)
vim.keymap.set('n', 'N', 'Nzzzv', opts)

-- Buffers
vim.keymap.set('n', '<Tab>', ':bnext<CR>', opts)
vim.keymap.set('n', '<S-Tab>', ':bprevious<CR>', opts)
vim.keymap.set('n', '<leader>x', ':bdelete!<CR>', opts) -- close buffer
vim.keymap.set('n', '<leader>b', '<cmd> enew <CR>', opts) -- new buffer

-- Window management
vim.keymap.set('n', '<leader>v', '<C-w>v', opts) -- split window vertically
vim.keymap.set('n', '<leader>V', '<C-w>s', opts) -- split window horizontally
vim.keymap.set('n', '<leader>se', '<C-w>=', opts) -- make split windows equal width & height
vim.keymap.set('n', '<leader>xs', ':close<CR>', opts) -- close current split window

-- Navigere mellom splits
vim.keymap.set('n', '<leader>k', ':wincmd k<CR>', opts) -- Flytt til split over
vim.keymap.set('n', '<leader>j', ':wincmd j<CR>', opts) -- Flytt til split under
vim.keymap.set('n', '<leader>h', ':wincmd h<CR>', opts) -- Flytt til split til venstre
vim.keymap.set('n', '<leader>l', ':wincmd l<CR>', opts) -- Flytt til split til høyre
-- Tabs
vim.keymap.set('n', '<leader>to', ':tabnew<CR>', opts) -- open new tab
vim.keymap.set('n', '<leader>tx', ':tabclose<CR>', opts) -- close current tab
vim.keymap.set('n', '<leader>tn', ':tabn<CR>', opts) --  go to next tab
vim.keymap.set('n', '<leader>tp', ':tabp<CR>', opts) --  go to previous tab

-- Toggle line wrapping
vim.keymap.set('n', '<leader>lw', '<cmd>set wrap!<CR>', opts)

-- Window resize with arrows (when prefix with leader)
vim.keymap.set('n', '<leader><Up>', ':resize -2<CR>', opts)
vim.keymap.set('n', '<leader><Down>', ':resize +2<CR>', opts)
vim.keymap.set('n', '<leader><Left>', ':vertical resize -2<CR>', opts)
vim.keymap.set('n', '<leader><Right>', ':vertical resize +2<CR>', opts)

-- Stay in indent mode
vim.keymap.set('v', '<', '<gv', opts)
vim.keymap.set('v', '>', '>gv', opts)

-- Keep last yanked when pasting
vim.keymap.set('v', 'p', '"_dP', opts)

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
vim.keymap.set('n', '<leader>d', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })

-- Swap insert/append: i = right of cursor, a = left of cursor
vim.keymap.set('n', 'i', 'a', { noremap = true, silent = true, desc = 'Insert right of cursor' })
vim.keymap.set('n', 'a', 'i', { noremap = true, silent = true, desc = 'Insert left of cursor' })
vim.keymap.set('n', 'I', 'A', { noremap = true, silent = true, desc = 'Insert at end of line' })
vim.keymap.set('n', 'A', 'I', { noremap = true, silent = true, desc = 'Insert at start of line' })

-- Move current line with Arrow Up/Down
vim.keymap.set('n', '<Up>', ':m .-2<CR>==', { noremap = true, silent = true, desc = 'Move line up' })
vim.keymap.set('n', '<Down>', ':m .+1<CR>==', { noremap = true, silent = true, desc = 'Move line down' })

-- Move lines with Alt+Arrows
vim.keymap.set('n', '<M-j>', ':m .+1<CR>==', { noremap = true, silent = true })
vim.keymap.set('n', '<M-k>', ':m .-2<CR>==', { noremap = true, silent = true })
vim.keymap.set('v', '<M-j>', ":m '>+1<CR>gv=gv", { noremap = true, silent = true })
vim.keymap.set('v', '<M-k>', ":m '<-2<CR>gv=gv", { noremap = true, silent = true })

-- Show FNs
vim.keymap.set('n', '<leader>sfn', '<cmd>Telescope lsp_document_symbols<CR>', { desc = 'Se funksjoner med LSP' })
