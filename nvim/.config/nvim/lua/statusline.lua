local lspstatus = require'lsp-status'

local diagnostics = require('lsp-status/diagnostics')
local messages = require('lsp-status/messaging').messages

local config = {
    indicator_errors = 'E',
    indicator_warnings = 'W',
    indicator_info = 'i',
    indicator_hint = '?',
    indicator_ok = 'Ok',
    indicator_separator = ': ',
}
local function init(_, _config)
    config = vim.tbl_extend('force', config, _config)
end

local function get_diag(diag_type)
    if table.getn(vim.lsp.buf_get_clients()) == 0 then
        return 0
    end
    local buf_diagnostics = diagnostics()
    if buf_diagnostics[diag_type] then
        return buf_diagnostics[diag_type]
    end
    return 0
end

local function errors()
    return get_diag('errors')
end

local function error_status()
    local num = errors()
    if num == 0 then
        return ''
    end
    return config.indicator_errors .. config.indicator_separator .. num
end

local function warnings()
    return get_diag('warnings')
end

local function warning_status()
    local num = warnings()
    if num == 0 then
        return ''
    end
    return config.indicator_warnings .. config.indicator_separator .. num
end

local function info()
    return get_diag('info')
end

local function info_status()
    local num = info()
    if num == 0 then
        return ''
    end
    return config.indicator_info .. config.indicator_separator .. num
end

local function hints()
    return get_diag('hint')
end

local function hint_status()
    local num = hints()
    if num == 0 then
        return ''
    end
    return config.indicator_hint .. config.indicator_separator .. num
end

local function current_function()
    if config.current_function then
        local current_function = vim.b.lsp_current_function
        if current_function then
            return current_function
        end
    end
    return ''
end

return {
    _init = init,
    error_status = error_status,
    warning_status = warning_status,
    info_status = info_status,
    hint_status = hint_status,
    current_function = current_function,
}
