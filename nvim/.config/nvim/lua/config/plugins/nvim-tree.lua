return {
  "nvim-tree/nvim-tree.lua",
  version = "*",
  lazy = false,
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  opts = {
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
	  },
      filesystem_watchers = {
          ignore_dirs = {
              -- ignore bazel auto generated directories
              "bazel-out",
              "bazel-bin",
              "bazel-testlogs",
              "bazel-*", -- Catch all bazel symlinks
          },
      },
      filters = {
          custom = {
              -- Ignore bazel symlink directories
              "^bazel-out$",
              "^bazel-bin$",
              "^bazel-testlogs$",
              "^bazel-.*", -- Pattern to match any bazel- prefixed directory
          },
          exclude = {},
      },
  },
}
