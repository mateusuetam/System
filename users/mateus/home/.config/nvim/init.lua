-- neovim
vim.api.nvim_set_hl(0,"StatusLine",{bg="none"})
vim.api.nvim_set_hl(0,"StatusLineNC",{bg="none"})
vim.api.nvim_set_hl(0,'Comment',{bold=true,undercurl=true})
vim.opt.termguicolors=false
vim.opt.number=true
vim.opt.relativenumber=false
vim.opt.updatetime=250
vim.opt.inccommand="split"
vim.opt.colorcolumn="0"
vim.opt.tabstop = 3
vim.opt.shiftwidth = 3
vim.opt.expandtab = false
vim.opt.list = true
vim.opt.listchars = {tab='  ',trail='•',nbsp='␣'}

-- netrw
vim.g.netrw_liststyle=3
vim.g.netrw_browse_split=2
vim.g.netrw_keepdir=0
vim.g.netrw_banner=0

-- remap
vim.g.mapleader = ' '
vim.keymap.set('n', '<leader>e', '<cmd>Alpha<CR>')
vim.keymap.set('n', '<leader>w', vim.cmd.w)
vim.keymap.set('n', '<leader>q', vim.cmd.q)
vim.keymap.set({ 'n', 'v' }, '<leader>y', '"+y')
vim.keymap.set({ 'n', 'v' }, '<leader>p', '"+p')
vim.keymap.set('n', '<leader>r', [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
vim.keymap.set('n', '<leader><k4>', ':%left<CR>')
vim.keymap.set('n', '<leader><k8>', '<cmd>global/^$/delete<CR>')
vim.keymap.set('n', '<leader><k6>', 'mzgg=G`z')
vim.keymap.set('n', '<leader><k1>', ':%s/  \\+/ /g<CR>')
vim.keymap.set('n', '<leader><k7>', ':%s/\\s\\+$//e<CR>')
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- telescope
local telescope_loaded = false

local function telescope_setup()
if telescope_loaded then
return
end

vim.cmd("packadd plenary.nvim")
vim.cmd("packadd telescope.nvim")

require("telescope").setup({
defaults = {
file_ignore_patterns = {
"%.cache",
"%.config/GIMP",
"%.config/dconf",
"%.config/discord",
"%.config/gtk%-3%.0",
"%.config/mozilla",
"nvim/pack/.*",
"%.config/mprocps",
"%.config/pulse",
"%.config/unity3d",
"%.java",
"%.local",
"%.mysql",
"%.netbeans",
"%.pki",
"%.steam",
"netbeans",
"node_modules",
"%.git/",
"target/",
"dist/"
},
},
pickers = {
find_files = {
hidden = true,
},
},
})

telescope_loaded = true
end

function telescope_find_files()
telescope_setup()
require("telescope.builtin").find_files()
end

function telescope_oldfiles()
telescope_setup()
require("telescope.builtin").oldfiles()
end

vim.keymap.set('n', '<leader>f', telescope_find_files)

-- alpha
local alpha=require("alpha")
local dashboard=require("alpha.themes.dashboard")
dashboard.section.header.val={
[[ .              +   .                .   . .     .  .  ]],
[[                   .                    .       .     *]],
[[.       *                        . . . .  .   .  + .   ]],
[[            "You Are Here"            .   .  +  . . .  ]],
[[.                 |             .  .   .    .    . .   ]],
[[                  |           .     .     . +.    +  . ]],
[[                 \|/            .       .   . .        ]],
[[        . .       V          .    * . . .  .  +   .    ]],
[[           +      .           .   .      +             ]],
[[                            .       . +  .+. .         ]],
[[  .                      .     . + .  . .     .      . ]],
[[           .      .    .     . .   . . .        ! /    ]],
[[      *             .    . .  +    .  .       - O -    ]],
[[          .     .    .  +   . .  *  .       . / |      ]],
[[               . + .  .  .  .. +  .                    ]],
[[.      .  .  .  *   .  *  . +..  .            *        ]],
[[ .      .   . .   .   .   . .  +   .    .            + ]]
}
dashboard.section.buttons.val={
dashboard.button("n"," Novo",":ene <BAR> startinsert <CR>"),
dashboard.button("f","󰱽 Procurar",":lua telescope_find_files()<CR>"),
dashboard.button("r"," Recentes",":lua telescope_oldfiles()<CR>"),
dashboard.button("e","󰙅 Explorar",":Ex <CR>"),
dashboard.button("q","󰅚 Sair",":qa <CR>")
}
alpha.setup(dashboard.config)
