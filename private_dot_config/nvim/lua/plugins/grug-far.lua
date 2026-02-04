return {
  "MagicDuck/grug-far.nvim",
  cmd = "GrugFar",
  keys = {
    {
      "<leader>sr",
      function()
        require("grug-far").open({ prefills = { paths = vim.fn.expand("%") } })
      end,
      desc = "Search and replace (current file)",
    },
    {
      "<leader>sR",
      function()
        require("grug-far").open()
      end,
      desc = "Search and replace (project)",
    },
    {
      "<leader>sw",
      function()
        require("grug-far").open({ prefills = { search = vim.fn.expand("<cword>") } })
      end,
      desc = "Search word under cursor",
    },
    {
      "<leader>sw",
      function()
        require("grug-far").with_visual_selection()
      end,
      mode = "v",
      desc = "Search selection",
    },
  },
  opts = {
    headerMaxWidth = 80,
    windowCreationCommand = "split",
  },
}
