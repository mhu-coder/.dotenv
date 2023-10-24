local ok_dap, dap = pcall(require, "dap")
local ok_ui, dapui = pcall(require, "dapui")
if not (ok_dap and ok_ui) then
  vim.notify("dap or dap-ui is not installed! Aborting...", vim.log.levels.WARN)
  return
end

local function fix_windows()
  vim.api.nvim_feedkeys(
    vim.api.nvim_replace_termcodes("<C-w>=", false, true, true), "n", false
  )
end

dap.listeners.after.event_initialized["dapui_config"] = function()
  dapui.open()
  fix_windows()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
  dapui.close()
  fix_windows()
end
dap.listeners.before.event_exited["dapui_config"] = function()
  dapui.close()
  fix_windows()
end

dapui.setup()
