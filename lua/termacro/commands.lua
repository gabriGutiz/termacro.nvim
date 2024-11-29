local fmt = string.format

---@module "termacro.config"
local config = require("termacro.config")

local commands = {}

---@class comm
---@field key string
---@field command string
---@field buffer boolean

local function create_command(key, old_command)

    local defatult_command = ""
    local handle_input = function(command)
        CreateOrEditCommand(key, true, command, true)
    end

    if old_command then
        defatult_command = old_command.command

        handle_input = function(command)
            CreateOrEditCommand(key, false, command, old_command.buffer)
        end
    end

    vim.ui.input({
        prompt = fmt("Command for key %s > ", key),
        default = defatult_command,
        completion = "shellcmd",
    }, handle_input)
end

-- create or edit command
---@param key string: key to map command
---@param new boolean: is new command
---@param command string: command
---@param buffer boolean: output in buffer option
function CreateOrEditCommand(key, new, command, buffer)
    if not command or command == "" then return end

    if new then
        commands[key] = {
            key = key,
            command = command,
            buffer = buffer
        }
    else
        local val = commands[key]
        if val then
            val.command = command
            val.buffer = buffer
            commands[key] = val
        end
    end

    local command_exec = fmt(":sp vnew | .! %s", command)
    if not buffer then
        command_exec = fmt(":!%s", command)
    end

    vim.api.nvim_set_keymap("n", config.get("key")..key, '', {
        noremap = true,
        callback = function()
            vim.api.nvim_command(command_exec)
            vim.opt.buftype = "nowrite"
        end
    })
end

-- execute command or ask to user to set
---@param key string
function HandleCommand(key)
    local command = commands[key]

    if command then
        create_command(key, command)
        return
    end

    create_command(key)
end

return {
    HandleCommand = HandleCommand,
    CreateOrEditCommand = CreateOrEditCommand
}
