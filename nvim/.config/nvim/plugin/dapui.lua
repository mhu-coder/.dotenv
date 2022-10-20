local ok_dap, dap = pcall(require, "dap")
local ok_ui, dapui = pcall(require, "dapui")
if not (ok_dap and ok_ui) then
  return
end

dap.listeners.after.event_initialized["dapui_config"] = function()
  dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
  dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
  dapui.close()
end

dapui.setup()
