local api = vim.api

---@module "termacro.config"
local config = require("termacro.config")
---@module "termacro.commands"
local commands = require("termacro.commands")

local M = {}

local function setup_keymaps()
    local key = config.get("key")

    api.nvim_set_keymap("n", key, '', {
        noremap = true,
        callback = function()
            local k = vim.fn.input("key > ")
            commands.execute(k)
        end
    })
end

-- termacro.setup function
---@param user_config table: User configuration
function M.setup(user_config)
    config.set(user_config)
    setup_keymaps()
end

return M
