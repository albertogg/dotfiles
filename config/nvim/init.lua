--------------------
-- Package manager
--------------------
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

--------------------
-- Plugins
--------------------
require("lazy").setup({
  -- colorscheme
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000, -- make sure to load this before all the other start plugins
    config = function ()
      vim.cmd([[colorscheme tokyonight-storm]])
    end,
  },

  -- snacks
  {
    "folke/snacks.nvim",
    ---@type snacks.Config
    opts = {
      picker = {
        enabled = true,
        ui_select = true,
      },
    },
  },

  -- statusline
  {
    "nvim-lualine/lualine.nvim",
    config = function ()
      require("lualine").setup({
        options = {
          icons_enabled = false,
          theme = "auto",
          component_separators = "",
          section_separators = "",
        },
        sections = {
          lualine_c = {
            {
              "filename",
              file_status = true, -- displays file status (readonly status, modified status)
              path = 2 -- 0 = just filename, 1 = relative path, 2 = absolute path
            }
          }
        }
      })
    end,
  },

  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      preset = "classic",
      icons = {
        -- set to false to disable all mapping icons,
        -- both those explicitly added in a mapping
        -- and those from rules
        mappings = false,
      },
    },
    keys = {
      {
        "<leader>?",
        function()
          require("which-key").show({ global = false })
        end,
        desc = "Buffer Local Keymaps (which-key)",
      },
    },
  },

  -- telescope (fuzzy finder)
  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.6",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    config = function ()
      require("telescope").setup({
        pickers = {
          find_files = {
            -- `hidden = true` will still show the inside of `.git/` as it's not `.gitignore`d.
            find_command = { "rg", "--files", "--hidden", "--glob", "!**/.git/*" },
          },
        },
      })
    end,
  },

  -- file explorer
  {
    "stevearc/oil.nvim",
    opts = {},

    config = function ()
      require("oil").setup({
        view_options = {
          show_hidden = true,
        },

        vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
      })
    end
  },

  -- unix shell commands
  {
    "tpope/vim-eunuch",
  },

  -- git management
  {
    "tpope/vim-fugitive",
  },

  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require("gitsigns").setup {
        on_attach = function(bufnr)
          local gs = package.loaded.gitsigns

          -- Actions
          vim.keymap.set("n", "<leader>gb", function() gs.blame_line{full=true} end, { buffer = bufnr, desc = "Git [B]lame" })
          vim.keymap.set("n", "<leader>gtb", gs.toggle_current_line_blame, { buffer = bufnr, desc = "Git [T]oggle Blame" })
          vim.keymap.set("n", "<leader>gdt", gs.diffthis, { buffer = bufnr, desc = "Git [D]iff This" })
          vim.keymap.set("n", "<leader>gdd", function() gs.diffthis("~") end, { buffer = bufnr, desc = "Git [D]iff" })
          vim.keymap.set("n", "<leader>gtd", gs.toggle_deleted, { buffer = bufnr, desc = "Git [T]oggle Deleted" })
          vim.keymap.set("v", "<leader>gs", function() gs.stage_hunk {vim.fn.line("."), vim.fn.line("v")} end, { buffer = bufnr, desc = "Git [S]tage" })
          vim.keymap.set("v", "<leader>gr", function() gs.reset_hunk {vim.fn.line("."), vim.fn.line("v")} end, { buffer = bufnr, desc = "Git [R]eset" })

          -- Text object
          vim.keymap.set({"o", "x"}, "ih", ":<C-U>Gitsigns select_hunk<CR>", { buffer = bufnr, desc = "Select [H]unk" })
        end
      }
    end,
  },

  {
    "sindrets/diffview.nvim",
    config = function()
      require("diffview").setup({
        use_icons = false,
      })
    end,
  },

  -- commenting out lines
  {
    "numToStr/Comment.nvim",
    config = function()
      require("Comment").setup()
    end,
  },

  {
    "ellisonleao/glow.nvim",
    cmd = "Glow",
    config = function()
      require("glow").setup({
        style = "dark",
        width = 120,
      })
    end,
  },

  -- testing framework
  {
    "vim-test/vim-test",
    config = function ()
      vim.g["test#strategy"] = "neovim"
      vim.g["test#neovim#start_normal"] = "1"
      vim.g["test#neovim#term_position"] = "vert"
    end,
  },

   -- vim-go
  {
    "fatih/vim-go",
    config = function ()
      -- we disable most of these features because treesitter and nvim-lsp
      -- take care of it
      vim.g["go_gopls_enabled"] = 0
      vim.g["go_code_completion_enabled"] = 0
      vim.g["go_fmt_autosave"] = 0
      vim.g["go_imports_autosave"] = 0
      vim.g["go_mod_fmt_autosave"] = 0
      vim.g["go_doc_keywordprg_enabled"] = 0
      vim.g["go_def_mapping_enabled"] = 0
      vim.g["go_textobj_enabled"] = 0
      vim.g["go_list_type"] = "quickfix"
    end,
  },

  -- rust.vim
  {
    "rust-lang/rust.vim",
    config = function ()
      vim.g["rustfmt_autosave"] = 1
    end,
  },

  {
    "hashivim/vim-terraform",
  },

  -- lsp config
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "mason-org/mason.nvim",
      "mason-org/mason-lspconfig.nvim",
      "hrsh7th/nvim-cmp",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-cmdline",
    },
    config = function ()
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

      -- Ensure that we have required lsp's ready.
      require("mason").setup()

      require("mason-lspconfig").setup {
        ensure_installed = {
          "lua_ls",
          "rust_analyzer",
          "pyright",
          "ts_ls",
          "postgres_lsp",
        },
      }

      local cmp = require("cmp")

      cmp.setup.cmdline("/", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = "buffer" }
        }
      })

      cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          { name = "path" }
        }, {
          {
            name = "cmdline",
            option = {
              ignore_cmds = { "Man", "!" }
            }
          }
        })
      })

      local lsp_servers = {
        lua_ls = {
          capabilities = capabilities,
        },

        pyright = {
          capabilities = capabilities,
        },
        ts_ls = {
          capabilities = capabilities,
        },

        rust_analyzer = {
          capabilities = capabilities,
          -- Server-specific settings. See `:help lspconfig-setup`
          settings = {
            ["rust-analyzer"] = {},
          },
        },

        gopls = {
          capabilities = capabilities,
        },
      }

      -- Configure and enable each server
      for server_name, config in pairs(lsp_servers) do
        if next(config) ~= nil then
          -- Server has custom config
          vim.lsp.config[server_name] = config
        end
        vim.lsp.enable(server_name)
      end
    end,
  },

  -- CopilotChat.vim with Copilot
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    dependencies = {
      { "github/copilot.vim" }, -- or zbirenbaum/copilot.lua
      { "nvim-lua/plenary.nvim" }, -- for curl, log and async functions
    },
    build = "make tiktoken", -- Only on MacOS or Linux
    event = "VeryLazy",
    opts = {
      -- Default selection is the current buffer
      resources = {
        "buffer",
        "selection",
      },
      -- See Configuration section for options
      model = "claude-sonnet-4.5",
      chat_autocomplete = true,
      window = {
        layout = "float",
        relative = "cursor",
        width = 0.5,
        height = 0.5,
      },
      mappings = {
        -- Use tab for completion
        -- https://github.com/CopilotC-Nvim/CopilotChat.nvim/issues/701
        complete = {
          detail = "Use @<Tab> or /<Tab> for options.",
          -- Default <Tab> setting conflicts with cmp and coc-nvim
          insert = "<S-Tab>",
        },
      },
    },
    -- See Commands section for default commands if you want to lazy load on them
    keys = {
      {
        "<leader>ccq",
        function()
          local input = vim.fn.input("Quick Chat: ")
          if input ~= "" then
            require("CopilotChat").ask(input, { selection = require("CopilotChat.select").buffer })
          end
        end,
        desc = "CopilotChat - Quick chat",
      },
      {
        "<leader>cco",
        function()
          require("CopilotChat").open({ selection = require("CopilotChat.select").buffer })
        end,
        desc = "CopilotChat - Open Chat",
        mode = { "n", "i", "v" },
      },
    },
  },
})

