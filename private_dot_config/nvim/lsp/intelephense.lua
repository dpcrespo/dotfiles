local blink = require('blink.cmp')

-- Optional premium licence support
local licence_path = vim.fn.expand('~/intelephense/licence.txt')
local licence_key = nil
if vim.fn.filereadable(licence_path) == 1 then
  licence_key = vim.fn.readfile(licence_path)[1]
end

local stubs = {
  'apache',
  'bcmath',
  'bz2',
  'calendar',
  'com_dotnet',
  'Core',
  'ctype',
  'curl',
  'date',
  'dba',
  'dom',
  'enchant',
  'exif',
  'FFI',
  'fileinfo',
  'filter',
  'fpm',
  'ftp',
  'gd',
  'gettext',
  'gmp',
  'hash',
  'iconv',
  'imap',
  'intl',
  'json',
  'ldap',
  'libxml',
  'mbstring',
  'meta',
  'mysqli',
  'oci8',
  'odbc',
  'openssl',
  'pcntl',
  'pcre',
  'PDO',
  'pdo_mysql',
  'Phar',
  'posix',
  'readline',
  'Reflection',
  'regex',
  'session',
  'shmop',
  'SimpleXML',
  'snmp',
  'soap',
  'sockets',
  'sodium',
  'SPL',
  'sqlite3',
  'standard',
  'superglobals',
  'sysvmsg',
  'sysvsem',
  'sysvshm',
  'tidy',
  'tokenizer',
  'xml',
  'xmlreader',
  'xmlrpc',
  'xmlwriter',
  'xsl',
  'Zend OPcache',
  'zip',
  'zlib',
  'redis',
}

-- Add Laravel stub if premium licence is available
if licence_key then
  table.insert(stubs, 'laravel')
end

return {
  cmd = { 'intelephense', '--stdio' },
  filetypes = { 'php' },
  root_markers = { 'composer.json', '.git' },
  init_options = {
    licenceKey = licence_key,
    globalStoragePath = vim.fn.expand('~/.local/share/intelephense'),
  },
  settings = {
    intelephense = {
      stubs = stubs,
      files = {
        maxSize = 2000000,
      },
      format = {
        enable = false,
      },
      environment = {
        phpVersion = '8.4',
      },
      completion = {
        fullyQualifyGlobalConstantsAndFunctions = false,
        triggerParameterHints = true,
        maxItems = 100,
      },
      phpdoc = {
        returnVoid = false,
      },
    },
  },
  capabilities = vim.tbl_deep_extend(
    "force",
    {},
    vim.lsp.protocol.make_client_capabilities(),
    blink.get_lsp_capabilities()
  ),
}
