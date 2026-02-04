-- clipboard system
vim.opt.clipboard = 'unnamedplus'

-- Auto-reload files changed outside of nvim
vim.opt.autoread = true
-- Make line numbers default
vim.opt.number = true
-- Add relative numbers, to help with jumping
vim.opt.relativenumber = true

-- Set to true if you have a Nerd Font installed and selected in the terminal
vim.g.have_nerd_font = true

-- Enable mouse mode, can be useful for resizing splits for example!
vim.opt.mouse = 'a'
-- Don't show the mode, since it's already in the status line
vim.opt.showmode = false

-- Convert tabs to spaces
vim.opt.expandtab = true

-- Define how many spaces are applied when indentation is made
-- >> more indentation
-- << less indentation
-- = autoformat
vim.opt.shiftwidth = 2

-- Define how many spaces are applied per tab
vim.opt.tabstop = 2

-- Inteligent Backspace
vim.opt.softtabstop = 2

-- Modify the behaviour of Tab and Backspace base on insert mode, works width shiftwidth and expandtab
vim.opt.smarttab = true

-- sistema de sangría automática "inteligente" para ciertos lenguajes de programación.
--     Sangría automática básica:
--        Al presionar Enter en modo inserción, la nueva línea mantiene la misma sangría que la anterior.
--    Comportamiento especial en código:
--       Sangría adicional después de líneas que terminan con {, :, do, etc. (dependiendo del lenguaje).
--      Reduce la sangría después de líneas con }, end, etc.
vim.opt.smartindent = false

-- Al presionar Enter en modo inserción, la nueva línea mantiene la misma sangría que la línea anterior.
-- No añade lógica adicional (como smartindent o cindent), solo copia el nivel de sangría actual.
vim.opt.autoindent = true

-- Enable break indent
vim.opt.breakindent = true

-- Save undo history
vim.opt.undofile = true

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
-- vim.opt.ignorecase = true
-- vim.opt.smartcase = true

-- Keep signcolumn on by default
vim.opt.signcolumn = 'yes'
-- Otras alternativas:
-- vim.opt.signcolumn = 'auto'     -- Solo aparece cuando hay señales
-- vim.opt.signcolumn = 'yes:2'    -- Siempre visible con 2 columnas

-- Decrease update time
-- Establece el tiempo de espera (en milisegundos) antes de que Neovim realice ciertas acciones automáticas después de que dejas de escribir. El valor 250 significa 0.25 segundos.
-- Comportamientos afectados:
--    Eventos CursorHold: Se disparan cuando el cursor permanece inmóvil
--    Actualización de plugins: Muchos plugins usan este tiempo para:
--        Mostrar diagnósticos (LSP, linters)
--        Actualizar señales de Git (gitsigns.nvim)
--        Mostrar información flotante (hover)
--    Autoguardado: Plugins de autoguardado lo usan como delay
--    Highlight de referencias: Resaltado de variables similares
--
--    Por qué 250ms es un buen valor
--    Por defecto es 4000ms (4s) - demasiado lento para feedback inmediato
--    250ms ofrece un balance perfecto entre:
--        Respuesta rápida a cambios
--        Sin sobrecargar el sistema con actualizaciones constantes
--        Suficiente tiempo para que termines de escribir
vim.opt.updatetime = 250

-- Decrease mapped sequence wait time
-- controla un comportamiento clave relacionado con los keymaps combinados (mapping de teclas que requieren múltiples pulsaciones). 
--     Define el tiempo de espera (en milisegundos) para que Neovim decida si:
--      1️⃣ Estás intentando completar un keymap combinado (ej.: gcc en which-key.nvim o gd en modo normal).
--      2️⃣ O si estás presionando teclas por separado (ej.: g seguido de movimiento como gj).
--     Valor por defecto: Normalmente 1000ms (1 segundo), lo que puede sentirse lento.

-- 300ms: Un tiempo más ágil que evita la "espera molesta" entre teclas.
vim.opt.timeoutlen = 300

-- Configure how new splits should be opened
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Sets how neovim will display certain whitespace characters in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- Muestra una previsualización en tiempo real de los cambios cuando escribes comandos de sustitución (:s), dividiendo la ventana temporalmente para mostrarte cómo quedarán los cambios antes de aplicarlos.
vim.opt.inccommand = 'split'

-- Show which line your cursor is on
vim.opt.cursorline = true

-- Minimal number of screen lines to keep above and below the cursor.
vim.opt.scrolloff = 5

-- Neovim pedirá confirmación en ciertas situaciones donde normalmente saldría o guardaría archivos sin preguntar. Por ejemplo:
--    Si tienes cambios no guardados y tratas de cerrar un buffer o Neovim, en lugar de mostrar un error (E37: No write since last change), mostrará un diálogo interactivo preguntando qué hacer:

-- Guardar cambios en "archivo.txt"?
-- [S]í, (N)o, (C)ancelar, (A)ceptar todo, (Q)uitar todo

-- Es útil para evitar perder cambios accidentalmente, ya que te da opciones explícitas antes de realizar acciones potencialmente destructivas.
-- See `:help 'confirm'
vim.opt.confirm = true

