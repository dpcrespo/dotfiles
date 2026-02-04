return {
  "sindrets/diffview.nvim",
  cmd = { "DiffviewOpen", "DiffviewFileHistory" },
  keys = {
    { "<leader>gdo", "<cmd>DiffviewOpen<cr>", desc = "Open diff view" },
    { "<leader>gdf", "<cmd>DiffviewOpen -- %<cr>", desc = "Diff current file" },
    { "<leader>gdh", "<cmd>DiffviewFileHistory %<cr>", desc = "File history" },
    { "<leader>gdH", "<cmd>DiffviewFileHistory<cr>", desc = "Repo history" },
    { "<leader>gdc", "<cmd>DiffviewClose<cr>", desc = "Close diff view" },
  },
  opts = {
    enhanced_diff_hl = true,
    view = {
      default = {
        layout = "diff2_horizontal",
      },
      merge_tool = {
        layout = "diff3_horizontal",
      },
      file_history = {
        layout = "diff2_horizontal",
      },
    },
    file_panel = {
      win_config = {
        position = "left",
        width = 35,
      },
    },
  },
}
