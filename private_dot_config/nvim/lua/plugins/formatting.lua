return {
  "stevearc/conform.nvim",
  event = { "BufWritePre", "BufNewFile" },
  cmd = { "ConformInfo" },
  keys = {
    {
      "<leader>f",
      function()
        require("conform").format({ lsp_fallback = false })
      end,
      mode = "",
      desc = "Format buffer",
    },
    {
      "<leader>mp",
      function()
        if vim.bo.filetype == "php" then
          vim.cmd("silent write")
        else
          require("conform").format({ lsp_fallback = false })
        end
      end,
      mode = "n",
      desc = "Format PHP (php-cs-fixer)",
    },
  },
  opts = {
    formatters_by_ft = {
      lua = { "stylua" },
      javascript = { "eslint_d" },
      javascriptreact = { "eslint_d" },
      typescript = { "eslint_d" },
      typescriptreact = { "eslint_d" },
      css = { "stylelint" },
      scss = { "stylelint" },
      less = { "stylelint" },
      blade = { "blade-formatter" },
    },
    format_on_save = {
      timeout_ms = 2000,
      lsp_fallback = false,
    },
    notify_on_error = true,
  },
  config = function(_, opts)
    require("conform").setup(opts)

    -- PHP: conform temp files are dotfiles, ignored by php-cs-fixer's Symfony Finder.
    -- Run directly on the real file via BufWritePost instead.
    vim.api.nvim_create_autocmd("BufWritePost", {
      group = vim.api.nvim_create_augroup("php-format", { clear = true }),
      pattern = "*.php",
      callback = function()
        if vim.g.disable_autoformat or vim.b[vim.api.nvim_get_current_buf()].disable_autoformat then
          return
        end
        local file = vim.fn.expand("%:p")
        local root = vim.fs.root(vim.fn.expand("%:p:h"), ".php-cs-fixer.php")
        if not root then return end

        vim.fn.system({
          "php-cs-fixer", "fix", file,
          "--config=" .. root .. "/.php-cs-fixer.php",
          "--allow-unsupported-php-version=yes",
          "--using-cache=no",
          "--quiet",
        })
        if vim.v.shell_error <= 1 then
          vim.cmd("edit")
        end
      end,
    })
  end,
}
