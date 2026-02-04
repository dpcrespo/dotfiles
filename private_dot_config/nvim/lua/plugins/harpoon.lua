return {
  "ThePrimeagen/harpoon",
  dependencies = { "nvim-lua/plenary.nvim" },
  opts = {
    -- Configuración básica para asegurar funcionamiento
    menu = {
      width = math.floor(vim.api.nvim_win_get_width(0) * 0.7),
    },
    global_settings = {
      save_on_toggle = true,
      enter_on_sendcmd = true,
    },
  },
  config = function(_, opts)
    require("harpoon").setup(opts)
    
    -- Asegurar que los módulos estén disponibles
    local mark = require("harpoon.mark")
    local ui = require("harpoon.ui")
    
    -- Verificar que los módulos se cargan correctamente
    if not mark or not ui then
      vim.notify("Harpoon modules not loaded correctly", vim.log.levels.ERROR)
      return
    end
  end,
}
