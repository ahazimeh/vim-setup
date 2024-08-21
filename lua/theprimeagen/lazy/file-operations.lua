-- File: lua/plugins/lsp-file-operations.lua

return {
  "antosha417/nvim-lsp-file-operations",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "kyazdani42/nvim-tree.lua",
    "neovim/nvim-lspconfig",
  },
  config = function()
    local lsp_file_operations = require("lsp-file-operations")
    local lspconfig = require("lspconfig")
    local plenary_job = require("plenary.job")

    lsp_file_operations.setup({
      file_manager = "nvim-tree"
    })

    -- Function to restart TS server and refresh workspace
    local function restart_ts_server_and_refresh()
      local clients = vim.lsp.get_active_clients()
      for _, client in ipairs(clients) do
        if client.name == "tsserver" then
          vim.lsp.stop_client(client.id)
          vim.defer_fn(function()
            lspconfig.tsserver.setup({})
            vim.schedule(function()
              vim.cmd("LspStart tsserver")
              vim.lsp.buf.workspace_symbol("")
              print("TypeScript server restarted and workspace refreshed")
            end)
          end, 1000)
          return
        end
      end
      print("TypeScript server not found or not running")
    end

    -- Function to sync Neovim with git changes
    local function sync_with_git()
      plenary_job:new({
        command = "git",
        args = { "status", "--porcelain" },
        on_exit = function(j, return_val)
          if return_val == 0 then
            local result = j:result()
            if #result > 0 then
              print("Uncommitted changes detected. Please commit or stash changes before syncing.")
            else
              vim.schedule(function()
                vim.cmd("bufdo e!")
                vim.cmd("NvimTreeRefresh")
                restart_ts_server_and_refresh()
                print("Synced with git changes and refreshed Neovim state")
              end)
            end
          else
            print("Error checking git status")
          end
        end,
      }):start()
    end

    -- Setup for JavaScript/TypeScript
    lspconfig.tsserver.setup({
      -- Your tsserver configuration here
    })

    -- Commands to restart TS server and sync with git
    vim.api.nvim_create_user_command("RestartTSServer", restart_ts_server_and_refresh, {})
    vim.api.nvim_create_user_command("SyncWithGit", sync_with_git, {})

    -- Optional: Keybindings
    vim.keymap.set("n", "<leader>tr", restart_ts_server_and_refresh, { noremap = true, silent = true, desc = "Restart TS Server and Refresh" })
    vim.keymap.set("n", "<leader>gs", sync_with_git, { noremap = true, silent = true, desc = "Sync with Git" })
  end
}
