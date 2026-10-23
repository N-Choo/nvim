return {
  'mrcjkb/rustaceanvim',
  version = '^9',
  lazy = false,
  init = function()
    vim.g.rustaceanvim = {
      server = {
        settings = {
          ['rust-analyzer'] = {
            -- Analyze with --all-features so #[cfg(feature = "...")] code (harness / live / grpc)
            -- is active for go-to-def/completions.
            cargo = { allFeatures = true },
          },
        },
      },
    }
  end,
}
