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
        CreateOrEditCommand(key, command, true)
    end

    if old_command then
        defatult_command = old_command.command

        handle_input = function(command)
            CreateOrEditCommand(key, command, old_command.buffer)
        end
    end

    vim.ui.input({
        prompt = fmt("Command for key %s > ", key),
        default = defatult_command,
        completion = "shellcmd",
    }, handle_input)
end

local function execute_command_output_in_split_buf(command)
    local buf = vim.api.nvim_create_buf(false, true)
    vim.cmd("split")
    local win = vim.api.nvim_get_current_win()
    vim.api.nvim_win_set_buf(win, buf)
    vim.api.nvim_set_option_value("bufhidden", "wipe", { buf = buf })
    vim.api.nvim_set_option_value("modifiable", true, { buf = buf })
    vim.fn.termopen(command, {
        on_exit = function(_, code, _)
            vim.notify("[Process exited with code "..code.."]", vim.log.levels.INFO)
        end
    })
    -- Move cursor to the end of the buffer
    local line_count = vim.api.nvim_buf_line_count(buf)
    vim.api.nvim_win_set_cursor(win, { line_count, 0 })
end

-- create or edit command
---@param key string: key to map command
---@param command string: command
---@param buffer boolean: output in buffer option
function CreateOrEditCommand(key, command, buffer)
    if not command or command == "" then return end

    local val = commands[key]
    if val then
        val.command = command
        val.buffer = buffer
        commands[key] = val
    else
        commands[key] = {
            key = key,
            command = command,
            buffer = buffer
        }
    end

    vim.api.nvim_set_keymap("n", config.get("key")..key, '', {
        noremap = true,
        callback = function()
            if buffer then
                execute_command_output_in_split_buf(command)
            else
                vim.cmd(fmt(":!%s", command))
            end
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
