-- Line numbers & visual layout
vim.opt.number = true          -- Show line numbers
vim.opt.relativenumber = true  -- Relative numbers (huge for jumping lines quickly in i3)
vim.opt.termguicolors = true   -- True color theme support
vim.opt.signcolumn = "yes"     -- Prevents layout jumping when linting errors pop up
vim.opt.background = "dark"    -- Tell Neovim (and any defaults that key off it) we're dark

-- Tabs & Indentation
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true       -- Spaces over tabs

-- Quality of life & Clipboard
vim.opt.clipboard = "unnamedplus" -- Directly binds Neovim yank/paste to your X11/i3wm system clipboard
vim.opt.ignorecase = true      -- Smart search indexing
vim.opt.smartcase = true

-- ===========================================================================
-- Motion remap: swap h<->n and l<->m
-- (n/j/k/m become the new left/down/up/right cluster)
-- Applied to normal, visual, and operator-pending so `dn`/`dm` etc. line up
-- with the new motions too.
-- ===========================================================================
local motion_swaps = {
	{ lhs = "h", rhs = "n", desc = "Repeat search forward (n's old job)" },
	{ lhs = "n", rhs = "h", desc = "Move left (h's old job)" },
	{ lhs = "l", rhs = "m", desc = "Set mark (m's old job)" },
	{ lhs = "m", rhs = "l", desc = "Move right (l's old job)" },
}
for _, map in ipairs(motion_swaps) do
	vim.keymap.set({ "n", "v", "o" }, map.lhs, map.rhs, { desc = map.desc })
end

-- Lowercase n now moves the cursor left, so its old "repeat search forward"
-- job is relocated to Shift+M, scoped to visual mode so it extends the
-- current selection to the next match. Shift+N already does the same thing
-- backwards by default — restated explicitly so the pair lives together.
vim.keymap.set("v", "M", "n", { desc = "Extend selection to next search match" })
vim.keymap.set("v", "N", "N", { desc = "Extend selection to previous search match" })

-- ===========================================================================
-- Plugins
-- Uses vim.pack, Neovim's built-in plugin manager (requires Neovim >= 0.12,
-- released March 2026). No third-party bootstrapping needed.
-- nvim-treesitter is intentionally skipped here — it was archived by its
-- maintainer in April 2026 after a rewrite controversy, and Neovim's built-in
-- treesitter highlighting already covers bundled languages without it.
-- ===========================================================================
if not vim.fn.has("nvim-0.12") then
	vim.notify(
		"init.lua: vim.pack needs Neovim >= 0.12 — plugins and the custom theme below were skipped. "
			.. "Upgrade Neovim, or ask for a lazy.nvim version of this config instead.",
		vim.log.levels.WARN
	)
	return
end

vim.pack.add({
	"https://github.com/nvim-tree/nvim-web-devicons",
	"https://github.com/nvim-lualine/lualine.nvim",
})

-- ===========================================================================
-- Colorscheme — same five colors as yazi.toml / theme.toml, same roles:
--   orange = primary / active accent (mirrors Yazi's cwd, border, "normal" mode)
--   purple = secondary / select accent (mirrors Yazi's "select" mode)
--   dark red = danger / destructive accent (mirrors Yazi's "cut"/error colors)
-- ===========================================================================
local palette = {
	black  = "#000000",
	white  = "#ffffff",
	orange = "#f93d0e",
	purple = "#6c008a",
	red    = "#9b0000",
}

local highlights = {
	-- Base UI
	Normal        = { fg = palette.white, bg = palette.black },
	NormalFloat   = { fg = palette.white, bg = palette.black },
	CursorLine    = { bg = palette.black },
	CursorLineNr  = { fg = palette.orange, bold = true },
	LineNr        = { fg = palette.white },
	Visual        = { bg = palette.purple },
	Search        = { fg = palette.black, bg = palette.orange }, -- mirrors find_keyword
	IncSearch     = { fg = palette.white, bg = palette.purple, bold = true }, -- mirrors find_position
	MatchParen    = { fg = palette.black, bg = palette.orange, bold = true },
	StatusLine    = { fg = palette.white, bg = palette.black },
	StatusLineNC  = { fg = palette.white, bg = palette.black },
	WinSeparator  = { fg = palette.orange }, -- mirrors Yazi's pane border color
	SignColumn    = { bg = palette.black },
	Pmenu         = { fg = palette.white, bg = palette.black },
	PmenuSel      = { fg = palette.black, bg = palette.orange, bold = true },
	NonText       = { fg = palette.black }, -- hides end-of-buffer "~" cleanly
	EndOfBuffer   = { fg = palette.black },

	-- Syntax (also covers most @treesitter captures via Neovim's default links)
	Comment       = { fg = palette.purple, italic = true },
	Constant      = { fg = palette.purple },
	String        = { fg = palette.purple },
	Number        = { fg = palette.purple },
	Boolean       = { fg = palette.purple, bold = true },
	Identifier    = { fg = palette.white },
	Function      = { fg = palette.white, bold = true },
	Statement     = { fg = palette.orange, bold = true },
	Keyword       = { fg = palette.orange, bold = true },
	Conditional   = { fg = palette.orange, bold = true },
	Repeat        = { fg = palette.orange, bold = true },
	Operator      = { fg = palette.white },
	PreProc       = { fg = palette.orange },
	Type          = { fg = palette.white, bold = true },
	Special       = { fg = palette.orange },
	Underlined    = { fg = palette.white, underline = true },
	Error         = { fg = palette.white, bg = palette.red, bold = true },
	Todo          = { fg = palette.black, bg = palette.orange, bold = true },

	-- Diagnostics
	DiagnosticError = { fg = palette.red },
	DiagnosticWarn  = { fg = palette.orange },
	DiagnosticInfo  = { fg = palette.purple },
	DiagnosticHint  = { fg = palette.white },

	-- Diff
	DiffAdd     = { fg = palette.black, bg = palette.orange },
	DiffChange  = { fg = palette.black, bg = palette.purple },
	DiffDelete  = { fg = palette.white, bg = palette.red },
	DiffText    = { fg = palette.white, bg = palette.purple, bold = true },
}

for group, spec in pairs(highlights) do
	vim.api.nvim_set_hl(0, group, spec)
end

-- ===========================================================================
-- Statusline — themed to match, with flat separators (no rounded pill caps),
-- same treatment as the status bar fix in theme.toml.
-- ===========================================================================
require("nvim-web-devicons").setup({})

local lualine_theme = {
	normal  = { a = { fg = palette.black, bg = palette.orange, gui = "bold" }, b = { fg = palette.white, bg = palette.black }, c = { fg = palette.white, bg = palette.black } },
	insert  = { a = { fg = palette.black, bg = palette.white,  gui = "bold" }, b = { fg = palette.white, bg = palette.black }, c = { fg = palette.white, bg = palette.black } },
	visual  = { a = { fg = palette.black, bg = palette.purple, gui = "bold" }, b = { fg = palette.white, bg = palette.black }, c = { fg = palette.white, bg = palette.black } },
	replace = { a = { fg = palette.white, bg = palette.red,    gui = "bold" }, b = { fg = palette.white, bg = palette.black }, c = { fg = palette.white, bg = palette.black } },
	command = { a = { fg = palette.white, bg = palette.orange, gui = "bold" }, b = { fg = palette.white, bg = palette.black }, c = { fg = palette.white, bg = palette.black } },
	inactive = { a = { fg = palette.white, bg = palette.black }, b = { fg = palette.white, bg = palette.black }, c = { fg = palette.white, bg = palette.black } },
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
