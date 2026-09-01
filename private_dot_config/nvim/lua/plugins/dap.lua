-- Default Xdebug path mapping when a project declares nothing of its own.
local DEFAULT_CONTAINER_PATH = "/var/www/html"

-- Answers to the container-path prompt, keyed by workspace root, so you only
-- get asked once per project per Neovim session.
local php_path_cache = {}

local function workspace_root()
  return vim.fs.root(0, { ".git", "composer.json" }) or vim.fn.getcwd()
end

local function php_config(container_path)
  return {
    {
      type = "php",
      request = "launch",
      name = "Listen for Xdebug",
      port = 9003,
      pathMappings = {
        [container_path] = "${workspaceFolder}",
      },
    },
  }
end

local function start_php_debug(dap, container_path)
  dap.configurations.php = php_config(container_path)
  dap.continue()
  vim.notify("Debug started: listening on :9003 (" .. container_path .. ")", vim.log.levels.INFO)
end

local function toggle_debug()
  local dap = require("dap")
  if dap.session() then
    dap.terminate()
    require("dapui").close()
    vim.notify("Debug stopped", vim.log.levels.INFO)
    return
  end

  if vim.bo.filetype ~= "php" then
    dap.continue()
    return
  end

  local root = workspace_root()

  -- A project shipping its own .vscode/launch.json owns its path mapping;
  -- load_launchjs() already read it, so don't ask and don't overwrite.
  if vim.fn.filereadable(root .. "/.vscode/launch.json") == 1 then
    dap.continue()
    return
  end

  local cached = php_path_cache[root]
  if cached then
    start_php_debug(dap, cached)
    return
  end

  vim.ui.input({ prompt = "Xdebug container path: ", default = DEFAULT_CONTAINER_PATH }, function(input)
    if not input or input == "" then return end
    php_path_cache[root] = input
    start_php_debug(dap, input)
  end)
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

      dap.configurations.php = php_config(DEFAULT_CONTAINER_PATH)

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

      -- Per-project overrides: a repo's own .vscode/launch.json wins over the
      -- defaults above. This is where a project path like /data/feeds belongs.
      pcall(function()
        require("dap.ext.vscode").load_launchjs(nil, { php = { "php" } })
      end)
    end,
  },
}
