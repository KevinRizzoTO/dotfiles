-- vimwiki options need to be set before the plugin is loaded for some reason
vim.g.vimwiki_list = {
  {
    path = '~/notes/',
    syntax = 'markdown',
    ext = '.md',
    links_space_char = '_',
  }
}

vim.g.vimwiki_ext2syntax = {
  ['.md'] = 'markdown',
  ['.markdown'] = 'markdown',
  ['.mdown'] = 'markdown',
}

vim.g.vimwiki_global_ext = 0

vim.g.vimwiki_markdown_link_ext = 1

require("krizzo/plugins")
require('krizzo/set')
require('krizzo/remap')

vim.g.netrw_browse_split = 0
vim.g.netrw_banner = 0
vim.g.netrw_winsize = 25

