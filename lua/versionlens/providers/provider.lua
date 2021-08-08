local Path = require("plenary.path")
local Job = require("plenary.job")

local Provider = {
  name = "",
  audit = nil,
  result = nil,
}
Provider.__index = Provider

function Provider:new(name, command, args)
  local o = {}
  self.name = name
  self.command = command or ""
  self.args = args or {}
  return setmetatable(o, self)
end

function Provider:parseAudit() -- luacheck: ignore 212/self
  error("This method must be implemented!")
end

function Provider:apply_version() -- luacheck: ignore 212/self
  error("This method must be implemented!")
end

function Provider:get_audit(callback)
  Job
    :new({
      command = self.command,
      args = self.args,
      cwd = Path:new(vim.api.nvim_buf_get_name(0)):parents()[1],
      on_start = function()
        print("VersionLens: Getting data for " .. self.name .. " provider!")
      end,
      on_exit = vim.schedule_wrap(function(job, exitCode)
        if exitCode == 0 or exitCode == 1 then
          self.audit = job:result()
          self:parse_audit()
          if callback then
            callback(self.result)
          end
          print("VersionLens: Finished job for " .. self.name .. " provider!")
        end
      end),
    })
    :start()
end

return Provider
