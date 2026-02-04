-- oil
vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
-- harpoon
vim.keymap.set("n", "<leader>ha", function() require("harpoon.mark").add_file() end, { desc = "Harpoon: Add File" })
vim.keymap.set("n", "<leader>hr", function() require("harpoon.mark").rm_file() end, { desc = "Harpoon: Remove File" })
vim.keymap.set("n", "<leader>hm", function() require("harpoon.ui").toggle_quick_menu() end, { desc = "Harpoon: Menu" })
vim.keymap.set("n", "<leader>h1", function() require("harpoon.ui").nav_file(1) end, { desc = "Harpoon: Go to file 1" })
vim.keymap.set("n", "<leader>h2", function() require("harpoon.ui").nav_file(2) end, { desc = "Harpoon: Go to file 2" })
vim.keymap.set("n", "<leader>h3", function() require("harpoon.ui").nav_file(3) end, { desc = "Harpoon: Go to file 3" })
vim.keymap.set("n", "<leader>h4", function() require("harpoon.ui").nav_file(4) end, { desc = "Harpoon: Go to file 4" })
vim.keymap.set("n", "<leader>hn", function() require("harpoon.ui").nav_next() end, { desc = "Harpoon: Go to next file" })
vim.keymap.set("n", "<leader>hp", function() require("harpoon.ui").nav_prev() end, { desc = "Harpoon: Go to previous file" })

-- Copy file paths to clipboard
vim.keymap.set("n", "<leader>cp", function()
	local file_path = vim.fn.expand("%:p")
	vim.fn.setreg("+", file_path)
	vim.notify("Copied to clipboard: " .. file_path, vim.log.levels.INFO)
end, { desc = "Copy absolute file path to clipboard" })

vim.keymap.set("n", "<leader>cr", function()
	local file_path = vim.fn.expand("%")
	vim.fn.setreg("+", file_path)
	vim.notify("Copied to clipboard: " .. file_path, vim.log.levels.INFO)
end, { desc = "Copy relative file path to clipboard" })

vim.keymap.set("n", "<leader>cn", function()
	local file_name = vim.fn.expand("%:t")
	vim.fn.setreg("+", file_name)
	vim.notify("Copied to clipboard: " .. file_name, vim.log.levels.INFO)
end, { desc = "Copy file name to clipboard" })

vim.keymap.set("n", "<leader>cd", function()
	local dir_path = vim.fn.expand("%:p:h")
	vim.fn.setreg("+", dir_path)
	vim.notify("Copied to clipboard: " .. dir_path, vim.log.levels.INFO)
end, { desc = "Copy directory path to clipboard" })

-- Check system dependencies
vim.keymap.set("n", "<leader>cd", function()
	local dependencies = {
		{ name = "git", cmd = "git --version" },
		{ name = "node", cmd = "node --version" },
		{ name = "npm", cmd = "npm --version" },
		{ name = "ripgrep", cmd = "rg --version" },
		{ name = "fd", cmd = "fd --version" },
		{ name = "stylua", cmd = "stylua --version" },
		{ name = "prettier", cmd = "prettier --version" },
		{ name = "lua-language-server", cmd = "lua-language-server --version" },
		{ name = "typescript-language-server", cmd = "typescript-language-server --version" },
		{ name = "eslint", cmd = "eslint --version" },
		{ name = "stylelint", cmd = "stylelint --version" },
	}
	
	print("🔍 Checking system dependencies...")
	print("=" .. string.rep("=", 50))
	
	for _, dep in ipairs(dependencies) do
		local output = vim.fn.system(dep.cmd)
		if vim.v.shell_error == 0 then
			local version = vim.fn.split(output, "\n")[1]
			print("✅ " .. dep.name .. ": " .. version)
		else
			print("❌ " .. dep.name .. ": Not found")
		end
	end
	
	print("=" .. string.rep("=", 50))
	print("💡 Use :Mason to install missing LSPs and formatters")
end, { desc = "Check system dependencies" })

-- FZF-Lua SOLO para grep (por la flexibilidad de exclusiones dinámicas)
vim.keymap.set("n", "<leader>fg", function() require('fzf-lua').live_grep() end, { desc = "FZF: Grep (con exclusiones dinámicas)" })
vim.keymap.set("n", "<leader>fw", function() 
  local word = vim.fn.expand("<cword>")
  require('fzf-lua').live_grep({ search = word })
end, { desc = "FZF: Search current word" })
vim.keymap.set("n", "<leader>fW", function() 
  local selected = vim.fn.getreg('"')
  if selected and selected ~= "" then
    require('fzf-lua').live_grep({ search = selected })
  else
    local word = vim.fn.expand("<cword>")
    require('fzf-lua').live_grep({ search = word })
  end
end, { desc = "FZF: Search selected text or current word" })