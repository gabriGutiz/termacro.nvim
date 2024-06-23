local commands = {}

local fmt = string.format

---@class comm
---@field key string
---@field command string
---@field buffer boolean

local function create_command(key)
    local command = vim.fn.input(fmt("Command for key %s > ", key))

    table.insert(commands, {
        key = key,
        command = command,
        buffer = false
    })
end

-- execute command or ask to user to set
---@param key string
function Execute(key)
    for _, val in ipairs(commands) do
        if val.key == key then
            if val.buffer then
                vim.api.nvim_command(fmt(":! %s", val.command))
            else
                vim.api.nvim_command(fmt(":sp vnew | .! %s", val.command))
            end
            return
        end
    end

    create_command(key)
end

return { execute = Execute }
