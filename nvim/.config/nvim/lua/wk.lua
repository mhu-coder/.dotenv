M = {}

function M.add_prefix(map_specs, prefix, group_name)
  for _, record in ipairs(map_specs) do
    record[1] = prefix .. record[1]
  end
  if prefix and group_name then
    table.insert(map_specs, 0, { prefix, group = group_name })
  end
  return map_specs
end

return M
