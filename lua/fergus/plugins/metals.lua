return {
  "scalameta/nvim-metals",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  ft = { "scala", "sbt", "java" },
  config = function()
    -- JDK 17+ restricts access to these packages
    -- so export them so metals has access for code completion
    -- Use JDK_JAVA_OPTIONS instead of JAVA_TOOL_OPTIONS to avoid
    -- the "Picked up" stderr message that corrupts Bloop's file URIs
    vim.env.JDK_JAVA_OPTIONS = table.concat({
      "-Xmx4G",
      "--add-exports=jdk.compiler/com.sun.tools.javac.api=ALL-UNNAMED",
      "--add-exports=jdk.compiler/com.sun.tools.javac.code=ALL-UNNAMED",
      "--add-exports=jdk.compiler/com.sun.tools.javac.file=ALL-UNNAMED",
      "--add-exports=jdk.compiler/com.sun.tools.javac.model=ALL-UNNAMED",
      "--add-exports=jdk.compiler/com.sun.tools.javac.parser=ALL-UNNAMED",
      "--add-exports=jdk.compiler/com.sun.tools.javac.tree=ALL-UNNAMED",
      "--add-exports=jdk.compiler/com.sun.tools.javac.util=ALL-UNNAMED",
    }, " ")

    vim.env.BLOOP_JAVA_HOME = "/Users/fergusjohnson/.sdkman/candidates/java/25-tem"

    local metals_config = require("metals").bare_config()
    metals_config.capabilities = require("blink.cmp").get_lsp_capabilities()

    metals_config.settings = {
      showImplicitArguments = true,
      excludedPackages = { "akka.actor.typed.javadsl", "com.github.swagger.akka.javadsl" },
      testUserInterface = "Code Lenses",
      serverVersion = "2.0.0-M8",
    }

    -- You can remove the 'init_options' block we tried earlier
    metals_config.init_options = {
      statusBarProvider = "on",
    }

    metals_config.on_attach = function(client, bufnr)
      local metals = require("metals")

      -- Worksheet keymaps (buffer-local for Scala)
      vim.keymap.set("n", "<leader>mws", metals.hover_worksheet,
        { buffer = bufnr, desc = "Hover Worksheet" })
      vim.keymap.set("n", "<leader>mi", function() metals.toggle_setting("showImplicitArguments") end,
        { buffer = bufnr, desc = "Toggle Implicits" })
    end

    local nvim_metals_group = vim.api.nvim_create_augroup("nvim-metals", { clear = true })
    vim.api.nvim_create_autocmd("FileType", {
      pattern = { "scala", "sbt", "java" },
      callback = function()
        require("metals").initialize_or_attach(metals_config)
      end,
      group = nvim_metals_group,
    })
  end,
}
