local M = {}

M._config = {
  enabled_providers = {},
  render_up_to_date = true,
  signs = {
    need_update = "🔺",
    up_to_date = "✅",
  },
}

M.normalize = function(config)
  M._config.enabled_providers = vim.tbl_map(function(value)
    if type(value) == "string" then
      return { value, {} }
    elseif value.name then
      return { value.name, value[1] }
    elseif value.args then
      return { value[1], value.args }
    elseif value.name and value.args then
      return { value.name, value.args }
    end

    return value
  end, config.enabled_providers)
  if config.render_up_to_date ~= nil then
    M._config.render_up_to_date = config.render_up_to_date
  end
  M._config.signs = vim.tbl_extend("force", M._config.signs, config.signs or {})
end

M.get = function(key)
  return M._config[key]
end

return M
