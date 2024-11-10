-------------
-- General --
-------------
local ok_dap, dap = pcall(require, "dap")
if not ok_dap then
  print("nvim-dap is not installed! Aborting...")
  return
end

local wk_utils = require("wk")

dap.set_log_level('INFO')

local set_condition_bp = function()
  dap.set_breakpoint(vim.fn.input('Breakpoint condition: '))
end

local set_logpoint = function()
  dap.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))
end

local km = {
  { "1", dap.step_into,         desc = "Step into instruction" },
  { "2", dap.step_over,         desc = "Step over instruction" },
  { "3", dap.step_out,          desc = "Step out of current scope" },
  { "4", dap.continue,          desc = "Resume program" },
  { "9", dap.terminate,         desc = "Terminate debugging session" },
  { "b", dap.toggle_breakpoint, desc = "Toggle breakpoint" },
  { "B", set_condition_bp,      desc = "Set conditional breakpoint" },
  { "l", set_logpoint,          desc = "Set log point" },
  { "r", dap.repl.open,         desc = "Open REPL" },
}
local wk = require("which-key")
wk.add(wk_utils.add_prefix(km, "<leader>b", "DAP"))

------------
-- Python --
------------
local venv = os.getenv("VIRTUAL_ENV")
if venv ~= nil then
  local ok, dap_py = pcall(require, "dap-python")
  if not ok then
    vim.notify("dap-python not available. No debugger will be available.")
  else
    local pybin = venv .. "/bin/python"

    dap_py.test_runner = 'pytest'
    dap_py.setup(pybin)

    local py_km = {
      { "f", dap_py.test_method, desc = "Test method" },
      { "c", dap_py.test_class,  desc = "Test class" },
    }
    wk.add(wk_utils.add_prefix(py_km, "<leader>b"))
  end
end


----------
-- Rust --
----------
dap.adapters.codelldb = {
  type = 'server',
  port = '${port}',
  executable = {
    command = '/usr/local/bin/codelldb',
    args = { "--port", "${port}" },
  }
}
dap.configurations.rust = {
  {
    name = "Rust debug",
    type = "codelldb",
    request = "launch",
    program = function()
      return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/target/debug/', 'file')
    end,
    cwd = '${workspaceFolder}',
    stopOnEntry = true,
  }
}
