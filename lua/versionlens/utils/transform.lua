local M = {}

M.make_result_table = function(current, latest, line_number)
  return {
    current = current,
    latest = latest,
    line_number = line_number,
  }
end

return M
