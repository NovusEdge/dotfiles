-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(

function(use)
  -- Packer can manage itself
	use 'wbthomason/packer.nvim'

	use {
	  'nvim-telescope/telescope.nvim', tag = '0.1.2',
	  requires = { {'nvim-lua/plenary.nvim'} }
	}
	-- Treesitter!
	use ('nvim-treesitter/nvim-treesitter', {run = ':TSUpdadte'})
	use ('nvim-treesitter/playground')

	use ('nvim-lua/plenary.nvim')
	-- use ('ThePrimeagen/harpoon') -- Gonna try this sometime >.>

	-- The beloved NerdTree
	use ('scrooloose/nerdtree')
	-----------------------------------------------------------------------
	-- LSP
	use {
	  'VonHeikemen/lsp-zero.nvim',
	  branch = 'v2.x',
	  requires = {
	    -- LSP Support
	    {'neovim/nvim-lspconfig'},             -- Required
	    {                                      -- Optional
	      'williamboman/mason.nvim',
	      run = function()
		pcall(vim.cmd, 'MasonUpdate')
	      end,
	    },
	    {'williamboman/mason-lspconfig.nvim'}, -- Optional

	    -- Autocompletion
	    {'hrsh7th/nvim-cmp'},     -- Required
	    {'hrsh7th/cmp-nvim-lsp'}, -- Required
	    {'L3MON4D3/LuaSnip'},     -- Required
	  }
	}

    -- Nim syntax for treesitter:
    use 'zah/nim.vim'

	-----------------------------------------------------------------------
	-- Themeing and Colors
	use ({
		'EdenEast/nightfox.nvim',
		as = 'nightfox',
		config = function()
			vim.cmd("colorscheme nightfox")
		end
	})

	-- Airline themes
	use ('sonph/onehalf')
	use ('vim-airline/vim-airline')
	use ({
		'vim-airline/vim-airline-themes',
		as = 'themes',
		config = function()
			vim.g.airline_theme='deus'
			vim.g['airline#extensions#tabline#enabled'] = 1
		end
	})

end)
