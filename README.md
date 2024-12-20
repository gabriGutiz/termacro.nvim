# Termacro
A nvim plugin to create macros to your terminal commands.

*For now termacro.nvim is a test and is not in it's best version.*

## Setup

### Clone the repository
Clone the repository in your machine.
```bash
$ git clone https://github.com/gabriGutiz/termacro.nvim
```

### Add plugin to neovim
Add using lazy.nvim:
```lua
return {
    dir = "~/Documents/projects/termacro.nvim", -- path to where termacro was cloned
    name = "termacro",
    config = function ()
        require('termacro').setup({
            key = ";",                          -- sets the key to use termacro | default ';'
            default_commands = {                -- default commands to be implemented when neovim is started
                {
                    key = "l",
                    command = "ls -al",
                    buffer = true               -- show output in a buffer updated in real time
                }
            },
            execute_key = "e"                   -- key to execute a command passed in execution | default 'e'
        })
    end
}
```

## TO-DO
- [ ] Add tests
- [ ] Make command output on buffer optional when added by ;;
- [x] Command usage without having to use input
- [ ] Make commands persist after exiting nvim
- [x] Use temporary buffer that doesn't need to be deleted
- [x] Edit commands
- [ ] See created commands
- [x] User can create commands on configuration
- [ ] User can create default commands depending on the file type
- [ ] Add help

