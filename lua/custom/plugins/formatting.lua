return {
  'stevearc/conform.nvim',
  event = { 'BufWritePre' },
  opts = {
    format_on_save = function(bufnr)
      local disable_filetypes = { c = true, cpp = true }
      local lsp_format_opt = disable_filetypes[vim.bo[bufnr].filetype] and 'never' or 'fallback'
      return {
        timeout_ms = 500,
        lsp_format = lsp_format_opt,
      }
    end,
    formatters_by_ft = {
      javascript = { 'prettier' },
      javascriptreact = { 'prettier' },
      typescript = { 'prettier' },
      typescriptreact = { 'prettier' },
      json = { 'prettier' },
      html = { 'prettier' },
      css = { 'prettier' },
      markdown = { 'prettier' },
    },
  },
}
