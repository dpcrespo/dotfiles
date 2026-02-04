return {
  "stevearc/conform.nvim",
  event = { "BufWritePre" },
  cmd = { "ConformInfo" },
  keys = {
    {
      "<leader>f",
      function()
        require("conform").format({ async = true, lsp_fallback = false })
      end,
      mode = "",
      desc = "Format buffer",
    },
  },
  opts = {
    -- Define formatters
    formatters_by_ft = {
      -- Solo archivos que no tienen LSP configurado
      lua = { "stylua" },
      -- JavaScript/TypeScript - usar eslint_d (instalado via Mason)
      javascript = { "eslint_d" },
      javascriptreact = { "eslint_d" },
      typescript = { "eslint_d" },
      typescriptreact = { "eslint_d" },
      -- CSS/SCSS - usar solo stylelint
      css = { "stylelint" },
      scss = { "stylelint" },
      less = { "stylelint" },
    },
    
    -- Set up format-on-save
    format_on_save = function(bufnr)
      -- Disable with a global or buffer-local variable
      if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
        return
      end

      return { timeout_ms = 2000, lsp_fallback = false }
    end,
    
    -- Notify on formatter errors
    notify_on_error = true,
  },
  init = function()
    -- Install formatters on first run
    vim.api.nvim_create_autocmd("User", {
      pattern = "ConformSetup",
      callback = function()
        vim.api.nvim_create_user_command("ConformInstall", function()
          require("conform").install()
        end, { desc = "Install formatters" })
      end,
    })
  end,
} 