return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  event = "VeryLazy",
  config = function()
    -- xcodebuild.nvim exposes status via vim.g.xcodebuild_* globals.
    -- See :help xcodebuild.lualine.
    local function xcb_device()
      local platform = vim.g.xcodebuild_platform
      local name = vim.g.xcodebuild_device_name
      if not platform or not name then return "" end
      if platform == "macOS" then return " macOS" end
      local os = vim.g.xcodebuild_os
      if os then return " " .. name .. " (" .. os .. ")" end
      return " " .. name
    end

    local function xcb_scheme()
      local s = vim.g.xcodebuild_scheme
      if not s or s == "" then return "" end
      return " " .. s
    end

    local function xcb_test_plan()
      local t = vim.g.xcodebuild_test_plan
      if not t or t == "" then return "" end
      return "󰙨 " .. t
    end

    local function xcb_status()
      local st = vim.g.xcodebuild_last_status
      if not st or st == "" then return "" end
      return " " .. st
    end

    require("lualine").setup({
      options = { theme = "auto", globalstatus = true },
      sections = {
        lualine_a = { "mode" },
        lualine_b = { "filename" },
        --         lualine_b = { "branch", }, -- "diff", "diagnostics" },
        lualine_x = {
          xcb_status,
          xcb_test_plan,
          xcb_scheme,
          xcb_device,
          "filetype",
        },
        -- lualine_y = { "progress" },
        lualine_z = { "location" },
      },
    })
  end,
}
