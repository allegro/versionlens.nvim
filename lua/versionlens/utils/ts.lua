local Utils = require("nvim-treesitter.ts_utils")

local M = {}

M.get_node_text = function(node)
  return Utils.get_node_text(node)[1]
end

M.get_parent_of_type = function(node, type)
  local tmp = node

  while tmp:type() ~= type do
    tmp = tmp:parent()
  end

  return tmp
end

return M
