-- Remap telescope stuff:
local builtin = require("telescope.builtin")

vim.keymap.set('n', "<leader>pf", builtin.find_files, {})
vim.keymap.set('n', "<C-p>", builtin.git_files, {})
vim.keymap.set('n', "<leader>ps", function()
	builtin.grep_string( { search = vim.fn.input("Telescope Grep > ") });
end)

-- Source is an awesome SO answer by @rainer: https://stackoverflow.com/a/75500661
-- Enabling Viewing dotfiles like .gitignore
local telescope = require('telescope')
local telescopeConfig = require('telescope.config')
local vimgrep_arguments = { unpack(telescopeConfig.values.vimgrep_arguments) }

table.insert(vimgrep_arguments, "--hidden")

-- Ignore the `.git` directory
table.insert(vimgrep_arguments, "--glob")
table.insert(vimgrep_arguments, "!**/.git/*")

telescope.setup{
    defaults = {
        hidden = true,
        vimgrep_arguments = vimgrep_arguments,
    },
    pickers = {
        find_files = {
            hidden = true,
            -- `hidden = true` will still show the inside of `.git/` as it's not `.gitignore`d.
            find_command = { "rg", "--files", "--hidden", "--glob", "!**/.git/*" },
        },
        live_grep = {
             additional_args = function(_ts)
                 return {"--hidden"}
             end
        },
    },
}


