return {
	"folke/snacks.nvim",
	priority = 1000,
	lazy = false,
	---@type snacks.Config
	opts = {
		dashboard = {
			enabled = true,
			preset = {
				header = [[
           ____  ____  _  _      ____  ____  ____ 
          / ___\/  __\/ \/ \  /|/  _ \/  _ \/  _ \
          |    \|  \/|| || |\ ||| | //| / \|| / \|
          \___ ||  __/| || | \||| |_\\| \_/|| \_/|
          \____/\_/   \_/\_/  \|\____/\____/\____/
                                          
        ]],
			},
		},
		lazygit = { enabled = true },
		picker = {
			enabled = true,
			sources = {
				files = {
					hidden = true,
				},
			},
		},
		notify = { enabled = true },
		explorer = {
			enabled = true,
		    show_hidden = true,
		},
		debug = {
			grep = true,  -- Activar debug para grep
		},
	},
	keys = {
		-- lazygit
		{
			"<leader>lg",
			function()
				Snacks.lazygit()
			end,
			desc = "Snacks: Lazygit",
		},
		-- Top Pickers & Explorer
		{
			"<leader><space>",
			function()
				Snacks.picker.smart()
			end,
			desc = "Snacks: Smart Find Files",
		},
		{
			"<leader>,",
			function()
				Snacks.picker.buffers()
			end,
			desc = "Snacks: Buffers",
		},
		-- Grep solo con prefijo sp (para mantener compatibilidad)
		{
			"<leader>spg",
			function()
				Snacks.picker.grep()
			end,
			desc = "Snacks: Grep",
		},
		{
			"<leader>spw",
			function()
				local word = vim.fn.expand("<cword>")
				Snacks.picker.grep({ search = word, word_match = "-w" })
			end,
			desc = "Snacks: Search current word",
		},
		{
			"<leader>spW",
			function()
				local selected = vim.fn.getreg('"')
				if selected and selected ~= "" then
					Snacks.picker.grep({ search = selected })
				else
					local word = vim.fn.expand("<cword>")
					Snacks.picker.grep({ search = word })
				end
			end,
			desc = "Snacks: Search selected text or current word",
			mode = { "n", "v" },
		},
		{
			"<leader>:",
			function()
				Snacks.picker.command_history()
			end,
			desc = "Snacks: Command History",
		},
		{
			"<leader>n",
			function()
				Snacks.picker.notifications()
			end,
			desc = "Snacks: Notification History",
		},
		{
			"<leader>e",
			function()
				Snacks.explorer()
			end,
			desc = "Snacks: File Explorer",
		},
		-- find
		{
			"<leader>fb",
			function()
				Snacks.picker.buffers()
			end,
			desc = "Snacks: Buffers",
		},
		{
			"<leader>fc",
			function()
				Snacks.picker.files({ cwd = vim.fn.stdpath("config") })
			end,
			desc = "Snacks: Find Config File",
		},
		{
			"<leader>ff",
			function()
				Snacks.picker.files()
			end,
			desc = "Snacks: Find Files",
		},
		{
			"<leader>/",
			function()
				Snacks.picker.git_files()
			end,
			desc = "Snacks: Find Git Files",
		},
		{
			"<leader>fp",
			function()
				Snacks.picker.projects()
			end,
			desc = "Snacks: Projects",
		},
		{
			"<leader>fr",
			function()
				Snacks.picker.recent()
			end,
			desc = "Snacks: Recent",
		},
		-- git
		{
			"<leader>gb",
			function()
				Snacks.picker.git_branches()
			end,
			desc = "Snacks: Git Branches",
		},
		{
			"<leader>gl",
			function()
				Snacks.picker.git_log()
			end,
			desc = "Snacks: Git Log",
		},
		{
			"<leader>gL",
			function()
				Snacks.picker.git_log_line()
			end,
			desc = "Snacks: Git Log Line",
		},
		{
			"<leader>gs",
			function()
				Snacks.picker.git_status()
			end,
			desc = "Snacks: Git Status",
		},
		{
			"<leader>gS",
			function()
				Snacks.picker.git_stash()
			end,
			desc = "Snacks: Git Stash",
		},
		{
			"<leader>gd",
			function()
				Snacks.picker.git_diff()
			end,
			desc = "Snacks: Git Diff (Hunks)",
		},
		{
			"<leader>gf",
			function()
				Snacks.picker.git_log_file()
			end,
			desc = "Snacks: Git Log File",
		},
		-- LSP
		{
			"gd",
			function()
				Snacks.picker.lsp_definitions()
			end,
			desc = "Snacks: Goto Definition",
		},
		{
			"gD",
			function()
				Snacks.picker.lsp_declarations()
			end,
			desc = "Snacks: Goto Declaration",
		},
		{
			"gr",
			function()
				Snacks.picker.lsp_references()
			end,
			nowait = true,
			desc = "Snacks: References",
		},
		{
			"gI",
			function()
				Snacks.picker.lsp_implementations()
			end,
			desc = "Snacks: Goto Implementation",
		},
		{
			"gy",
			function()
				Snacks.picker.lsp_type_definitions()
			end,
			desc = "Snacks: Goto T[y]pe Definition",
		},
		{
			"<leader>ss",
			function()
				Snacks.picker.lsp_symbols()
			end,
			desc = "Snacks: LSP Symbols",
		},
		{
			"<leader>sS",
			function()
				Snacks.picker.lsp_workspace_symbols()
			end,
			desc = "Snacks: LSP Workspace Symbols",
		},
		-- Other
		{
			"<leader>z",
			function()
				Snacks.zen()
			end,
			desc = "Snacks: Toggle Zen Mode",
		},
		{
			"<leader>Z",
			function()
				Snacks.zen.zoom()
			end,
			desc = "Snacks: Toggle Zoom",
		},
		{
			"<leader>.",
			function()
				Snacks.scratch()
			end,
			desc = "Snacks: Toggle Scratch Buffer",
		},
		{
			"<leader>S",
			function()
				Snacks.scratch.select()
			end,
			desc = "Snacks: Select Scratch Buffer",
		},
		{
			"<leader>bd",
			function()
				Snacks.bufdelete()
			end,
			desc = "Snacks: Delete Buffer",
		},
		{
			"<leader>cR",
			function()
				Snacks.rename.rename_file()
			end,
			desc = "Snacks: Rename File",
		},
		{
			"<leader>gB",
			function()
				Snacks.gitbrowse()
			end,
			desc = "Snacks: Git Browse",
			mode = { "n", "v" },
		},
		{
			"<leader>un",
			function()
				Snacks.notifier.hide()
			end,
			desc = "Snacks: Dismiss All Notifications",
		},
		{
			"<leader>t",
			function()
				Snacks.terminal()
			end,
			desc = "Snacks: Toggle Terminal",
		},
		{
			"<leader>]]",
			function()
				Snacks.words.jump(vim.v.count1)
			end,
			desc = "Snacks: Next Reference",
			mode = { "n", "t" },
		},
		{
			"<leader>[[",
			function()
				Snacks.words.jump(-vim.v.count1)
			end,
			desc = "Snacks: Prev Reference",
			mode = { "n", "t" },
		},
	},
}
