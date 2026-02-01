-- ~/.config/nvim/init.lua

-- Omogoči kopiranje v Windows odložišče (clipboard)
vim.opt.clipboard = "unnamedplus"

-- Nastavitve specifične za VS Code
if vim.g.vscode then
    -- Tukaj lahko dodaš bližnjice, ki delujejo samo v VS Code
    -- npr. 'jk' za izhod iz Insert moda
    vim.keymap.set('i', 'jk', '<Esc>', { silent = true })
else
    -- Nastavitve za navaden Neovim v terminalu
    vim.opt.number = true
    vim.opt.relativenumber = true
end