--------------------
-- Configuration
--------------------
-- UI
vim.opt.termguicolors = true   -- Enable 24-bit RGB colors
vim.opt.colorcolumn = "80,100" -- Delimiter line at 80 and 100 characters
vim.opt.number = true          -- Show line numbers
vim.opt.showmatch = true       -- Highlight matching parenthesis
vim.opt.autowrite = true       -- Automatically save before :next, :make etc.
vim.opt.autochdir = false      -- Change CWD when I open a file
vim.opt.splitright = true      -- Split windows right to the current windows
vim.opt.splitbelow = true      -- Split windows below to the current windows
vim.opt.ignorecase = true      -- Search case insensitive
vim.opt.incsearch = true       -- Show matches while typing
vim.opt.hlsearch = true        -- Highlight search results

vim.opt.mouse = "a"                -- Enable mouse support
vim.opt.clipboard = "unnamedplus"  -- Copy/paste to system clipboard
vim.opt.swapfile = false           -- Don't use swapfile
vim.opt.ignorecase = true          -- Search case insensitive...
vim.opt.smartcase = true           -- ... but not it begins with upper case
vim.opt.list = true                -- Invisible characters notations
vim.opt.splitbelow = true          -- open split pane below
vim.opt.splitright = true          -- open split pane to the right

