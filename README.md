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
    dir = "~/Documents/projects/termacro", -- path to where termacro was cloned
    name = "termacro",
    config = function ()
        require('termacro').setup({
            key = ";"
        })
    end
}
```

## TO-DO
- [ ] Add tests
- [ ] Make command output on buffer optional
- [ ] Make usage without having to use enter
- [ ] Make commands persist after exiting nvim
- [ ] Use temporary buffer that doens't need to be deleted (it's possible?)
- [ ] Edit commands
- [ ] See created commands
- [ ] User can create commands on configuration
- [ ] User can create default commands depending on the file type
- [ ] Add help

