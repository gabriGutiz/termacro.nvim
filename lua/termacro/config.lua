local M = {}

---@class TermacroConfig
---@field key string

---@type TermacroConfig
local config = {
    key = ";"
}

--- get the full user config or just a specified value
---@param key string?
---@return any
function M.get(key)
  if key then return config[key] end
  return config
end

---@param user_conf TermacroConfig
---@return TermacroConfig
function M.set(user_conf)
    user_conf = user_conf or {}

    config = vim.tbl_extend("force", config, user_conf)

    return config
end

---@retrun TermacroConfig
return setmetatable(M, {
    __index = function(_, k) return config[k] end
})
