return {
  "mikavilpas/yazi.nvim",
  event = "VeryLazy",
  keys = {
    {
      "<leader>y",
      function()
        require("yazi").yazi()
      end,
      desc = "Open Yazi",
    },
  },
  opts = {
    open_for_directories = true,
  },
}
