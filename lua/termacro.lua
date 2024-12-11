local api = vim.api

---@module "termacro.config"
local config = require("termacro.config")
---@module "termacro.commands"
local commands = require("termacro.commands")

local M = {}

local function setup_keymaps()
    local key = config.get("key")
    local comms = config.get("default_commands")
    local exec_key = config.get("execute_key")

    if comms then
        for _, comm in ipairs(comms) do
            commands.CreateOrEditCommand(comm.key, comm.command, comm.buffer)
        end
    end

    local command_execute = function(c)
        if c and c ~= "" then
            commands.ExecuteCommand(c)
        end
    end

    api.nvim_set_keymap("n", key..exec_key, '', {
        noremap = true,
        callback = function()
            vim.ui.input({
                prompt = "terminal command > ",
                completion = "shellcmd",
            }, function(c) command_execute(c) end)
        end
    })

    local command_callback = function(k)
        if k and k ~= "" then
            commands.HandleCommand(k)
        end
    end

    api.nvim_set_keymap("n", key..key, '', {
        noremap = true,
        callback = function()
            vim.ui.input({
                prompt = "key > ",
            }, command_callback)
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
