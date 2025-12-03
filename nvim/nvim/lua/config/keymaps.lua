-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Toggle autosave with <leader><F5>
vim.keymap.set("n", "<leader><F5>", function()
  local ok, autosave = pcall(require, "auto-save")
  if not ok then
    print("Auto-save plugin not loaded yet")
    return
  end

  autosave.toggle()
  local status = autosave.is_enabled() and "ON" or "OFF"
  local icon = status == "ON" and "✓" or "✗"
  print(icon .. " Autosave: " .. status)
end, { desc = "Toggle Autosave" })

-- Toggle LSP diagnostics
vim.keymap.set("n", "<leader>ud", function()
  vim.g.diagnostics_enabled = not vim.g.diagnostics_enabled
  local status = vim.g.diagnostics_enabled and "ON" or "OFF"
  local icon = vim.g.diagnostics_enabled and "✓" or "✗"

  -- Update diagnostics configuration
  vim.diagnostic.config({
    virtual_text = vim.g.diagnostics_enabled and {
      spacing = 4,
      prefix = "●",
    } or false,
    signs = vim.g.diagnostics_enabled,
    underline = vim.g.diagnostics_enabled,
    float = vim.g.diagnostics_enabled and {
      border = "rounded",
    } or false,
  })

  print(icon .. " Diagnostics: " .. status)
end, { desc = "Toggle LSP Diagnostics" })

-- Toggle LSP inlay hints
vim.keymap.set("n", "<leader>uh", function()
  vim.g.inlay_hints_enabled = not vim.g.inlay_hints_enabled
  local status = vim.g.inlay_hints_enabled and "ON" or "OFF"
  local icon = vim.g.inlay_hints_enabled and "✓" or "✗"

  -- Toggle inlay hints for all active LSP clients
  local clients = vim.lsp.get_active_clients()
  for _, client in ipairs(clients) do
    if client.server_capabilities.inlayHintProvider then
      vim.lsp.inlay_hint.enable(vim.g.inlay_hints_enabled, { bufnr = vim.api.nvim_get_current_buf() })
    end
  end

  print(icon .. " Inlay Hints: " .. status)
end, { desc = "Toggle LSP Inlay Hints" })

-- Undo tree navigation
vim.keymap.set("n", "<leader>u", "<cmd>UndotreeToggle<cr>", { desc = "Toggle Undo Tree" })

-- Toggle completion
vim.keymap.set("n", "<leader>uc", function()
  vim.g.completion_enabled = not vim.g.completion_enabled
  local status = vim.g.completion_enabled and "ON" or "OFF"
  local icon = vim.g.completion_enabled and "✓" or "✗"
  
  -- Update cmp enabled state for all buffers
  local ok, cmp = pcall(require, "cmp")
  if ok then
    for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
      if vim.api.nvim_buf_is_loaded(bufnr) then
        cmp.setup.buffer({
          buffer = bufnr,
          enabled = vim.g.completion_enabled,
        })
      end
    end
  end
  
  print(icon .. " Completion: " .. status)
end, { desc = "Toggle Completion" })

-- Run logic for file
vim.keymap.set("n", "<leader>r", function()
  local ok, run = pcall(require, "config.run")
  if not ok then
    print("config.run module not found")
    return
  end
  run.run_current_file()
end, { desc = "Run file" })

-- Better line navigation - move by visual lines
vim.keymap.set({ "n", "v" }, "j", "gj", { desc = "Down (visual line)" })
vim.keymap.set({ "n", "v" }, "k", "gk", { desc = "Up (visual line)" })

-- Quick jump to start/end of line
vim.keymap.set({ "n", "v" }, "H", "^", { desc = "Start of line" })
vim.keymap.set({ "n", "v" }, "L", "$", { desc = "End of line" })

-- Better indenting - keep selection
vim.keymap.set("v", "<", "<gv", { desc = "Indent left" })
vim.keymap.set("v", ">", ">gv", { desc = "Indent right" })

-- Move lines up/down with Alt+j/k
vim.keymap.set("n", "<A-j>", "<cmd>m .+1<cr>==", { desc = "Move line down" })
vim.keymap.set("n", "<A-k>", "<cmd>m .-2<cr>==", { desc = "Move line up" })
vim.keymap.set("i", "<A-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move line down" })
vim.keymap.set("i", "<A-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move line up" })
vim.keymap.set("v", "<A-j>", ":m '>+1<cr>gv=gv", { desc = "Move lines down" })
vim.keymap.set("v", "<A-k>", ":m '<-2<cr>gv=gv", { desc = "Move lines up" })

-- Quick duplicate line/selection
vim.keymap.set("n", "<leader>d", "yyp", { desc = "Duplicate line" })
vim.keymap.set("v", "<leader>d", "y`>p", { desc = "Duplicate selection" })

-- Quick delete line without yanking
vim.keymap.set("n", "<leader>x", '"_dd', { desc = "Delete line (no yank)" })
vim.keymap.set("v", "<leader>x", '"_d', { desc = "Delete selection (no yank)" })

-- Clear search highlighting quickly
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<cr>", { desc = "Clear search highlight" })

-- Better paste - don't lose what you're pasting
vim.keymap.set("v", "p", '"_dP', { desc = "Paste without yank" })

-- Quick buffer switching (in addition to [b and ]b)
vim.keymap.set("n", "<leader><Tab>", "<cmd>bnext<cr>", { desc = "Next buffer" })
vim.keymap.set("n", "<leader><S-Tab>", "<cmd>bprevious<cr>", { desc = "Previous buffer" })

-- Join lines without moving cursor
vim.keymap.set("n", "J", "mzJ`z", { desc = "Join lines" })

-- Keep cursor centered when searching
vim.keymap.set("n", "n", "nzzzv", { desc = "Next search result" })
vim.keymap.set("n", "N", "Nzzzv", { desc = "Previous search result" })
