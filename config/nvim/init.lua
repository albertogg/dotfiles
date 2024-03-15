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

  -- git management
  {
    "NeogitOrg/neogit",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "sindrets/diffview.nvim",
      "nvim-telescope/telescope.nvim",
    },
    config = true
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

  -- commenting out lines
  {
    "numToStr/Comment.nvim",
    config = function()
      require("Comment").setup() 
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
    "hashivim/vim-terraform"
  },

  -- lsp config
  {
    "neovim/nvim-lspconfig",
    config = function ()
      local lspconfig = require("lspconfig")

      lspconfig.rust_analyzer.setup {
        -- Server-specific settings. See `:help lspconfig-setup`
        settings = {
          ["rust-analyzer"] = {},
        },
      }

      lspconfig.gopls.setup {
        flags = { debounce_text_changes = 200 },
        settings = {
          gopls = {
            usePlaceholders = true,
            gofumpt = true,
            analyses = {
              nilness = true,
              unusedparams = true,
              unusedwrite = true,
              useany = true,
            },
            codelenses = {
              gc_details = false,
              generate = true,
              regenerate_cgo = true,
              run_govulncheck = true,
              test = true,
              tidy = true,
              upgrade_dependency = true,
              vendor = true,
            },
            experimentalPostfixCompletions = true,
            completeUnimported = true,
            staticcheck = true,
            directoryFilters = { "-.git", "-node_modules" },
            semanticTokens = true,
            hints = {
              assignVariableTypes = true,
              compositeLiteralFields = true,
              compositeLiteralTypes = true,
              constantValues = true,
              functionTypeParameters = true,
              parameterNames = true,
              rangeVariableTypes = true,
            },
          },
        },
      }
    end,
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
vim.opt.list = true -- Invisible characters notations
vim.opt.splitbelow = true          -- open split pane below
vim.opt.splitright = true          -- open split pane to the right

vim.opt.completeopt = { "menuone", "noinsert", "noselect" } -- Autocomplete options
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

-- Some useful quickfix shortcuts for quickfix
vim.keymap.set("n", "<C-n>", "<cmd>cnext<CR>zz")
vim.keymap.set("n", "<C-m>", "<cmd>cprev<CR>zz")

-- Remove search highlight
vim.keymap.set("n", "<leader>*", ":nohlsearch<CR>", { noremap = true, silent = true })

-- telescope
local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>.", builtin.find_files, {})
vim.keymap.set("n", "<leader>fg", builtin.live_grep, {})
vim.keymap.set("n", "<leader>fb", builtin.buffers, {})

-- vim-test
vim.keymap.set("n", "<leader>tt", ":TestNearest -v<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>tf", ":TestFile -v<CR>", { noremap = true, silent = true })

-- file format based on file type
vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("ftdetect", { clear = true }),
  pattern = { "*.go", "*.make", "*.xml" },
  command = "setlocal noexpandtab softtabstop=4 shiftwidth=4 tabstop=4",
})

-- Run gofmt/gofmpt, import packages automatically on save
vim.api.nvim_create_autocmd("BufWritePre", {
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
    local opts = { buffer = ev.buf }

    vim.keymap.set("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
    vim.keymap.set("n", "<leader>v", "<cmd>vsplit | lua vim.lsp.buf.definition()<CR>", opts)
    vim.keymap.set("n", "<leader>s", "<cmd>belowright split | lua vim.lsp.buf.definition()<CR>", opts)

    vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
    vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
    vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
    vim.keymap.set("n", "<leader>cl", vim.lsp.codelens.run, opts)
    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
    vim.keymap.set({"n", "v"}, "<leader>ca", vim.lsp.buf.code_action, opts)
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
