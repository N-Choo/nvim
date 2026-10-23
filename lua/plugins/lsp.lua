return {
  -- Main LSP Configuration
  'neovim/nvim-lspconfig',
  dependencies = {
    -- Automatically install LSPs and related tools to stdpath for Neovim
    { 'williamboman/mason.nvim', config = true }, -- NOTE: Must be loaded before dependants
    'williamboman/mason-lspconfig.nvim',
    'WhoIsSethDaniel/mason-tool-installer.nvim',

    -- Useful status updates for LSP.
    { 'j-hui/fidget.nvim', opts = {} },

    -- Allows extra capabilities provided by nvim-cmp
    'hrsh7th/cmp-nvim-lsp',
  },
  config = function()
    --  This function gets run when an LSP attaches to a particular buffer.
    vim.api.nvim_create_autocmd('LspAttach', {
      group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
      callback = function(event)
        local map = function(keys, func, desc, mode)
          mode = mode or 'n'
          vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
        end

        map('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
        map('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
        map('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
        map('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')
        map('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
        map('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')
        map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
        map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction', { 'n', 'x' })
        map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

        local client = vim.lsp.get_client_by_id(event.data.client_id)

        -- Highlight references on CursorHold
        if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
          local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
          vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
            buffer = event.buf,
            group = highlight_augroup,
            callback = vim.lsp.buf.document_highlight,
          })

          vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
            buffer = event.buf,
            group = highlight_augroup,
            callback = vim.lsp.buf.clear_references,
          })

          vim.api.nvim_create_autocmd('LspDetach', {
            group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
            callback = function(event2)
              vim.lsp.buf.clear_references()
              vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
            end,
          })
        end

        -- Toggle Inlay Hints
        if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
          map('<leader>th', function()
            -- Toggle ONLY for the current buffer
            local is_enabled = vim.lsp.inlay_hint.is_enabled { bufnr = event.buf }
            vim.lsp.inlay_hint.enable(not is_enabled, { bufnr = event.buf })
          end, '[T]oggle Inlay [H]ints')
        end
      end,
    })

    -- Create capabilities (broadcast to servers)
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())

    -- =========================================================================
    -- 1. MASON MANAGED SERVERS (Auto-Installed)
    -- =========================================================================
    local servers = {
      ts_ls = {},
      tinymist = {},
      ruff = {},
      pylsp = {
        settings = {
          pylsp = {
            plugins = {
              flake8 = { enabled = true, maxLineLength = 88 },
              pylsp_mypy = { enabled = true, dmypy = true },
              pylsp_black = { enabled = true },
              pylsp_isort = { enabled = true, profile = 'black' },
              pyflakes = { enabled = false },
              pycodestyle = { enabled = false },
              pylint = { enabled = false },
              mccabe = { enabled = false },
              pydocstyle = { enabled = false },
            },
          },
        },
      },
      html = { filetypes = { 'html', 'twig', 'hbs' } },
      cssls = {},
      sqlls = {},
      terraformls = {},
      jsonls = {},
      clangd = {
        filetypes = { 'c', 'cpp', 'h', 'hpp' },
        cmd = { 'clangd', '--fallback-style=llvm' },
        init_options = { compilationDatabasePath = '.' },
        settings = { formatting = { style = 'file' } },
      },
      lua_ls = {
        settings = {
          Lua = {
            completion = { callSnippet = 'Replace' },
            runtime = { version = 'LuaJIT' },
            workspace = {
              checkThirdParty = false,
              library = {
                '${3rd}/luv/library',
                unpack(vim.api.nvim_get_runtime_file('', true)),
              },
            },
            diagnostics = { globals = { 'vim' }, disable = { 'missing-fields' } },
            format = { enable = false },
          },
        },
      },
    }

    -- =========================================================================
    -- 2. MASON SETUP (Install Tools)
    -- =========================================================================
    require('mason').setup()

    -- Gather all server names from the table above
    local ensure_installed = vim.tbl_keys(servers or {})
    require('mason-tool-installer').setup { ensure_installed = ensure_installed }

    -- Setup handlers for Mason-managed LSPs
    require('mason-lspconfig').setup {
      handlers = {
        function(server_name)
          -- rust-analyzer is provided by rustaceanvim (plugins/rustaceanvim.lua);
          -- skip it here so we don't get duplicate clients/diagnostics.
          -- NOTE: mason-lspconfig uses lspconfig's underscore name: rust_analyzer.
          if server_name == 'rust_analyzer' then
            return
          end
          local server = servers[server_name] or {}
          server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})

          -- Fix for clangd offset encoding (sometimes needed for ccls/clangd mix)
          -- server.capabilities.offsetEncoding = { 'utf-32' }

          require('lspconfig')[server_name].setup(server)
        end,
      },
    }

    -- =========================================================================
    -- 3. MANUAL SERVER SETUP (Not in Mason)
    -- =========================================================================
    -- We require lspconfig here specifically for manual setup
    -- local lspconfig = vim.lsp.config
    --
    -- CCLS
    --   lspconfig.ccls.setup {
    --     capabilities = capabilities,
    --     init_options = { compilationDatabasePath = '.', documentFormatting = true },
    --     on_attach = function(client, bufnr)
    --       if client.server_capabilities.documentFormattingProvider then
    --         vim.api.nvim_create_autocmd('BufWritePre', {
    --           group = vim.api.nvim_create_augroup('LspFormatting', { clear = true }),
    --           buffer = bufnr,
    --           callback = function()
    --             vim.lsp.buf.format { async = false }
    --           end,
    --         })
    --       end
    --     end,
    --   }
    --
    --   -- DartLS
    --   lspconfig.dartls.setup {
    --     capabilities = capabilities,
    --     settings = {
    --       dart = {
    --         analyzerExcludedFolders = {
    --           vim.fn.expand '$HOME/development/flutter/',
    --         },
    --       },
    --     },
    --   }
  end,
}
