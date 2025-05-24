function pkg_add(repo_owner, repo_name)
	local site_path = vim.fn.stdpath("data") .. "/site"
	local pkg_path = site_path .. "/pack/deps/start/" .. repo_name
	if not vim.loop.fs_stat(pkg_path) then
		vim.cmd(string.format(
			'echo "Installing %s by %s" | redraw', repo_name, repo_owner
		))
		local clone_cmd = {
			'git', 'clone', '--filter=blob:none',
			'https://github.com/' .. repo_owner .. '/' .. repo_name,
			pkg_path
		}
		vim.fn.system(clone_cmd)
		vim.cmd(string.format("packadd %s | helptags ALL", repo_name))
		vim.cmd(string.format(
			'echo "Installing %s by %s" | redraw', repo_name, repo_owner
		))
	end
end

-- Catppuccin colorscheme
pkg_add("catppuccin", "nvim")
vim.cmd.colorscheme("catppuccin")

-- Catppuccin colorscheme
pkg_add("nvim-treesitter", "nvim-treesitter")
require("nvim-treesitter.configs").setup({
	auto_install = true,
	highlight = { enable = true },
})

-- Autopair
pkg_add("altermo", "ultimate-autopair.nvim")
pkg_add("RRethy", "nvim-treesitter-endwise")
require("ultimate-autopair").setup({
	cr = { map = "<Plug>ultimate-autopair-CR" }
})

-- Lsp Signature
pkg_add("ray-x", "lsp_signature.nvim")
require("lsp_signature").setup({ hint_prefix = "  " })

-- Return key config
local core=require('ultimate-autopair.core')
vim.keymap.set('i','<CR>',function()
	local key = core.run_run(vim.api.nvim_replace_termcodes('<plug>ultimate-autopair-CR',true,true,true))
	if key == vim.api.nvim_replace_termcodes('<plug>ultimate-autopair-CR',true,true,true) then
		if vim.fn.pumvisible() == 1 then
			vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<C-y>',true,true,true), 'n', true)
		else
			vim.api.nvim_feedkeys('\r','n', true)
		end
	else
		vim.api.nvim_feedkeys(key,'n',false)
    	end
end)

-- Completion options
vim.o.completeopt = vim.o.completeopt .. ",noselect,menuone"
vim.keymap.set('i', '<Tab>', function ()
	return vim.fn.pumvisible() == 1 and '<C-n>' or '<Tab>'
end, {expr = true})
vim.keymap.set('i', '<S-Tab>', function ()
	return vim.fn.pumvisible() == 1 and '<C-p>' or '<S-Tab>'
end, {expr = true})

-- Lsp config

pkg_add("neovim", "nvim-lspconfig")
-- vim.lsp.enable("clangd")
vim.api.nvim_create_autocmd('LspAttach', {
	callback = function(ev)
		local client = vim.lsp.get_client_by_id(ev.data.client_id)
		if client:supports_method('textDocument/completion') then
			local chars = {}
			for i = 32, 126 do
				table.insert(chars, string.char(i))
			end
			client.server_capabilities.completionProvider.triggerCharacters = chars
			vim.lsp.completion.enable(true, client.id, ev.buf, {autotrigger = true})
		end
	end,
})

-- Diagnostic
vim.diagnostic.config({
	virtual_text = true,
	underline = true,
	virtual_line = true,
})

-- Lualine
pkg_add("nvim-lualine", "lualine.nvim")
require("lualine").setup({})

-- Some configs
vim.wo.number = true
vim.wo.relativenumber = true
vim.o.guifont = "Sarasa Mono K Nerd Font"
vim.o.winborder = "rounded"
