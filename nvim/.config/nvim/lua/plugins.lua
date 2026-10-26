return {
  {
    "sainnhe/gruvbox-material",
    name = "gruvbox-material",
    priority = 1000,
    config = function()
      local appearance = vim.fn.system({ "defaults", "read", "-g", "AppleInterfaceStyle" })
      local is_dark = vim.v.shell_error == 0 and appearance:match("Dark") ~= nil
      vim.o.background = is_dark and "dark" or "light"
      vim.g.gruvbox_material_background = "medium"
      vim.g.gruvbox_material_enable_italic = true
      vim.cmd.colorscheme("gruvbox-material")

      -- Use one muted teal for changed lines and inline changes. Diffview's
      -- default two shades make dense changes difficult to scan.
      vim.api.nvim_set_hl(0, "DiffChange", { bg = "#1f3539" })
      vim.api.nvim_set_hl(0, "DiffText", { bg = "#1f3539" })

      -- Use Delta-like, low-contrast diff backgrounds. Tree-sitter still
      -- supplies the code syntax colors inside each changed line.
      vim.api.nvim_set_hl(0, "NeogitDiffContext", {})
      vim.api.nvim_set_hl(0, "NeogitDiffAdd", { fg = "#d5c4a1", bg = "#3b4430" })
      vim.api.nvim_set_hl(0, "NeogitDiffDelete", { fg = "#d5c4a1", bg = "#493431" })
      vim.api.nvim_set_hl(0, "NeogitDiffAddHighlight", { fg = "#d8d8d8", bg = "#4a5438" })
      vim.api.nvim_set_hl(0, "NeogitDiffDeleteHighlight", { fg = "#d8d8d8", bg = "#5a3d37" })
      vim.api.nvim_set_hl(0, "NeogitDiffAddInline", { fg = "#d5c4a1", bg = "#4a5438" })
      vim.api.nvim_set_hl(0, "NeogitDiffDeleteInline", { fg = "#d5c4a1", bg = "#5a3d37" })
      vim.api.nvim_set_hl(0, "NeogitActiveItem", { bg = "#3c3836", fg = "#ebdbb2", bold = true })
      vim.api.nvim_set_hl(0, "NeogitCommitViewHeader", { bg = "#32302f", fg = "#d79921", bold = true })
      vim.api.nvim_set_hl(0, "gitcommitSummary", { fg = "#ebdbb2", bold = true })
    end,
  },
  {
    "echasnovski/mini.nvim",
    version = false,
    config = function()
      require("mini.comment").setup()
      require("mini.completion").setup({
        lsp_completion = {
          process_items = function(items, base)
            local client = items[1] and vim.lsp.get_client_by_id(items[1].client_id)
            if client and client.name == "zk" then
              return items
            end
            return MiniCompletion.default_process_items(items, base)
          end,
        },
      })
      require("mini.files").setup({
        mappings = {
          go_in = "<CR>",
          go_in_plus = "L",
        },
        windows = {
          preview = true,
          width_focus = 40,
          width_nofocus = 15,
          width_preview = 50,
        },
      })
      require("mini.pairs").setup()
      require("mini.pick").setup()
      -- Give the active picker row a clear full-width background. The theme's
      -- Visual group is too subtle in the dark picker window.
      vim.api.nvim_set_hl(0, "MiniPickMatchCurrent", { bg = "#504945", fg = "#ebdbb2", bold = true })
      require("mini.extra").setup()
      require("mini.surround").setup()
    end,
  },
  {
    "nvim-tree/nvim-web-devicons",
    lazy = true,
  },
  {
    "mason-org/mason-lspconfig.nvim",
    dependencies = {
      { "mason-org/mason.nvim", opts = {} },
      "neovim/nvim-lspconfig",
    },
    opts = {
      ensure_installed = { "pyright" },
      automatic_enable = false,
    },
    config = function(_, opts)
      require("mason-lspconfig").setup(opts)
      require("config.python")
    end,
  },
  {
    "akinsho/bufferline.nvim",
    version = "*",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      options = {
        always_show_bufferline = true,
        diagnostics = false,
        mode = "tabs",
        name_formatter = function(tab)
          if tab.name == "NeogitStatus" then
            return "Neogit"
          end

          local diff_path = tab.path:match("%.git/:%d+:(.+)$")
          if diff_path then
            return "Diff: " .. vim.fn.fnamemodify(diff_path, ":~:.")
          end

          return vim.fn.fnamemodify(tab.path, ":~:.")
        end,
        show_buffer_close_icons = false,
        show_close_icon = false,
      },
    },
  },
  {
    "lewis6991/gitsigns.nvim",
    opts = {
      on_attach = function(bufnr)
        local gitsigns = require("gitsigns")

        vim.keymap.set("n", "<leader>gb", function()
          gitsigns.blame_line({ full = true })
        end, { buffer = bufnr, desc = "Show line blame" })
        vim.keymap.set("n", "<leader>gB", gitsigns.toggle_current_line_blame, {
          buffer = bufnr,
          desc = "Toggle current-line blame",
        })
      end,
    },
  },
  {
    "stevearc/quicker.nvim",
    ft = "qf",
    keys = {
      {
        "<leader>q",
        function()
          require("quicker").toggle()
        end,
        desc = "Toggle quickfix",
      },
      {
        "<leader>l",
        function()
          require("quicker").toggle({ loclist = true })
        end,
        desc = "Toggle location list",
      },
      { "]q", "<cmd>cnext<cr>", desc = "Next quickfix item" },
      { "[q", "<cmd>cprev<cr>", desc = "Previous quickfix item" },
    },
    opts = {},
  },
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    lazy = false,
    config = function()
      require("toggleterm").setup({
        direction = "float",
        open_mapping = [[<c-\>]],
        terminal_mappings = true,
        float_opts = {
          border = "curved",
          width = function()
            return math.floor(vim.o.columns * 0.92)
          end,
          height = function()
            return math.floor(vim.o.lines * 0.86)
          end,
        },
      })
    end,
  },
  {
    "sindrets/diffview.nvim",
    opts = {
      view = {
        default = { disable_diagnostics = true },
        file_history = { disable_diagnostics = true },
      },
    },
  },
  {
    "NeogitOrg/neogit",
    cmd = "Neogit",
    keys = {
      { "<leader>gg", "<cmd>Neogit<cr>", desc = "Open Neogit" },
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "sindrets/diffview.nvim",
    },
    opts = {
      disable_context_highlighting = true,
      treesitter_diff_highlight = true,
      integrations = {
        diffview = true,
        mini_pick = true,
      },
    },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter").setup()
      require("nvim-treesitter").install({
        "markdown",
        "markdown_inline",
        "bash",
        "graphql",
        "json",
        "javascript",
        "lua",
        "python",
        "sql",
        "typescript",
        "tsx",
      })

      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("StartTreeSitter", { clear = true }),
        pattern = {
          "javascript",
          "javascriptreact",
          "python",
          "typescript",
          "typescriptreact",
        },
        callback = function(event)
          pcall(vim.treesitter.start, event.buf)
        end,
      })
    end,
  },
  {
    "gaoDean/autolist.nvim",
    ft = "markdown",
    config = function()
      require("autolist").setup()

      local markdown = require("config.markdown")
      markdown.setup_mappings(vim.api.nvim_get_current_buf())
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "markdown",
        callback = function(event)
          markdown.setup_mappings(event.buf)
        end,
      })
    end,
  },
  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = "markdown",
    opts = {
      -- markdown-table-wrap.nvim owns pipe-table rendering so wide cells can
      -- wrap without breaking the table layout.
      pipe_table = { enabled = false },
      -- mermaid-nvim replaces Mermaid fenced blocks with an inline diagram.
      code = { disable = { "mermaid" } },
      -- LSP hover floats use an unlisted `nofile` Markdown buffer. Keep their
      -- code formatting but remove the redundant language title.
      overrides = {
        buftype = {
          nofile = { code = { language = false } },
        },
      },
    },
  },
  {
    "searleser97/mermaid-nvim",
    ft = "markdown",
    dependencies = { "MeanderingProgrammer/render-markdown.nvim" },
    opts = {
      -- termaid turns Mermaid source into terminal-friendly ASCII art, so it
      -- works in iTerm without requiring an image graphics protocol.
      cmd = { "termaid" },
      enabled = true,
      preview_mode = "float",
    },
    keys = {
      { "<leader>mt", "<cmd>MermaidToggle<cr>", desc = "Toggle Mermaid diagram" },
      { "<leader>mf", "<cmd>MermaidFloat<cr>", desc = "Preview Mermaid diagram" },
    },
  },
  {
    "ice345/markdown-table-wrap.nvim",
    ft = "markdown",
    dependencies = { "MeanderingProgrammer/render-markdown.nvim" },
    opts = {
      -- Keep rendering in the original buffer. The source table is revealed
      -- automatically while editing in Insert mode, then re-renders on leave.
      preview_mode = "inline",
      inline_mode = "replace",
      auto_preview = true,
      fit_to_window = true,
      max_width_ratio = 0.9,
      min_col_width = 8,
      max_col_width = 50,
    },
  },
  {
    "zk-org/zk-nvim",
    name = "zk",
    dependencies = { "echasnovski/mini.nvim" },
    opts = {
      picker = "minipick",
      lsp = {
        config = {
          cmd = { "zk", "lsp" },
          filetypes = { "markdown" },
          on_attach = function(_, bufnr)
            vim.keymap.set("n", "gd", vim.lsp.buf.definition, {
              buffer = bufnr,
              desc = "Open linked zk note",
            })
          end,
        },
        auto_attach = { enabled = true },
      },
    },
  },
  {
    "mistweaverco/kulala.nvim",
    event = { "SessionLoadPost", "VimLeavePre" },
    ft = { "http", "rest" },
    keys = {
      { "<leader>Rs", function() require("kulala").run() end, desc = "Send request" },
      { "<leader>Ra", function() require("kulala").run_all() end, desc = "Send all requests" },
      { "<leader>Rb", function() require("kulala").scratchpad() end, desc = "Open HTTP scratchpad" },
    },
    opts = {
      default_env = "local",
      environment_scope = "b",
      global_keymaps = false,
      kulala_keymaps = true,
      lsp = {
        enable = true,
        filetypes = { "http", "rest" },
        keymaps = false,
      },
    },
  },
}
