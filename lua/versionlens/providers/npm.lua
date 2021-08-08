local Provider = require("versionlens.providers.provider")
local Transform = require("versionlens.utils.transform")
local Query = require("nvim-treesitter.query")
local TSUtils = require("nvim-treesitter.ts_utils")
local Utils = require("versionlens.utils.ts")

local bin = "npm"
local args = { "outdated", "--json" }

local NpmProvider = Provider:new()
NpmProvider.__index = NpmProvider

function NpmProvider:new(additional_args)
  local effective_args = {}
  vim.list_extend(effective_args, args)
  vim.list_extend(effective_args, additional_args or {})
  local o = Provider:new("npm", bin, effective_args)
  return setmetatable(o, self)
end

function NpmProvider:map_packages_to_lines()
  for _, match in pairs(Query.get_matches(0, "npm_dependencies")) do
    local key, value = Utils.get_node_text(match.key.node), Utils.get_node_text(match.value.node)
    local line_number, _, _, _ = match.key.node:range()

    if self.result[key] then
      local v = self.result[key]
      self.result[key] = Transform.make_result_table(v.current, v.latest, line_number)
    else
      self.result[key] = Transform.make_result_table(value, value, line_number)
    end
  end
end

function NpmProvider:parse_audit()
  self.result = vim.fn.json_decode(table.concat(self.audit, ""))
  self:map_packages_to_lines()
end

function NpmProvider:apply_version()
  if self.result then
    local node = TSUtils.get_node_at_cursor()
    local is_dependency = false
    for _, match in pairs(Query.get_matches(0, "npm_roots")) do
      is_dependency = is_dependency or TSUtils.is_parent(match.dependency_type.node, node)
    end

    if not is_dependency then
      error("VersionLens: Cursor must be at dependency line!")
    end

    local parent = Utils.get_parent_of_type(node, "pair")

    if not parent then
      error("VersionLens: Cursor must be at dependency line!")
    end

    local childrens = TSUtils.get_named_children(parent)
    local version = childrens[2]

    if version and version:type() ~= "string" then
      error("VersionLens: Cursor must be at dependency line!")
    end

    local package = Utils.get_node_text(childrens[1]:named_child(0))

    local audit = self.result[package]

    if audit and audit.current ~= audit.latest then
      return version, audit.latest
    end

    return version, nil
  else
    error("VersionLens: Render lenses frist!")
  end
end

return NpmProvider
