-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

-- Disable inlay hints on LSP attach
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("DisableInlayHintsOnAttach", { clear = true }),
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client and client.server_capabilities.inlayHintProvider then
      vim.lsp.inlay_hint.enable(false, { bufnr = args.buf })
    end
  end,
})

-- Performance: Disable some features for large files
vim.api.nvim_create_autocmd("BufReadPre", {
  group = vim.api.nvim_create_augroup("DisableFeaturesForLargeFiles", { clear = true }),
  pattern = "*",
  callback = function()
    local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(0))
    if ok and stats and stats.size > 100000 then -- 100KB
      vim.cmd("syntax off")
      vim.opt_local.foldmethod = "manual"
      vim.opt_local.undolevels = 1000 -- Reduce but don't disable undo for large files
      print("Large file detected, some features disabled")
    end
  end,
})

-- Setup abbreviations and typo corrections on startup
vim.api.nvim_create_autocmd("VimEnter", {
  group = vim.api.nvim_create_augroup("SetupAbbreviations", { clear = true }),
  callback = function()
    -- Common typos
    vim.cmd("iabbrev teh the")
    vim.cmd("iabbrev hte the")
    vim.cmd("iabbrev adn and")
    vim.cmd("iabbrev waht what")
    vim.cmd("iabbrev tehn then")
    vim.cmd("iabbrev functino function")
    vim.cmd("iabbrev funciton function")
    vim.cmd("iabbrev retrun return")
    vim.cmd("iabbrev reutrn return")
    vim.cmd("iabbrev cosnt const")
    vim.cmd("iabbrev cosole console")
    
    -- Command mode typos
    vim.cmd("cnoreabbrev W w")
    vim.cmd("cnoreabbrev Q q")
    vim.cmd("cnoreabbrev Wq wq")
    vim.cmd("cnoreabbrev WQ wq")
    vim.cmd("cnoreabbrev Qa qa")
    vim.cmd("cnoreabbrev QA qa")
    vim.cmd("cnoreabbrev Wa wa")
    vim.cmd("cnoreabbrev WA wa")
    
    -- Quick shortcuts for common patterns
    vim.cmd("iabbrev @@ " .. vim.fn.expand("$USER") .. "@" .. vim.fn.hostname())
    vim.cmd("iabbrev ccopy Copyright " .. os.date("%Y") .. " " .. vim.fn.expand("$USER"))
  end,
})

