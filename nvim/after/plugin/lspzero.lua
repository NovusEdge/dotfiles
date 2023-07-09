local lsp = require('lsp-zero').preset({
    float_border = 'rounded',
    call_servers = 'local',
    configure_diagnostics = true,
    setup_servers_on_start = true,
    set_lsp_keymaps = {
        preserve_mappings = false,
        omit = {},
    },
    manage_nvim_cmp = {
        set_sources = 'recommended',
        set_basic_mappings = true,
        set_extra_mappings = true,
        use_luasnip = true,
        set_format = true,
        documentation_window = true,
    }
})

lsp.on_attach(function(client, bufnr)
  	lsp.default_keymaps({buffer = bufnr})
end)

lsp.ensure_installed({
	'clangd',
	'cmake',
	'gopls',
	'tsserver',
	'lua_ls',
	'pyright',
	'rust_analyzer'
})

require('lspconfig').lua_ls.setup(lsp.nvim_lua_ls())

vim.diagnostic.config({
    virtual_text = false
})

vim.o.updatetime = 250
vim.cmd [[autocmd CursorHold,CursorHoldI * lua vim.diagnostic.open_float(nil, {focus=false})]]

lsp.setup()

-------------------------------------------------------------------------------
-- Configuring autocompletion using nvim-cmp

local has_words_before = function()
    unpack = unpack or table.unpack
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

local cmp = require('cmp')

-- Straight out of: https://github.com/hrsh7th/nvim-cmp/wiki/Example-mappings#no-snippet-plugin
cmp.setup({
    mapping = {
        ['<CR>'] = cmp.mapping.confirm({ select = true }),
        ['<Tab>'] = function(fallback)
            if not cmp.select_next_item() then
                if vim.bo.buftype ~= 'prompt' and has_words_before() then
                    cmp.complete()
                else
                    fallback()
                end
                end
            end,

        ['<S-Tab>'] = function(fallback)
            if not cmp.select_prev_item() then
                if vim.bo.buftype ~= 'prompt' and has_words_before() then
                   cmp.complete()
                else
                    fallback()
                end
            end
        end,
        },
})
