return {
  "https://github.com/rbmarliere/gitree.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    { "nvim-telescope/telescope.nvim", branch = "0.1.x" },
  },
  keys = {
    {
      "<Leader>fw",
      function()
        require("telescope").extensions.gitree.list()
      end,
      desc = "List worktrees",
    },
    {
      "<Leader>fe",
      function()
        require("telescope").extensions.gitree.list(vim.fn.expand("%:."))
      end,
      desc = "Open current file in another worktree",
    },
  },
  init = function()
    require("telescope").setup({
      extensions = {
        gitree = {
          -- example: init submodules upon worktree creation
          on_add = function()
            vim.system({ "git", "submodule", "update", "--init", "--recursive" })
          end,
          -- example: rename tmux window for currently selected worktree
          on_select = function()
			if os.getenv("TMUX") then
				local cwd = os.getenv("PWD")
				if not cwd then return end
				vim.system({ "git", "rev-parse", "--show-toplevel" }, nil, function(o)
					local wt = o.stdout
					if not wt then return end
					local label = wt:sub(#cwd + 2):gsub("\n", "")
					vim.system({ "tmux", "rename-window", label })
				end)
			end
		end,
        },
      },
    })
    require("telescope").load_extension("gitree")
  end,
}
