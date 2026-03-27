return {
  "neovim/nvim-lspconfig",
  dependencies = {
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-path",
    "hrsh7th/cmp-cmdline",
    "hrsh7th/nvim-cmp",
    "L3MON4D3/LuaSnip",
    "saadparwaiz1/cmp_luasnip",
    "j-hui/fidget.nvim",
    {
      "folke/lazydev.nvim",
      ft = "lua",
      opts = {
        library = {
          { path = "${3rd}/luv/library", words = { "vim%.uv" } },
        },
      },
    },
    "mfussenegger/nvim-jdtls",
    "windwp/nvim-ts-autotag",
  },

  config = function()
    local cmp = require('cmp')
    local cmp_lsp = require("cmp_nvim_lsp")
    local capabilities = vim.tbl_deep_extend(
      "force",
      {},
      vim.lsp.protocol.make_client_capabilities(),
      cmp_lsp.default_capabilities())

    require("fidget").setup({})
    require("mason").setup()
    require("nvim-ts-autotag").setup({})

    require("mason-lspconfig").setup({
      ensure_installed = {
        "basedpyright",
        "buf_ls",
        "clangd",
        "cssls",
        "cssmodules_ls",
        -- "elixirls",
        "lua_ls",
        "gopls",
        -- "hls",
        -- "jdtls",
        "prismals",
        -- "ruff",
        "rust_analyzer",
        "solidity_ls_nomicfoundation",
        "ts_ls",
      },

      handlers = {
        -- Default Handler (applied to any server without a specific config below)
        function(server_name)
          vim.lsp.config(server_name, {
            capabilities = capabilities
          })
        end,

        ["clangd"] = function()
          vim.lsp.config("clangd", {
            cmd = {
              "clangd",
              "--background-index",
              "--pch-storage=memory",
              "--all-scopes-completion",
              "--pretty",
              "--header-insertion=never",
              "-j=4",
              "--inlay-hints",
              "--header-insertion-decorators",
              "--function-arg-placeholders",
              "--completion-style=detailed",
            },
            filetypes = { "c", "cpp", "objc", "objcpp" },
            capabilities = capabilities,
          })
        end,

        ["cssmodules_ls"] = function()
          vim.lsp.config("cssmodules_ls", {
            filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
            capabilities = capabilities,
            init_options = {
              camelCase = "dashes"
            }
          })
        end,

        ["elixirls"] = function()
          vim.lsp.config("elixirls", {
            capabilities = capabilities,
            settings = {
              elixirLS = {
                dialyzerEnabled = true,
                fetchDeps = false,
                enableTestLenses = true,
                suggestSpecs = true,
              }
            },
          })
        end,

        ["lua_ls"] = function()
          vim.lsp.config("lua_ls", {
            capabilities = capabilities,
            settings = {
              Lua = {
                runtime = { version = "Lua 5.1" },
                diagnostics = {
                  globals = { "bit", "vim", "it", "describe", "before_each", "after_each" },
                }
              }
            }
          })
        end,

        ["ruff"] = function()
          vim.lsp.config("ruff", {
            on_attach = function(client, _)
              client.server_capabilities.hoverProvider = false
            end
          })
        end,

        ["rust_analyzer"] = function()
          vim.lsp.config("rust_analyzer", {})
        end,

        ["solidity_ls_nomicfoundation"] = function()
          local util = require("lspconfig.util")
          vim.lsp.config("solidity_ls_nomicfoundation", {
            cmd = { "nomicfoundation-solidity-language-server", "--stdio" },
            filetypes = { "solidity" },
            root_dir = util.root_pattern("hardhat.config.js", "hardhat.config.ts", "foundry.toml", "forge.toml", ".git"),
            single_file_support = true,
            settings = {
              solidity = {
                remappings = {
                  ["@openzeppelin/"] = "lib/openzeppelin-contracts/",
                  ["forge-std/"] = "lib/forge-std/src/",
                  ["account-abstraction/"] = "lib/account-abstraction/"
                },
                formatting = {
                  provider = "prettierd",
                },
                linter = "solhint"
              },
            },
          })
        end,

        ["ts_ls"] = function()
          vim.lsp.config("ts_ls", {
            filetypes = { "typescript", "javascript", "typescriptreact", "javascriptreact" },
            capabilities = capabilities
          })
        end,
      }
    })
    vim.lsp.enable('clangd');

    -- Manual setup for Sourcekit (not managed by Mason)
    vim.lsp.config("sourcekit", {
      capabilities = {
        vim.tbl_deep_extend(
          "force", {
            workspace = {
              didChangeWatchedFiles = {
                dynamicRegistration = true
              }
            }
          },
          vim.lsp.protocol.make_client_capabilities(),
          cmp_lsp.default_capabilities())
      },
      before_init = function(_, config)
        if config.root_dir == nil then
          return
        end

        local build_server_path = config.root_dir .. "/buildServer.json"
        local stat = vim.loop.fs_stat(build_server_path)
        if stat and stat.type == "file" then
          return
        end

        -- Find .xcodeproj in root dir
        local xcodeproj = nil
        local handle = vim.loop.fs_scandir(config.root_dir)
        if handle then
          while true do
            local name, typ = vim.loop.fs_scandir_next(handle)
            if not name then break end
            if (typ == "directory" or typ == "link") and name:match("%.xcodeproj$") then
              xcodeproj = name
              break
            end
          end
        end

        if not xcodeproj then
          return
        end

        local scheme = xcodeproj:gsub("%.xcodeproj$", "")
        print("Generating buildServer.json for " .. scheme .. "...")

        -- Generate buildServer.json
        local config_cmd = string.format(
          "cd %s && xcode-build-server config -project %s -scheme %s",
          config.root_dir, xcodeproj, scheme
        )
        os.execute(config_cmd)

        -- Build in background so the index is populated
        local build_cmd = string.format(
          "cd %s && xcodebuild -project %s -scheme %s -destination 'generic/platform=iOS' build &",
          config.root_dir, xcodeproj, scheme
        )
        os.execute(build_cmd)
        print("Started xcodebuild in background for " .. scheme)
      end,
    })
    vim.lsp.enable('sourcekit');

    vim.lsp.config("basedpyright", {
      capabilities = capabilities,
      root_markers = { "pyrightconfig.json", "pyproject.toml", "setup.py", "setup.cfg", "requirements.txt", ".git" },
      settings = {
        basedpyright = {
          disableOrganizeImports = true,
          analysis = {
            ignore = { "*" },
            useLibraryCodeForTypes = true,
            typeCheckingMode = "standard",
            diagnosticMode = "openFilesOnly",
            autoImportCompletions = true,
          }
        },
      },
      before_init = function(_, config)
        local venv_base_path = table.concat({ vim.env.HOME, "virtualenvs" }, "/")
        local venv_python_path = table.concat({ venv_base_path, "default-venv", "bin", "python" }, "/")
        print("Before init")
        if config.root_dir ~= nil then
          local root_dir_name = ""
          for substring in string.gmatch(config.root_dir, "([^/]+)") do
            root_dir_name = substring
          end
          local project_venv_path = table.concat({ venv_base_path, root_dir_name }, "/")
          local project_venv_bin_path = table.concat({ project_venv_path, "bin", "python" }, "/")
          local function dir_exists(path)
            local stat = vim.loop.fs_stat(path)
            return stat and stat.type == 'directory'
          end
          if not dir_exists(project_venv_path) then
            os.execute(string.format("python3 -m venv %s", project_venv_path))
            print("Created virtual environment: ", project_venv_path)
            local requirements_path = table.concat({ config.root_dir, "requirements.txt" }, "/")
            local function file_exists(path)
              local stat = vim.loop.fs_stat(path)
              return stat and stat.type == 'file'
            end
            if file_exists(requirements_path) then
              os.execute(string.format("%s -m pip install -r %s", project_venv_bin_path,
                requirements_path))
              print("Installed dependencies from requirements.txt")
            else
              print("No requirements.txt file found.")
            end
          end
          venv_python_path = project_venv_bin_path
          print("setting venv: %s", venv_python_path)
        end

        config.settings.python = {
          pythonPath = venv_python_path
        }
      end,
    })
    vim.lsp.enable('basedpyright');

    local cmp_select = { behavior = cmp.SelectBehavior.Select }

    cmp.setup({
      snippet = {
        expand = function(args)
          require('luasnip').lsp_expand(args.body)
        end,
      },
      mapping = cmp.mapping.preset.insert({
        ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
        ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
        ['<C-y>'] = cmp.mapping.confirm({ select = true }),
        ["<C-Space>"] = cmp.mapping.complete(),
      }),
      sources = cmp.config.sources({
        { name = "lazydev", group_index = 0 },
        { name = 'nvim_lsp' },
        { name = 'luasnip' },
      }, {
        { name = 'buffer' },
        { name = 'path' },
      })
    })

    vim.diagnostic.config({
      update_in_insert = true,
      float = {
        focusable = true,
        style = "minimal",
        border = "rounded",
        source = "if_many",
        header = "",
        prefix = "",
      },
    })
  end
}
