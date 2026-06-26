-- =============================================================================
-- 1. System Settings & UI Layout
-- =============================================================================
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

-- =============================================================================
-- 2. Keymaps & Motion Swaps (h <-> n, l <-> m)
-- =============================================================================
local motion_swaps = {
	{ lhs = "h", rhs = "n", desc = "Repeat search forward" },
	{ lhs = "n", rhs = "h", desc = "Move left" },
	{ lhs = "l", rhs = "m", desc = "Set mark" },
	{ lhs = "m", rhs = "l", desc = "Move right" },
}

for _, map in ipairs(motion_swaps) do
	vim.keymap.set({ "n", "v", "o" }, map.lhs, map.rhs, { desc = map.desc })
end

-- Visual mode search-repeat overrides
vim.keymap.set("v", "M", "n", { desc = "Extend selection to next match" })
vim.keymap.set("v", "N", "N", { desc = "Extend selection to previous match" })

-- =============================================================================
-- 3. Plugin Management (vim.pack >= Neovim 0.12)
-- =============================================================================
if not vim.fn.has("nvim-0.12") then
	vim.notify("init.lua: vim.pack requires Neovim >= 0.12", vim.log.levels.WARN)
	return
end

vim.pack.add({
	"https://github.com/nvim-tree/nvim-web-devicons",
	"https://github.com/nvim-lualine/lualine.nvim",
})

-- =============================================================================
-- 4. Colorscheme & Highlights
-- =============================================================================
local palette = {
	black = "#000000",
	white = "#ffffff",
	light = "#ed8a42",
	solid = "#f93d0e",
	rust  = "#c1440e",
}

local highlights = {
	-- Base UI
	["Normal"]        = { fg = palette.light, bg = palette.black },
	["NormalFloat"]   = { fg = palette.light, bg = palette.black },
	["CursorLine"]    = { bg = "#1a0e08" },
	["CursorLineNr"]  = { fg = palette.solid, bold = true },
	["LineNr"]        = { fg = palette.rust },
	["Visual"]        = { fg = palette.black, bg = palette.white, bold = true },
	["Search"]        = { fg = palette.black, bg = palette.solid, bold = true },
	["IncSearch"]     = { fg = palette.black, bg = palette.white, bold = true },
	["MatchParen"]    = { fg = palette.black, bg = palette.solid, bold = true },
	["StatusLine"]    = { fg = palette.black, bg = palette.solid, bold = true },
	["StatusLineNC"]  = { fg = palette.rust, bg = palette.black },
	["WinSeparator"]  = { fg = palette.light },
	["SignColumn"]    = { bg = palette.black },
	["Pmenu"]         = { fg = palette.light, bg = palette.black },
	["PmenuSel"]      = { fg = palette.black, bg = palette.solid, bold = true },
	["NonText"]       = { fg = palette.black },
	["EndOfBuffer"]   = { fg = palette.black },

	-- Syntax
	["Comment"]       = { fg = palette.rust, italic = true },
	["Constant"]      = { fg = palette.white },
	["String"]        = { fg = palette.white },
	["Number"]        = { fg = palette.white },
	["Boolean"]       = { fg = palette.white, bold = true },
	["Identifier"]    = { fg = palette.light },
	["Function"]      = { fg = palette.white, bold = true },
	["Statement"]     = { fg = palette.solid, bold = true },
	["Keyword"]       = { fg = palette.solid, bold = true },
	["Conditional"]   = { fg = palette.solid, bold = true },
	["Repeat"]        = { fg = palette.solid, bold = true },
	["Operator"]      = { fg = palette.light },
	["PreProc"]       = { fg = palette.white },
	["Type"]          = { fg = palette.solid },
	["Special"]       = { fg = palette.white },
	["Underlined"]    = { fg = palette.white, underline = true },
	["Error"]         = { fg = palette.white, bg = palette.rust, bold = true },
	["Todo"]          = { fg = palette.black, bg = palette.solid, bold = true },

	-- Diagnostics
	["DiagnosticError"] = { fg = palette.rust },
	["DiagnosticWarn"]  = { fg = palette.solid },
	["DiagnosticInfo"]  = { fg = palette.white },
	["DiagnosticHint"]  = { fg = palette.light },

	-- Diff
	["DiffAdd"]     = { bg = palette.light, fg = palette.black },
	["DiffChange"]  = { bg = palette.solid, fg = palette.black },
	["DiffDelete"]  = { bg = palette.rust,  fg = palette.white },
	["DiffText"]    = { bg = palette.white, fg = palette.black, bold = true },
}

for group, spec in pairs(highlights) do
	vim.api.nvim_set_hl(0, group, spec)
end

-- =============================================================================
-- 5. Statusline (Lualine) Configuration
-- =============================================================================
require("nvim-web-devicons").setup({})

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
