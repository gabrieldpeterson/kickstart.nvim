return {
  'akinsho/toggleterm.nvim',
  version = '*',
  opts = {
    size = 10,
    direction = 'horizontal',
    start_in_insert = true,
    persist_size = false,
    shade_terminals = true,
  },
  config = function(_, opts)
    require('toggleterm').setup(opts)

    -- Custom keymap
    vim.keymap.set('n', '<leader>tt', function()
      require('toggleterm').toggle()
    end, { desc = 'Toggle Terminal' })
  end,
}
