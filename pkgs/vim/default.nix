{ vim_configurable, vimPlugins, ... }: vim_configurable.customize {
  name = "vim";
  vimrcConfig.packages.myVim.start = with vimPlugins; [ 
    fugitive
    i3config-vim
    jq-vim
    onedark-vim
    polyglot
    vim-automkdir
    vim-vinegar
    vim-crates
    vim-go
    vim-hcl
    vim-nix
    vim-scriptease
    vim-sensible
    vim-signify
    vim-startify
    vim-surround
    vim-toml
    vim-which-key
  ];
  vimrcConfig.customRC = ''
    colorscheme onedark

    " Put leader key under the thumb
    nnoremap <Space> <NOP>
    let mapleader = "\<Space>"

    " General configuration
    set path+=** " recursively add contents of current directory to path
    set list " show invisible characters such as tabs and trailing spaces
    set number relativenumber " show relative line numbers except for current line
    set ignorecase smartcase " ignore case unless search patterns contains capitals
    set showcmd " show commands as they're being typed
    set hidden " allow switching buffers without saving
    set hlsearch " search highlighting on
    set nobackup noswap

    " Easier access to frequent commands
    nnoremap <leader><leader> :Buffers<Return>
    nnoremap <leader>bd :bd<CR>
    nnoremap <leader>g :Git<CR>
    nnoremap <leader>q :q<CR>
    nnoremap <leader>s :w<CR>
    nnoremap <leader>w :w<CR>
    nnoremap <leader>x :x<CR>
    nnoremap <leader>f :Files<Return>
    nnoremap <leader>r :Rename <c-r>=expand('%')<CR>

    " Line wrapping
    set mouse=a "enable all mouse support.
    set wrap " enable soft-wrapping
    set linebreak " don't soft-wrap mid-word
    set breakindent " continue indentation of soft-wrapped line
    set showbreak=\\\  " prefix soft-wrapped lines with a backslash
    set textwidth=80 " column to hard-wrap at (with gq for example)
    set formatoptions-=tc " don't automatically hard-wrap text or comments

    " Use tabs for indentation and spaces for alignment.
    " This ensures everything will line up independent of tab size.
    " - https://suckless.org/coding_style
    " - https://vim.fandom.com/wiki/VimTip1626
    set noexpandtab copyindent preserveindent softtabstop=0 shiftwidth=2 tabstop=2

    " Spellchecking
    " Vim offers suggestions! See `:help z=` and `:help i^xs`...
    set nospell " off by default
    set spelllang=en_us
    nnoremap <leader>rs 1z=
  '';
}