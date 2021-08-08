local M = {
  _cache = {},
}

M.run_provider = function(provider_config, callback)
  local provider = provider_config[1]
  local args = provider_config[2]

  if provider == "npm" and string.find(vim.api.nvim_buf_get_name(0), "package.json", 1, true) then
    if not M._cache[provider] then
      M._cache[provider] = require("versionlens.providers.npm"):new(args)
    end

    M._cache[provider]:get_audit(callback)
    return
  end

  error("VersionLens: No provider for " .. provider .. " or opened buffer isn't versions file!")
end

M.apply_version = function(provider)
  if provider == "npm" and M._cache[provider] then
    return M._cache[provider]:apply_version()
  end
end

return M
