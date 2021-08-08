local Config = require("versionlens.config")

local api = vim.api

local M = {
  _ns = api.nvim_create_namespace("versionlens"),
}

M.setup = function(config)
  Config.normalize(config)
end

M.render = function()
  for _, provider in pairs(Config.get("enabled_providers")) do
    require("versionlens.providers").run_provider(provider, function(audit)
      api.nvim_buf_clear_namespace(0, M._ns, 0, -1)
      for _, v in pairs(audit) do
        if v.current ~= v.latest then
          api.nvim_buf_set_virtual_text(
            0,
            M._ns,
            v.line_number,
            { { Config.get("signs").need_update .. " " }, { v.latest } },
            {}
          )
        elseif Config.get("render_up_to_date") and Config.get("signs") then
          api.nvim_buf_set_virtual_text(0, M._ns, v.line_number, { { Config.get("signs").up_to_date } }, {})
        end
      end
    end)
  end
end

M.apply_version = function()
  for _, provider in pairs(Config.get("enabled_providers")) do
    local status, node, version = pcall(require("versionlens.providers").apply_version, provider[1])

    if status and version then
      local sl, sc, el, ec = node:range()
      api.nvim_buf_set_text(0, sl, sc + 1, el, ec - 1, { version })

      if Config.get("render_up_to_date") then
        api.nvim_buf_set_virtual_text(0, M._ns, sl, { { Config.get("signs").up_to_date } }, {})
      end
    elseif not status then
      error(node)
    end
  end
end

return M
