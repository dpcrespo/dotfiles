local function toggle_debug()
  local dap = require("dap")
  if dap.session() then
    dap.terminate()
    require("dapui").close()
    vim.notify("Debug stopped", vim.log.levels.INFO)
    return
  end

  local ft = vim.bo.filetype
  if ft == "php" then
    local default_path = "/var/www/html"
    vim.ui.input({ prompt = "Docker container path: ", default = default_path }, function(input)
      if not input or input == "" then return end
      dap.configurations.php = {
        {
          type = "php",
          request = "launch",
          name = "Listen for Xdebug",
          port = 9003,
          pathMappings = {
            [input] = "${workspaceFolder}",
          },
        },
      }
      dap.continue()
      vim.notify("Debug started: listening on :9003", vim.log.levels.INFO)
    end)
  else
    dap.continue()
  end
end

return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "nvim-neotest/nvim-nio",
      {
        "mxsdev/nvim-dap-vscode-js",
        opts = {
          debugger_path = vim.fn.stdpath("data") .. "/lazy/vscode-js-debug",
          adapters = { "pwa-node", "pwa-chrome" },
        },
      },
      {
        "microsoft/vscode-js-debug",
        build = "npm install --legacy-peer-deps --ignore-scripts && npx gulp compile vsDebugServerBundle:webpack-bundle && mkdir -p out && cp -r dist/* out/",
      },
    },
    keys = {
      { "<leader>dd", toggle_debug, desc = "Toggle Debug" },
      { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "Toggle Breakpoint" },
      { "<leader>dB", function() require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: ")) end, desc = "Conditional Breakpoint" },
      { "<leader>dc", function() require("dap").continue() end, desc = "Continue" },
      { "<leader>do", function() require("dap").step_over() end, desc = "Step Over" },
      { "<leader>di", function() require("dap").step_into() end, desc = "Step Into" },
      { "<leader>dO", function() require("dap").step_out() end, desc = "Step Out" },
      { "<leader>dr", function() require("dap").restart() end, desc = "Restart" },
      { "<leader>dt", function() require("dap").terminate() end, desc = "Terminate" },
      { "<leader>du", function() require("dapui").toggle() end, desc = "Toggle DAP UI" },
      { "<leader>de", function() require("dapui").eval() end, desc = "Eval", mode = { "n", "v" } },
    },
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")

      dapui.setup()

      dap.listeners.after.event_initialized["dapui_config"] = function() dapui.open() end
      dap.listeners.before.event_terminated["dapui_config"] = function() dapui.close() end
      dap.listeners.before.event_exited["dapui_config"] = function() dapui.close() end

      -- PHP (Xdebug)
      dap.adapters.php = {
        type = "executable",
        command = "node",
        args = { vim.fn.stdpath("data") .. "/mason/packages/php-debug-adapter/extension/out/phpDebug.js" },
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

      -- JS/TS (Node)
      for _, language in ipairs({ "typescript", "javascript" }) do
        dap.configurations[language] = {
          {
            type = "pwa-node",
            request = "launch",
            name = "Launch file",
            program = "${file}",
            cwd = "${workspaceFolder}",
          },
          {
            type = "pwa-node",
            request = "attach",
            name = "Attach to process",
            processId = require("dap.utils").pick_process,
            cwd = "${workspaceFolder}",
          },
          {
            type = "pwa-node",
            request = "launch",
            name = "Launch test (vitest)",
            runtimeExecutable = "npx",
            runtimeArgs = { "vitest", "run", "${file}" },
            cwd = "${workspaceFolder}",
            console = "integratedTerminal",
          },
        }
      end
    end,
  },
}
