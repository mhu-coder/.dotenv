-------------
-- General --
-------------
if not pcall(require, "dap") then
  return
end

local dap = require('dap')

local set_condition_bp = function()
  dap.set_breakpoint(vim.fn.input('Breakpoint condition: '))
end

local set_logpoint = function()
  dap.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))
end

local keymaps = {
  ['<F1>']=dap.step_into,
  ['<F2>']=dap.step_over,
  ['<F3>']=dap.step_out,
  ['<F4>']=dap.continue,
  ['<leader>db']=dap.toggle_breakpoint,
  ['<leader>dB']=set_condition_bp,
  ['<leader>dl']=set_logpoint,
  ['<leader>dr']=dap.repl.open,
}
local opts = { noremap=true, silent=true }
for keymap, fun in pairs(keymaps) do
  vim.keymap.set('n', keymap, fun, opts)
end

------------
-- Python --
------------
local venv = os.getenv("VIRTUAL_ENV")
if venv ~= nil then
  local pybin = venv .. "/bin/python"

  local dap_py = require("dap-python")
  dap_py.test_runner = 'pytest'
  dap_py.setup(pybin)

  local py_keymaps = {
    ['<leader>df']=dap_py.test_method,
    ['<leader>dc']=dap_py.test_class,
  }
  for keymap, fun in pairs(py_keymaps) do
    vim.keymap.set('n', keymap, fun, opts)
  end
end
