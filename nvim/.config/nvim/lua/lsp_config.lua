local nnoremap = function(bufnr, keys, cmd)
    local opts = { noremap=true, silent=true }
    vim.api.nvim_buf_set_keymap(bufnr, 'n', keys, cmd, opts)
end

local bindings = {
    ['<leader>lK'] = '<cmd>lua vim.lsp.buf.hover()<CR>',
    ['<leader>lk'] = '<cmd>lua vim.lsp.buf.signature_help()<CR>',
    ['<leader>lrn'] = '<cmd>lua vim.lsp.buf.rename()<CR>',
    ['<leader>lwl'] = '<cmd>lua vim.lsp.buf.list_workspace_folders()<CR>',
    -- diagnostics
    ['[d'] = '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>',
    [']d'] = '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>',
    ['<leader>de'] = '<cmd>lua vim.lsp.util.show_line_diagnostics()<CR>',
    -- code navigation
    ['gd'] = '<cmd>lua vim.lsp.buf.definition()<CR>',
    ['gi'] = '<cmd>lua vim.lsp.buf.implementation()<CR>',
    ['gr'] = '<cmd>lua vim.lsp.buf.references()<CR>',
    ['gtd'] = '<cmd>lua vim.lsp.buf.type_definition()<CR>',
}

local lspstatus = require'lsp-status'
lspstatus.register_progress()

local on_attach = function(client, bufnr)
    require'completion'.on_attach(client)
    lspstatus.on_attach(client)
    for keys, cmd in pairs(bindings) do
        nnoremap(bufnr, keys, cmd)
    end
    print("LSP attached")
end


local lspconfig = require'lspconfig'

local lsps = {'pyright', 'clangd', 'cmake'}
for _, lsp in ipairs(lsps) do
    lspconfig[lsp].setup{
        on_attach = on_attach,
    }
end

local home = os.getenv("HOME")
local lua_lsp_base = home .. "/language_servers/lua-language-server"
lspconfig.sumneko_lua.setup{
    cmd = {
        lua_lsp_base .. "/bin/Linux/lua-language-server",
        "-E",
        lua_lsp_base .. "main.lua",
    },
    on_attach=on_attach,
    settings = {
        Lua = {
            runtime = {
                version = "LuaJIT",
                path = vim.split(package.path, ';'),
            },
            diagnostics = {
                globals = { "vim" },
            },
            workspace = {
                library = {
                    [vim.fn.expand("$VIMRUNTIME/lua")] = true,
                    [vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true,
                },
            },
        }
    }
}
