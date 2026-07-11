local function map(tbl, f)
  local t = {}
  for k, v in pairs(tbl) do
    t[k] = f(v)
  end
  return t
end

local testGlobPatterns = {
  '*.test.[tj]s',
  '*.test.[tj]sx',
  '*Test*.scala',
  '*.spec.[tj]s'
}

local confGlobPatterns = {
  '*lock.json',
  '*.package.json',
  '*.conf',
  '*config.[tj]s'
}

local antiTestPatterns = map(testGlobPatterns, function(item)
  return '!' .. item
end)

local antiConfPatterns = map(confGlobPatterns, function(item)
  return '!' .. item
end)

return {
  "nvim-telescope/telescope.nvim",
  tag = "0.1.5",
  dependencies = {
    "nvim-lua/plenary.nvim"
  },
  config = function()
    local telescope = require('telescope')
    local builtin = require('telescope.builtin')
    local actions = require('telescope.actions')

    telescope.setup({
      defaults = {
        path_display = { "smart" },
        mappings = {
          i = {
            -- SCROLLING IN PREVIEW
            ["<C-k>"] = actions.preview_scrolling_up,
            ["<C-j>"] = actions.preview_scrolling_down,
          },
          n = {
            ["<C-k>"] = actions.preview_scrolling_up,
            ["<C-j>"] = actions.preview_scrolling_down,
          }
        }
      }
    })

    local hl = vim.api.nvim_set_hl
    hl(0, "TelescopeNormal", { bg = "none" })
    hl(0, "TelescopeBorder", { bg = "none" })
    hl(0, "TelescopePreviewNormal", { bg = "none" })
    hl(0, "TelescopePreviewBorder", { bg = "none" })
    hl(0, "TelescopeResultsNormal", { bg = "none" })
    hl(0, "TelescopeResultsBorder", { bg = "none" })
    hl(0, "TelescopePromptNormal", { bg = "none" })
    hl(0, "TelescopePromptBorder", { bg = "none" })

    -- We wrap the builtin call in a function so it doesn't run on startup
    vim.keymap.set('n', '<leader>pf', function()
      builtin.find_files({
        -- find_command = { 'rg', '--files', "-i" },
        require('telescope.themes').get_dropdown({
          --         previewer = false,
        })
      }
      )
    end, {})

    vim.keymap.set('n', '<leader>ps', function()
      builtin.live_grep(require('telescope.themes').get_ivy({
        -- use 2 extends cuz dont want to mutate either table
        glob_pattern = vim.list_extend(vim.list_extend({}, antiConfPatterns), antiTestPatterns),
      }))
    end, {})

    vim.keymap.set('n', '<C-p>', builtin.git_files, {})
    vim.keymap.set('n', '<leader>pF', builtin.treesitter, {})

    -- Grep word under cursor
    vim.keymap.set('n', '<leader>pws', function()
      local word = vim.fn.expand("<cword>")
      builtin.grep_string(require('telescope.themes').get_ivy({
        search = word
      }))
    end)

    -- Grep WORD (including punctuation) under cursor
    vim.keymap.set('n', '<leader>pWs', function()
      local word = vim.fn.expand("<cWORD>")
      builtin.grep_string(require('telescope.themes').get_ivy({
        search = word
      }))
    end)

    vim.keymap.set('n', '<leader>vh', builtin.help_tags, {})

    -- SQL file search
    vim.keymap.set('n', '<leader>pQ', function()
      builtin.find_files({
        -- donesn't support glob pattern
        find_command = { 'rg', '--files', '--glob', '*.sql' },
      })
    end, { desc = "Find SQL files" })

    -- Grep within SQL files
    vim.keymap.set('n', '<leader>pqs', function()
      builtin.live_grep(require('telescope.themes').get_ivy({
        glob_pattern = '*.sql',
      }))
    end, { desc = "Grep in SQL files" })

    -- grep conf
    vim.keymap.set('n', '<leader>pcs', function()
      builtin.live_grep(require('telescope.themes').get_ivy({
        glob_pattern = confGlobPatterns
      }))
    end, { desc = "Grep in conf" })

    -- grep tests
    vim.keymap.set('n', '<leader>pts', function()
      builtin.live_grep(require('telescope.themes').get_ivy({
        glob_pattern = testGlobPatterns
      }))
    end)

    -- search for FERGUS: - comments
    vim.keymap.set('n', '<leader>pm', function()
      builtin.grep_string(require('telescope.themes').get_ivy({
        search = 'FERGUS: -'
      }))
    end)

    -- search for actor message handlers
    vim.keymap.set('n', '<leader>pwp', function()
      local word = vim.fn.expand("<cword>")
      builtin.grep_string(require('telescope.themes').get_ivy({
        search = 'msg: ' .. word
      }))
    end)
  end
}
