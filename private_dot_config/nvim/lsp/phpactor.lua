local blink = require('blink.cmp')

return {
  cmd = { 'phpactor', 'language-server' },
  filetypes = { 'php' },
  root_markers = { 'composer.json', '.git' },
  init_options = {
    ['language_server.diagnostics_on_update'] = false,
    ['language_server.diagnostics_on_open'] = false,
    ['language_server.diagnostics_on_save'] = false,
    ['completion.enabled'] = false,
    ['hover.enabled'] = false,
    ['code_transform.import_globals'] = true,
  },
  capabilities = vim.tbl_deep_extend(
    "force",
    {},
    vim.lsp.protocol.make_client_capabilities(),
    blink.get_lsp_capabilities()
  ),
}
