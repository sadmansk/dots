return {
  "folke/sidekick.nvim",
  opts = {
    -- add any options here
    cli = {
      mux = {
        backend = "tmux",
        enabled = true,
      },
      default = "cursor", -- Set cursor as the default CLI tool
    },
  },
  keys = {
    {
      "<c-.>",
      function() require("sidekick.cli").toggle() end,
      desc = "Sidekick Toggle",
      mode = { "n", "t", "i", "x" },
    },
    {
      "<leader>aa",
      function() require("sidekick.cli").toggle() end,
      desc = "Sidekick Toggle CLI",
    },
    {
      "<leader>as",
      function() require("sidekick.cli").select({ filter = { installed = true, default="cursor" } }) end,
      -- Or to select only installed tools:
      -- require("sidekick.cli").select({ filter = { installed = true } })
      desc = "Select CLI",
    },
    {
      "<leader>ad",
      function() require("sidekick.cli").close() end,
      desc = "Detach a CLI Session",
    },
    {
      "<leader>at",
      function()
        require("sidekick.cli").send({
          filter = { name = "cursor" },
          msg = "{this}",
          focus = true
        })
      end,
      mode = { "x", "n" },
      desc = "Send This to Cursor",
    },
    {
      "<leader>af",
      function()
        require("sidekick.cli").send({
          filter = { name = "cursor" },
          msg = "{file}",
          focus = true
        })
      end,
      desc = "Send File to Cursor",
    },
    {
      "<leader>av",
      function()
        require("sidekick.cli").send({
          filter = { name = "cursor" },
          msg = "{selection}",
          focus = true
        })
      end,
      mode = { "x" },
      desc = "Send Visual Selection to Cursor",
    },
    {
      "<leader>ap",
      function()
        require("sidekick.cli").prompt({
          cb = function(msg)
            if msg then
              require("sidekick.cli").send({
                filter = { name = "cursor" },
                msg = msg,
                render = false,
                focus = true
              })
            end
          end
        })
      end,
      mode = { "n", "x" },
      desc = "Sidekick Select Prompt for Cursor",
    },
    -- open cursor directly
    {
      "<leader>ac",
      function() require("sidekick.cli").toggle({ name = "cursor", focus = true }) end,
      desc = "Sidekick Toggle Cursor",
    },
  },
}
