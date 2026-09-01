return {
  "nvim-treesitter/nvim-treesitter",
  dependencies = {
    "nvim-treesitter/nvim-treesitter-textobjects",
  },
  build = ":TSUpdate",
  event = "VeryLazy",
  config = function()
    require("nvim-treesitter").setup()

    local ensure = { "lua", "vim", "vimdoc", "query", "javascript", "typescript", "tsx", "scss", "css", "html", "json", "jsonc", "markdown", "markdown_inline", "yaml", "php", "php_only", "phpdoc" }
    local installed = require("nvim-treesitter").get_installed()
    local installed_set = {}
    for _, l in ipairs(installed) do installed_set[l] = true end
    local to_install = {}
    for _, l in ipairs(ensure) do
      if not installed_set[l] then table.insert(to_install, l) end
    end
    if #to_install > 0 then
      require("nvim-treesitter").install(to_install)
    end

    vim.api.nvim_create_autocmd("FileType", {
      callback = function(args)
        local max_filesize = 100 * 1024
        local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(args.buf))
        if ok and stats and stats.size > max_filesize then return end
        pcall(vim.treesitter.start, args.buf)
      end,
    })

    require("nvim-treesitter-textobjects").setup({
      select = {
        lookahead = true,
        include_surrounding_whitespace = true,
      },
    })

    local ts_select = require("nvim-treesitter-textobjects.select")
    local keymaps_select = {
      ["af"] = "@function.outer",
      ["if"] = "@function.inner",
      ["ac"] = "@conditional.outer",
      ["ic"] = "@conditional.inner",
      ["al"] = "@loop.outer",
      ["il"] = "@loop.inner",
    }
    for key, query in pairs(keymaps_select) do
      vim.keymap.set({ "x", "o" }, key, function() ts_select.select_textobject(query) end)
    end

    local ts_swap = require("nvim-treesitter-textobjects.swap")
    vim.keymap.set("n", "<leader>a", function() ts_swap.swap_next("@parameter.inner") end, { desc = "Swap with next parameter" })
    vim.keymap.set("n", "<leader>A", function() ts_swap.swap_previous("@parameter.inner") end, { desc = "Swap with previous parameter" })
  end,
}
