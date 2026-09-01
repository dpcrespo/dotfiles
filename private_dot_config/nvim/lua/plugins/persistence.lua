return {
  "folke/persistence.nvim",
  lazy = false,
  keys = {
    { "<leader>qs", function() require("persistence").load() end, desc = "Restore session" },
    { "<leader>qS", function() require("persistence").select() end, desc = "Select session" },
    { "<leader>ql", function() require("persistence").load({ last = true }) end, desc = "Restore last session" },
    { "<leader>qd", function() require("persistence").stop() end, desc = "Stop persistence" },
  },
  opts = {},
  init = function()
    vim.api.nvim_create_autocmd("StdinReadPre", {
      group = vim.api.nvim_create_augroup("persistence_stdin", { clear = true }),
      callback = function() vim.g.started_with_stdin = true end,
    })
  end,
  config = function(_, opts)
    require("persistence").setup(opts)

    vim.api.nvim_create_autocmd("VimEnter", {
      group = vim.api.nvim_create_augroup("persistence_autoload", { clear = true }),
      nested = true,
      callback = function()
        if vim.fn.argc() == 0 and not vim.g.started_with_stdin then
          require("persistence").load()
        end
      end,
    })
  end,
}
