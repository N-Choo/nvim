-- Treesitter language compatibility shim (neovim 0.10+)
require("core.options")
require("core.keymaps")
--require("core.snippets")
local ts_lang = vim.treesitter.language
if not ts_lang.ft_to_lang then
	ts_lang.ft_to_lang = ts_lang.get_lang
end

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if vim.fn.isdirectory(lazypath) == 0 then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		error("Error cloning lazy.nvim:\n" .. out)
	end
end
vim.opt.rtp:prepend(lazypath)

-- [[ Configure and install plugins ]]
--
--  To check the current status of your plugins, run
--    :Lazy
--
--  You can press `?` in this menu for help. Use `:q` to close the window
--
--  To update plugins you can run
--    :Lazy update
--
-- NOTE: Here is where you install your plugins.
-- 4. Load Plugins
require("lazy").setup({
	require("plugins.snacks"),
	require("plugins.copilot"), -- CopilotChat
	require("plugins.copilot2"), -- GitHub Copilot
	require("plugins.neotree"),
	require("plugins.bufferline"),
	require("plugins.treesitter"),
	require("plugins.lualine"),
	require("plugins.telescope"),
	require("plugins.lsp"),
	require("plugins.rustaceanvim"),
	require("plugins.autocompletion"),
	require("plugins.gitsigns"),
	require("plugins.misc"),
	require("plugins.indent-blankline"),
	require("plugins.typst"),
	require("plugins.treesitter-context"),
	require("plugins.tiny-diagnostic"),
	require("plugins.none-ls"),
	require("plugins.vbg"),
}, {
	-- image.nvim uses the ImageMagick CLI, so Lua rocks (luarocks/hererocks,
	-- which need a Lua 5.1 toolchain) are not required.
	rocks = { enabled = false },
})
