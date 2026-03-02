return {
  -- DAP for PHP/Xdebug
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "nvim-neotest/nvim-nio",
    },
    keys = {
      { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "Toggle breakpoint" },
      { "<leader>dc", function() require("dap").continue() end, desc = "DAP continue" },
      { "<leader>do", function() require("dap").step_over() end, desc = "DAP step over" },
      { "<leader>di", function() require("dap").step_into() end, desc = "DAP step into" },
      { "<leader>dO", function() require("dap").step_out() end, desc = "DAP step out" },
      { "<leader>dr", function() require("dap").repl.toggle() end, desc = "DAP toggle REPL" },
      { "<leader>du", function() require("dapui").toggle() end, desc = "DAP UI toggle" },
    },
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")

      dapui.setup()

      -- Auto open/close DAP UI
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end

      -- PHP adapter (Xdebug)
      dap.adapters.php = {
        type = "executable",
        command = "node",
        args = {
          vim.fn.stdpath("data") .. "/mason/packages/php-debug-adapter/extension/out/phpDebug.js",
        },
      }

      dap.configurations.php = {
        {
          type = "php",
          request = "launch",
          name = "Listen for Xdebug",
          port = 9003,
          pathMappings = {
            ["/var/www/html"] = "${workspaceFolder}",
          },
        },
      }
    end,
  },

  -- nvim-lint for PHPStan
  {
    "mfussenegger/nvim-lint",
    event = { "BufWritePost" },
    config = function()
      local lint = require("lint")

      lint.linters_by_ft = {
        php = { "phpstan" },
      }

      lint.linters.phpstan = require("lint").linters.phpstan
      lint.linters.phpstan.cmd = function()
        local vendor = vim.fs.root(vim.api.nvim_buf_get_name(0), "vendor") or vim.fn.getcwd()
        local local_bin = vendor .. "/vendor/bin/phpstan"
        if vim.fn.executable(local_bin) == 1 then return local_bin end
        return "phpstan"
      end
      lint.linters.phpstan.args = {
        "analyse",
        "--error-format=json",
        "--no-progress",
        "--memory-limit=1G",
      }

      vim.api.nvim_create_autocmd({ "BufWritePost" }, {
        group = vim.api.nvim_create_augroup("PhpLint", { clear = true }),
        pattern = { "*.php" },
        callback = function()
          lint.try_lint()
        end,
      })
    end,
  },

  -- PHP-specific keymaps and utilities (no plugin, just config)
  {
    "folke/which-key.nvim",
    optional = true,
    opts = {
      spec = {
        { "<leader>p", group = "PHP/Hexagonal", icon = "" },
        { "<leader>d", group = "Debug", icon = "" },
      },
    },
  },

  -- Hexagonal navigation keymaps, Blade filetype, Laravel commands
  {
    dir = ".",
    name = "php-config",
    event = "VeryLazy",
    config = function()
      -- Blade filetype detection
      vim.filetype.add({
        pattern = {
          [".*%.blade%.php"] = "blade",
        },
      })

      -- Hexagonal navigation keymaps
      vim.keymap.set("n", "<leader>pi", vim.lsp.buf.implementation, { desc = "Go to implementation (Port -> Adapter)" })

      vim.keymap.set("n", "<leader>pp", function()
        local word = vim.fn.expand("<cword>")
        Snacks.picker.grep({ search = "interface " .. word, dirs = { "src/Domain", "app/Domain" } })
      end, { desc = "Find port/interface" })

      vim.keymap.set("n", "<leader>pd", function()
        Snacks.picker.grep({ dirs = { "src/Domain", "app/Domain" } })
      end, { desc = "Grep Domain layer" })

      vim.keymap.set("n", "<leader>pa", function()
        Snacks.picker.grep({ dirs = { "src/Application", "app/Application" } })
      end, { desc = "Grep Application layer" })

      vim.keymap.set("n", "<leader>pI", function()
        Snacks.picker.grep({ dirs = { "src/Infrastructure", "app/Infrastructure" } })
      end, { desc = "Grep Infrastructure layer" })

      -- PHPStan strict (level 9) on demand
      vim.api.nvim_create_user_command("PhpStanStrict", function()
        local file = vim.fn.expand("%:p")
        local root = vim.fs.root(file, "phpstan-strict.neon")
        if not root then
          print("phpstan-strict.neon not found")
          return
        end
        vim.cmd("split | terminal vendor/bin/phpstan analyse " .. file .. " -c phpstan-strict.neon --memory-limit=1G")
      end, { desc = "Run PHPStan level 9 on current file" })

      -- Laravel commands
      vim.api.nvim_create_user_command("PhpArtisan", function(opts)
        local cmd = "php artisan " .. opts.args
        vim.cmd("split | terminal " .. cmd)
      end, { nargs = "*", desc = "Run php artisan command" })

      vim.api.nvim_create_user_command("PhpTest", function()
        local file = vim.fn.expand("%")
        vim.cmd("split | terminal vendor/bin/pest " .. file)
      end, { desc = "Run Pest test for current file" })
    end,
  },
}
