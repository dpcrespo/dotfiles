-- Auto-reload files when changed externally (e.g., by Claude Code)
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold" }, {
    group = vim.api.nvim_create_augroup("autoreload", { clear = true }),
    callback = function()
        if vim.fn.getcmdwintype() == "" then
            vim.cmd("checktime")
        end
    end,
})

-- Real-time file watcher for external changes (Claude Code)
local watch_group = vim.api.nvim_create_augroup("filewatcher", { clear = true })
local watchers = {}

local function watch_file(bufnr)
    local filepath = vim.api.nvim_buf_get_name(bufnr)
    if filepath == "" or watchers[bufnr] then return end

    local handle = vim.uv.new_fs_event()
    if not handle then return end

    handle:start(filepath, {}, vim.schedule_wrap(function(err, filename, events)
        if err then return end
        if events.change and vim.api.nvim_buf_is_valid(bufnr) then
            vim.api.nvim_buf_call(bufnr, function()
                vim.cmd("checktime")
            end)
        end
    end))

    watchers[bufnr] = handle
end

local function unwatch_file(bufnr)
    if watchers[bufnr] then
        watchers[bufnr]:stop()
        watchers[bufnr] = nil
    end
end

vim.api.nvim_create_autocmd("BufReadPost", {
    group = watch_group,
    callback = function(args)
        watch_file(args.buf)
    end,
})

vim.api.nvim_create_autocmd("BufDelete", {
    group = watch_group,
    callback = function(args)
        unwatch_file(args.buf)
    end,
})

vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup('lsp-attach', { clear = true }),
    callback = function(event)
        local map = function(keys, func, desc)
            vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
        end

        -- defaults:
        -- https://neovim.io/doc/user/news-0.11.html#_defaults

        map("gl", vim.diagnostic.open_float, "Open Diagnostic Float")
        map("K", vim.lsp.buf.hover, "Hover Documentation")
        map("gs", vim.lsp.buf.signature_help, "Signature Documentation")
        map("gD", vim.lsp.buf.declaration, "Goto Declaration")
        map("<leader>la", vim.lsp.buf.code_action, "Code Action")
        map("<leader>lr", vim.lsp.buf.rename, "Rename all references")
        map("<leader>lf", function()
            require("conform").format({ async = true, lsp_fallback = false })
        end, "Format")
        map("<leader>v", "<cmd>vsplit | lua vim.lsp.buf.definition()<cr>", "Goto Definition in Vertical Split")

        local function client_supports_method(client, method, bufnr)
            if vim.fn.has 'nvim-0.11' == 1 then
                return client:supports_method(method, bufnr)
            else
                return client.supports_method(method, { bufnr = bufnr })
            end
        end

        local client = vim.lsp.get_client_by_id(event.data.client_id)
        if client and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf) then
            local highlight_augroup = vim.api.nvim_create_augroup('lsp-highlight', { clear = false })

            -- When cursor stops moving: Highlights all instances of the symbol under the cursor
            -- When cursor moves: Clears the highlighting
            vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
                buffer = event.buf,
                group = highlight_augroup,
                callback = vim.lsp.buf.document_highlight,
            })
            vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
                buffer = event.buf,
                group = highlight_augroup,
                callback = vim.lsp.buf.clear_references,
            })

            -- When LSP detaches: Clears the highlighting
            vim.api.nvim_create_autocmd('LspDetach', {
                group = vim.api.nvim_create_augroup('lsp-detach', { clear = true }),
                callback = function(event2)
                    vim.lsp.buf.clear_references()
                    vim.api.nvim_clear_autocmds { group = 'lsp-highlight', buffer = event2.buf }
                end,
            })
        end
    end,

})

-- -- Autoformat on save
-- vim.api.nvim_create_autocmd("BufWritePre", {
--     group = vim.api.nvim_create_augroup('autoformat', { clear = true }),
--     callback = function()
--         local bufnr = vim.api.nvim_get_current_buf()
--         local filetype = vim.api.nvim_buf_get_option(bufnr, 'filetype')
        
--         -- Skip JavaScript/TypeScript files (let ESLint handle them)
--         if filetype == 'javascript' or filetype == 'javascriptreact' or 
--            filetype == 'typescript' or filetype == 'typescriptreact' then
--             return
--         end
        
--         -- Try to use conform.nvim first (if available)
--         local conform_available, conform = pcall(require, "conform")
--         if conform_available then
--             conform.format({ bufnr = bufnr, async = false })
--             return
--         end
        
--         -- Fallback to LSP formatting
--         local clients = vim.lsp.get_clients({ bufnr = bufnr })
--         for _, client in ipairs(clients) do
--             if client.supports_method("textDocument/formatting") then
--                 vim.lsp.buf.format({ async = false })
--                 break
--             end
--         end
--     end,
-- })
