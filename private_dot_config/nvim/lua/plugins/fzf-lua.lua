return {
  'ibhagwan/fzf-lua',
  dependencies = {
    'nvim-tree/nvim-web-devicons',
  },
  config = function()
    local fzf_lua = require('fzf-lua')
    
    fzf_lua.setup({
      files = {
        fd_opts = "--color=never --type f --hidden --follow --exclude .git",
      },
      grep = {
        rg_opts = "--column --line-number --no-heading --color=always --smart-case --hidden --glob '!.git'",
      },
      -- Configuración básica
      fzf_opts = {
        ['--layout'] = 'reverse',
        ['--info'] = 'inline-right',  -- Números pegados a la derecha
        ['--border'] = 'none',        -- Sin borde interior para que suba la barra
        ['--margin'] = '1,2',         -- Márgenes
        ['--padding'] = '1,2',        -- Padding interno
        ['--prompt'] = '❯ ',          -- Prompt personalizado
        ['--pointer'] = '▶',          -- Puntero personalizado
        ['--marker'] = '✓',           -- Marcador personalizado
        ['--height'] = '100%',        -- Altura completa
      },
      -- Personalizar colores específicos
      fzf_colors = {
        -- Bordes morados (colores de Kanagawa)
        ["border"] = { "fg", { "Special" } },
        ["gutter"] = { "bg", { "Normal" } },
        -- Otros colores se generan automáticamente del tema
        ["fg+"] = { "fg", { "Normal" } },
        ["bg+"] = { "bg", { "CursorLine" } },
        ["hl+"] = { "fg", { "Search" } },
        ["info"] = { "fg", { "Comment" } },
        ["prompt"] = { "fg", { "Special" } },
        ["pointer"] = { "fg", { "Special" } },
        ["marker"] = { "fg", { "String" } },
        ["spinner"] = { "fg", { "Special" } },
        ["header"] = { "fg", { "String" } },
      },
    })
    
    -- Configurar colores de los bordes de las ventanas de fzf-lua
    vim.api.nvim_create_autocmd("ColorScheme", {
      callback = function()
        -- Colores sutiles de Kanagawa para los bordes
        vim.api.nvim_set_hl(0, "FzfLuaBorder", { fg = "#54546d" })  -- Gris azulado sutil
        vim.api.nvim_set_hl(0, "FzfLuaPreviewBorder", { fg = "#54546d" })  -- Gris azulado sutil
        vim.api.nvim_set_hl(0, "FzfLuaTitle", { fg = "#7aa89f" })  -- Verde azulado sutil
      end,
    })
    
    -- Aplicar colores inmediatamente
    vim.api.nvim_set_hl(0, "FzfLuaBorder", { fg = "#54546d" })
    vim.api.nvim_set_hl(0, "FzfLuaPreviewBorder", { fg = "#54546d" })
    vim.api.nvim_set_hl(0, "FzfLuaTitle", { fg = "#7aa89f" })
  end,
} 