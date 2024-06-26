local fmt = string.format

---@module "termacro.config"
local config = require("termacro.config")

local commands = {}

---@class comm
---@field key string
---@field command string
---@field buffer boolean

local function handle_command_input(key, command, old_command)
    if not command or command == "" then return end

    if not old_command then
        commands[key] = {
            key = key,
            command = command,
            buffer = true
        }
    else
        local val = commands[key]
        if val then
            val.command = command
            commands[key] = val
        end
    end

    vim.api.nvim_set_keymap("n", config.get("key")..key, '', {
        noremap = true,
        callback = function()
            vim.api.nvim_command(fmt(":sp vnew | .! %s", command))
        end
    })
end

local function create_command(key, old_command)

    local defatult_command = ""
    if old_command then
        defatult_command = old_command.command
    end

    local handle_input = function(command)
        handle_command_input(key, command, old_command)
    end

    vim.ui.input({
        prompt = fmt("Command for key %s > ", key),
        default = defatult_command,
        completion = "shellcmd",
    }, handle_input)
end

-- execute command or ask to user to set
---@param key string
function handle_command(key)

    local command = commands[key]

    if command then
        create_command(key, command)
        return
    end

    create_command(key)
end

return { handle_command = handle_command }
