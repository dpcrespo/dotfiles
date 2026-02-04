return {
  "brenoprata10/nvim-highlight-colors",
  event = { "BufReadPre", "BufNewFile" },
  opts = {
    render = "virtual",
    virtual_symbol = "●",
    virtual_symbol_position = "inline",
    enable_hex = true,
    enable_rgb = true,
    enable_hsl = true,
    enable_var_usage = true,
    enable_named_colors = false,
    enable_tailwind = false,
  },
}
