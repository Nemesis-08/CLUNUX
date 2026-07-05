-- 1. System Settings & UI Layout
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.termguicolors = true
vim.opt.signcolumn = "yes"
vim.opt.background = "dark"

-- Tabs & Indentation
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

-- Search & Clipboard
vim.opt.clipboard = "unnamedplus"
vim.opt.ignorecase = true
vim.opt.smartcase = true


-- 2. Keymaps & Motion Swaps (h <-> n, l <-> m, k<->j)

local motion_swaps = {
	{ lhs = "h", rhs = "n", desc = "Repeat search forward" },
	{ lhs = "l", rhs = "m", desc = "Set mark" },
	{ lhs = "n", rhs = "h", desc = "Move left" },
    { lhs = "m", rhs = "l", desc = "Move right" },
    { lhs = "k", rhs = "j", desc = "Move down"},
    { lhs = "j", rhs = "k", desc = "Move up"},
}

for _, map in ipairs(motion_swaps) do
	vim.keymap.set({ "n", "v", "o" }, map.lhs, map.rhs, { desc = map.desc })
end

-- Visual mode search-repeat overrides
vim.keymap.set("v", "M", "n", { desc = "Extend selection to next match" })
vim.keymap.set("v", "N", "N", { desc = "Extend selection to previous match" })

-- 3. Plugin Management (vim.pack >= Neovim 0.12)
if not vim.fn.has("nvim-0.12") then
	vim.notify("init.lua: vim.pack requires Neovim >= 0.12", vim.log.levels.WARN)
	return
end

vim.pack.add({
	"https://github.com/nvim-tree/nvim-web-devicons",
	"https://github.com/nvim-lualine/lualine.nvim",
	"https://github.com/kbraggins/duskhaven.nvim",
})

-- 4. Colorscheme (duskhaven.nvim)
vim.cmd.colorscheme("duskhaven")

-- Make the background transparent so the terminal's own background shows
-- through. Re-applied on every ColorScheme event so it survives :colorscheme
-- reloads or plugin updates that redefine these groups.
local transparent_groups = {
	"Normal",
	"NormalNC",
	"NormalFloat",
	"SignColumn",
	"EndOfBuffer",
	"LineNr",
	"CursorLineNr",
	"WinSeparator",
	"Pmenu",
	"FloatBorder",
	"TabLine",
	"TabLineFill",
}

local function set_transparent_bg()
	for _, group in ipairs(transparent_groups) do
		vim.api.nvim_set_hl(0, group, { bg = "none" })
	end
end

set_transparent_bg()
vim.api.nvim_create_autocmd("ColorScheme", {
	pattern = "*",
	callback = set_transparent_bg,
})

-- 5. Statusline (Lualine) Configuration
require("nvim-web-devicons").setup({})

-- Original bottom-bar palette, kept from before duskhaven was added.
local palette = {
	black = "#000000",
	white = "#ffffff",
	light = "#ed8a42",
	solid = "#f93d0e",
	rust  = "#c1440e",
}

local lualine_theme = {
	normal   = { a = { fg = palette.black, bg = palette.solid, gui = "bold" }, b = { fg = palette.light, bg = palette.black }, c = { fg = palette.light, bg = palette.black } },
	insert   = { a = { fg = palette.black, bg = palette.light, gui = "bold" }, b = { fg = palette.light, bg = palette.black }, c = { fg = palette.light, bg = palette.black } },
	visual   = { a = { fg = palette.black, bg = palette.white, gui = "bold" }, b = { fg = palette.light, bg = palette.black }, c = { fg = palette.light, bg = palette.black } },
	replace  = { a = { fg = palette.white, bg = palette.rust,  gui = "bold" }, b = { fg = palette.light, bg = palette.black }, c = { fg = palette.light, bg = palette.black } },
	command  = { a = { fg = palette.white, bg = palette.solid, gui = "bold" }, b = { fg = palette.light, bg = palette.black }, c = { fg = palette.light, bg = palette.black } },
	inactive = { a = { fg = palette.rust, bg = palette.black }, b = { fg = palette.rust, bg = palette.black }, c = { fg = palette.rust, bg = palette.black } },
}

require("lualine").setup({
	options = {
		theme = lualine_theme,
		component_separators = "",
		section_separators = "",
		globalstatus = true,
	},
	sections = {
		lualine_a = { "mode" },
		lualine_b = { "branch" },
		lualine_c = { "filename" },
		lualine_x = { "diagnostics" },
		lualine_y = { "filetype" },
		lualine_z = { "location" },
	},
})
