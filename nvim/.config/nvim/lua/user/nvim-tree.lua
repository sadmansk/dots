-- import nvim-tree plugin safely
local setup, nvimtree = pcall(require, "nvim-tree")
if not setup then
  return
end

-- recommended settings from nvim-tree documentation
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

nvimtree.setup {
  disable_netrw       = true,
  hijack_netrw        = true,
  hijack_directories  = {
    enable = true,
    auto_open = true,
  },
  open_on_tab         = false,
  hijack_cursor       = false,
  update_cwd          = false,
  diagnostics         = {
  enable = false,
  icons = {
    hint = "",
    info = "",
    warning = "",
    error = "",
      }
  },
  update_focused_file = {
    enable      = false,
    update_cwd  = false,
    ignore_list = {}
  },
  system_open = {
    cmd  = nil,
    args = {}
  },
  view = {
    width = {
        min = 40,
        max = 80
    },
    side = 'left',
  },
  renderer = {
    symlink_destination = true,
  },
  actions = {
    open_file = {
      resize_window = false,
      quit_on_open = true
    }
  }
}