vim.opt.completeopt = { "menuone", "noinsert", "noselect", "popup" } -- Autocomplete options
vim.opt.listchars = "tab:»·,eol:¬,trail:·" -- Invisible characters notations

vim.opt.undofile = true
vim.opt.undodir = vim.fn.stdpath("data") .. "undo"

-- text formatting
vim.opt.autoindent = true -- copy indent from current line when starting a new line
vim.opt.expandtab = true  -- expand tabs into spaces
vim.opt.tabstop = 2       -- number of spaces a TAB counts for
vim.opt.softtabstop = 2   -- number of spaces a TAB counts for when editing
vim.opt.shiftwidth = 2    -- number of spaces to use for each step of indent
vim.opt.wrap = true
vim.opt.complete:append { "kspell" } -- Autocomplete with dictionary words when spell check is on

--------------------
-- Mappings
--------------------
vim.g.mapleader = ","

-- move through splits with ctrl + hjkl
vim.keymap.set("n", "<C-h>", "<C-w>h", { noremap = true, silent = false })
vim.keymap.set("n", "<C-j>", "<C-w>j", { noremap = true, silent = false })
vim.keymap.set("n", "<C-k>", "<C-w>k", { noremap = true, silent = false })
vim.keymap.set("n", "<C-l>", "<C-w>l", { noremap = true, silent = false })

-- Exit on jj and jk
vim.keymap.set("n", "j", "gj")
vim.keymap.set("n", "k", "gk")

-- Exit on jj and jk
vim.keymap.set("i", "jj", "<ESC>")
vim.keymap.set("i", "jk", "<ESC>")

-- complete
vim.keymap.set("i", "<leader>.", "<C-X><C-O>", { noremap = false, silent = false })

-- some useful quickfix shortcuts for quickfix
vim.keymap.set("n", "<C-n>", "<cmd>cnext<CR>zz")
vim.keymap.set("n", "<C-m>", "<cmd>cprev<CR>zz")

-- remove search highlight
vim.keymap.set("n", "<leader>*", ":nohlsearch<CR>", { noremap = true, silent = true })

