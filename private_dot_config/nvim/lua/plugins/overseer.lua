return {
  "stevearc/overseer.nvim",
  cmd = {
    "OverseerRun",
    "OverseerToggle",
    "OverseerOpen",
    "OverseerClose",
    "OverseerTaskAction",
  },
  keys = {
    { "<leader>or", "<cmd>OverseerRun<cr>", desc = "Run task" },
    { "<leader>ot", "<cmd>OverseerToggle<cr>", desc = "Toggle task list" },
    { "<leader>oa", "<cmd>OverseerTaskAction<cr>", desc = "Task action" },
    { "<leader>ol", "<cmd>OverseerRestartLast<cr>", desc = "Restart last task" },
  },
  opts = {
    task_list = {
      direction = "bottom",
      min_height = 15,
      max_height = 25,
      bindings = {
        ["q"] = "Close",
        ["<CR>"] = "RunAction",
        ["<C-r>"] = "Restart",
        ["<C-s>"] = "Stop",
        ["<C-d>"] = "Dispose",
      },
    },
    templates = { "builtin" },
  },
}