-- Diagnostic keymaps
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Go to previous [D]iagnostic message" })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Go to next [D]iagnostic message" })
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { desc = "Show diagnostic [E]rror messages" })
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })

-- default augroup
local augroup = vim.api.nvim_create_augroup
local DefaultGroup = augroup("DefaultGroup", {})

local autocmd = vim.api.nvim_create_autocmd

-- clear trailing spaces
autocmd("BufWritePre", {
  group = DefaultGroup,
  pattern = "*",
  command = [[%s/\s\+$//e]],
})

-- telescope
local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>.", builtin.find_files, { desc = "Telescope - [.] Find Files" })
vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Telescope - [G]rep" })
vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Telescope - [B]uffers" })

-- vim-test
vim.keymap.set("n", "<leader>tt", ":TestNearest -v<CR>", { noremap = true, silent = true, desc = "Test [T]est Nearest" })
vim.keymap.set("n", "<leader>tf", ":TestFile -v<CR>", { noremap = true, silent = true, desc = "Test [T]est File" })

-- file format based on file type
autocmd("FileType", {
  group = vim.api.nvim_create_augroup("ftdetect", { clear = true }),
  pattern = { "*.go", "*.make", "*.xml" },
  command = "setlocal noexpandtab softtabstop=4 shiftwidth=4 tabstop=4",
})

-- run gofmt/gofmpt, import packages automatically on save
autocmd("BufWritePre", {
  group = vim.api.nvim_create_augroup("setGoFormatting", { clear = true }),
  pattern = "*.go",
  callback = function()
    local params = vim.lsp.util.make_range_params()
    params.context = { only = { "source.organizeImports" } }
    local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, 2000)
    for _, res in pairs(result or {}) do
      for _, r in pairs(res.result or {}) do
        if r.edit then
          vim.lsp.util.apply_workspace_edit(r.edit, "utf-16")
        else
          vim.lsp.buf.execute_command(r.command)
        end
      end
    end

    vim.lsp.buf.format()
  end
})

-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("UserLspConfig", {}),
  callback = function(ev)
    -- Buffer local mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    vim.keymap.set("n", "<leader>v", "<cmd>vsplit | lua vim.lsp.buf.definition()<CR>", { buffer = ev.buf, desc = "Go to [V]ertical split definition" })
    vim.keymap.set("n", "<leader>s", "<cmd>belowright split | lua vim.lsp.buf.definition()<CR>", { buffer = ev.buf, desc = "Go to [S]plit definition" })
    vim.keymap.set("n", "<leader>cl", vim.lsp.codelens.run, { buffer = ev.buf, desc = "Run [C]ode lens" })
    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { buffer = ev.buf, desc = "[R]ename" })
    vim.keymap.set({"n", "v"}, "<leader>ca", vim.lsp.buf.code_action, { buffer = ev.buf, desc = "Code [A]ction" })

    vim.keymap.set("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>",  { buffer = ev.buf, desc = "Go to [D]efinition" })
    vim.keymap.set("n", "gr", vim.lsp.buf.references, { buffer = ev.buf, desc = "Go to [R]eferences" })
    vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { buffer = ev.buf, desc = "Go to [D]eclaration" })
    vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = ev.buf, desc = "Show [K]ind of symbol" })
    vim.keymap.set("n", "gi", vim.lsp.buf.implementation, { buffer = ev.buf, desc = "Go to [I]mplementation" })
  end,
})

-- automatically resize all vim buffers if I resize the terminal window
vim.api.nvim_command("autocmd VimResized * wincmd =")

-- autocmd
vim.cmd [[
  augroup _git
    autocmd!
    autocmd FileType gitcommit setlocal wrap
    autocmd FileType gitcommit setlocal spell
  augroup end

  augroup _markdown
    autocmd!
    autocmd FileType markdown setlocal wrap
    autocmd FileType markdown setlocal spell
  augroup end
]]
