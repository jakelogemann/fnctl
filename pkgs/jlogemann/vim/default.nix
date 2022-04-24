{ unstable, ... }:
unstable.vim_configurable.customize {
  name = "vim";
  vimrcConfig.customRC = ''
" Jake's Vim Config
let $VIMRC=expand('~/.config/vim/init.vim')
let $VIM_DIR=expand('~/.config/vim')

"" Functions {{{1
function! TrimWhitespace() "{{{
  :%s/\s\+$//e
endfunction "}}}
function! MenuExplOpen() "{{{
  if @% == "" | 20vsp .
  else | exe "20vsp " . s:FnameEscape(expand("%:p:h"))
  endif
endfunction "}}}
function! FoldText() "{{{
    " for now, just don't try if version isn't 7 or higher
    if v:version < 701 | return foldtext() | endif
    " clear fold from fillchars to set it up the way we want later
    let &l:fillchars = substitute(&l:fillchars,',\?fold:.',"",'gi')
    let l:numwidth = (v:version < 701 ? 8 : &numberwidth)
    if &fdm=='diff'
      let l:linetext=""
      let l:foldtext='---------- '.(v:foldend-v:foldstart+1).' lines the same ----------'
      let l:align = winwidth(0)-&foldcolumn-(&nu ? Max(strlen(line('$'))+1, l:numwidth) : 0)
      let l:align = (l:align / 2) + (strlen(l:foldtext)/2)
      " note trailing space on next line
      setlocal fillchars+=fold:\
    elseif !exists('b:foldpat') || b:foldpat==0
      let l:foldtext = '|'.(v:foldend-v:foldstart).' lines|'
      let l:endofline = (&textwidth>0 ? &textwidth : 80)
      let l:linetext = strpart(getline(v:foldstart),0,l:endofline-strlen(l:foldtext))
      let l:linetext = substitute(l:linetext, '\{\{\{',"")
      let l:align = l:endofline-strlen(l:linetext)
      setlocal fillchars+=fold:\
    elseif b:foldpat==1
      let l:align = winwidth(0)-&foldcolumn-(&nu ? Max(strlen(line('$'))+1, l:numwidth) : 0)
      let l:foldtext = ' '.v:folddashes
      let l:linetext = substitute(getline(v:foldstart),'\s\+$',"","")
      let l:linetext .= ' ---'.(v:foldend-v:foldstart-1).' lines--- '
      let l:linetext .= substitute(getline(v:foldend),'^\s\+',"","")
      let l:linetext = strpart(l:linetext,0,l:align-strlen(l:foldtext))
      let l:align -= strlen(l:linetext)
      setlocal fillchars+=fold:\
    endif
    return printf('%s%*s', l:linetext, l:align, l:foldtext)
endfunction "}}}
function! SetupWrapping() "{{{
  set wrap wm=2 tw=79
endfunction "}}}
function! SmartClose(kind) "{{{
  if kind == 'buffer'
    if winheight(2) < 0 && tabpagewinnr(2) == 0
      confirm enew
    else
      confirm close
    endif
  elseif kind == 'tab'
    confirm tabclose
  endif
endfunction "}}}
function! IsEphemeral(buf) "{{{
  let l:is_ephemeral_ft = index([
        \ 'nerdtree',
        \ 'ale-fix-suggest', 'ale-preview', 'ale-preview-selection',
        \ 'gitcommit', 'gitrebase',
        \ 'tagbar',
        \ ], &ft)
  return l:is_ephemeral_ft
endfunction "}}}
function! SmartOpen(path) "{{{
  " not implemented, should be a 'run-or-raise'-type thing.
  tabedit expand(a:path)
endfunction "}}}
" AutoMkdir() {{{
" automatically creates a directory for current buffer
function! AutoMkdir()
  let dir = expand('%:p:h')
  if dir =~ '://' | return | endif
  if !isdirectory(dir)
    call mkdir(dir, 'p')
    echo 'Created directory: '.dir
  endif
endfunction "}}}
" RememberCursorPosition()  {{{
" saves the cursor position (usually before exit)
function! RememberCursorPosition()
  if line("'\"") > 1 && line("'\"") <= line("$")
    exe "normal! g`\""
  endif
endfunction "}}}
"--- Plug 'Raimondi/delimitMate'
"--- Plug 'liuchengxu/vim-which-key'
"--- Plug 'Shougo/vimproc.vim', {'do': g:make}
"--- Plug 'SirVer/ultisnips' | Plug 'honza/vim-snippets'
"--- Plug 'Yggdroot/indentLine'
"--- Plug 'airblade/vim-gitgutter'
"--- Plug 'dense-analysis/ale'
"--- Plug 'junegunn/fzf.vim' | Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
"--- Plug 'junegunn/vim-easy-align'
"--- Plug 'junegunn/vim-peekaboo'
"--- Plug 'majutsushi/tagbar'
"--- Plug 'mhinz/vim-startify'
"--- Plug 'scrooloose/nerdtree'
"--- Plug 'tomasiser/vim-code-dark'
"--- Plug 'tpope/vim-commentary'
"--- Plug 'tpope/vim-eunuch'
"--- Plug 'tpope/vim-fugitive' | Plug 'tpope/vim-rhubarb' " required by fugitive to :Gbrowse
"--- Plug 'tpope/vim-projectionist'
"--- Plug 'valloric/youcompleteme', { 'do': './install.py  --go-completer --ts-completer --rust-completer' }
"--- Plug 'vim-airline/vim-airline' | Plug 'vim-airline/vim-airline-themes'
"--- Plug 'vim-scripts/CSApprox'
"--- Plug 'vim-scripts/grep.vim'
"--- Plug 'vimwiki/vimwiki'
"--- Plug 'xolox/vim-session' | Plug 'xolox/vim-misc'
"---
"--- " go
"--- Plug 'fatih/vim-go', {'do': ':GoInstallBinaries'}
"--- " html/css
"--- Plug 'hail2u/vim-css3-syntax'
"--- Plug 'gko/vim-coloresque'
"--- Plug 'tpope/vim-haml', {'for':'haml'}
"--- Plug 'mattn/emmet-vim'
"--- " python
"--- Plug 'davidhalter/jedi-vim', {'for':'python'}
"--- Plug 'raimon49/requirements.txt.vim', {'for': 'requirements'}
"--- " javascript/typescript
"--- Plug 'jelera/vim-javascript-syntax', {'for':'javascript'}
"--- Plug 'leafgarland/typescript-vim', {'for':'typescript'}
"--- Plug 'HerringtonDarkholme/yats.vim', {'for':'typescript'}
"--- " rust
"--- Plug 'rust-lang/rust.vim', {'for':'rust'}
"--- Plug 'racer-rust/vim-racer', {'for':'rust'}
" Basic Setup {{{1
let mapleader=','

set timeoutlen=500 "quicker response on keybinds.
set autoread  "detect/reload changed files.
set ttyfast  "almost all TTYs are now... relatively.

set fileformats=unix,dos,mac

"" file encoding: default to utf-8.
set enc=utf-8 fenc=utf-8 fencs=utf-8 tenc=utf-8

"" Fix backspace indent
set backspace=indent,eol,start

"" Tabs. May be overridden by autocmd rules
set tabstop=2 shiftwidth=2 softtabstop=0 expandtab

"" Enable hidden buffers
set hidden

"" Searching
set hlsearch incsearch ignorecase smartcase

"" Status bar
set laststatus=2
set statusline=%F%m%r%h%w%=(%{&ff}/%Y)\ (line\ %l\/%L,\ col\ %c)\

"" Use modeline overrides
set modeline modelines=10

set wildmode=list:longest,list:full
set wildignore+=*.o,*.obj,.git,*.rbc,*.pyc,__pycache__
set wildignore+=*/tmp/*,*.so,*.swp,*.zip,*.pyc,*.db,*.sqlite

syntax on
set ruler
set number

let no_buffers_menu=1
colorscheme onedark

" force 256 colors
set t_Co=256

set scrolloff=3
set foldtext=FoldText() " Set a nicer foldtext function

" optional modernization features
if has("termguicolors")     |  set termguicolors | endif
if exists('+inccommand')    |  set inccommand=nosplit | endif
if exists('+completepopup') |  set completeopt+=popup completepopup=height:4,width:60,highlight:InfoPopup | endif
if exists('+previewpopup')  |  set previewpopup=height:10,width:60 | endif
if exists('&pumblend')      |  set pumblend=5 | endif " Pseudo-transparency for completion menu.
if exists('&winblend')      |  set winblend=5 | endif " Pseudo-transparency for floating window.
if executable('rg')         | set grepprg=rg\ --vimgrep | endif

" formatting options
set formatoptions+=1         " Don't break lines after a one-letter word
set formatoptions-=t         " Don't auto-wrap text
set formatoptions-=o         " Disable comment-continuation (normal 'o'/'O')

" Remove comment leader when joining lines
if has('patch-7.3.541') | set formatoptions+=j | endif

" determine which shell to use:
set shell=/bin/sh
if exists('$SHELL') | set shell=$SHELL | endif
" if using fish, find bash for vim to use.
if &shell =~# 'fish$' | let &shell=expand('bash') | endif

if has('multi_byte') && &encoding ==# 'utf-8'
  let &listchars = 'extends:→ ,precedes:↵,trail:·,tab:❯'
else
  let &listchars = 'tab:> ,extends:>,precedes:<,nbsp:.'
endif

" GUI Settings {{{1
if has("gui_running")
  "" Disable the blinking cursor.
  set gcr=a:blinkon0

  " requires installed nerdfont.
  set gfn=FiraCode\ Nerd\ Font\ weight=453\ 10
  " alternatively:
  " set gfn=Monospace\ 10

  set mousemodel=popup
  set guioptions=gridemt

  " Disable visualbell
  set noerrorbells visualbell t_vb=
  autocmd GUIEnter * set visualbell t_vb=



  if has("gui_mac") || has("gui_macvim") "{{{
    set guifont=Menlo:h12
    set transparency=7
  endif "}}}
endif "1}}}
" TTY Settings {{{1
if !has('gui_running')
  let g:CSApprox_loaded = 1

  " IndentLine
  let g:indentLine_enabled = 0
  let g:indentLine_concealcursor = 0
  let g:indentLine_fileTypeExclude = ['help']
  let g:indentLine_bufNameExclude = ['_.*', 'NERD_tree.*']
  let g:indentLine_char = '┆'
  let g:indentLine_faster = 1


  if $COLORTERM == 'gnome-terminal'
    set term=gnome-256color
  else
    if $TERM == 'xterm'
      set term=xterm-256color
    endif
  endif

  if &term =~ '256color' | set t_ut= | endif

  set title titleold="Terminal"
  set titlestring=%t%(\ %M%)%(\ (%{expand(\"%:~:.:h\")})%)%(\ %a%)
endif "1}}}
"" Abbreviations {{{1
cnoreabbrev W! w!
cnoreabbrev Q! q!
cnoreabbrev Qall! qall!
cnoreabbrev Wq wq
cnoreabbrev Wa wa
cnoreabbrev wQ wq
cnoreabbrev WQ wq
cnoreabbrev W w
cnoreabbrev Q q
cnoreabbrev Qall qall

"" Commands {{{1
" remove trailing whitespaces
command! TrimWhitespace :call TrimWhitespace()
command! EditConfig    :tabedit $MYVIMRC
command! ReloadConfig  :source $MYVIMRC
command! Browse        :tab terminal ranger
"" Auto-Command Groups {{{1
augroup vimrc_buffer_defaults "{{{
  autocmd!
  " Modern PCs are fast enough, do syntax highlight syncing from start unless
  " 200 lines.
  autocmd BufEnter    * :syntax sync maxlines=200
  autocmd BufWritePre * call AutoMkdir()
  autocmd BufReadPost * call RememberCursorPosition()
augroup END "}}}
augroup vimrc_rust "{{{
    autocmd!
    autocmd FileType rust nmap <buffer> gd         <Plug>(rust-def)
    autocmd FileType rust nmap <buffer> gs         <Plug>(rust-def-split)
    autocmd FileType rust nmap <buffer> gx         <Plug>(rust-def-vertical)
    autocmd FileType rust nmap <buffer> gt         <Plug>(rust-def-tab)
    autocmd FileType rust nmap <buffer> <leader>gd <Plug>(rust-doc)
    autocmd FileType rust nmap <buffer> <leader>gD <Plug>(rust-doc-tab)
augroup END "}}}
augroup vimrc_wrapping "{{{
  au!
  au BufRead,BufNewFile  *.txt    setl wrap wm=2 tw=79
augroup END "}}}
augroup vimrc_make_cmake "{{{
  autocmd!
  autocmd FileType make setlocal noexpandtab
  autocmd BufNewFile,BufRead CMakeLists.txt setlocal filetype=cmake
augroup END "}}}
augroup vimrc_edit "{{{
  autocmd!
  autocmd BufEnter     $MYVIMRC :setl foldmethod=marker foldlevel=0
  autocmd BufEnter     $MYVIMRC :setl foldopen=all foldclose=
  autocmd BufWritePre  $MYVIMRC :call TrimWhitespace()
  autocmd BufWritePost $MYVIMRC :source $MYVIMRC
augroup END "}}}
augroup vimrc_completion_preview_close "{{{
  autocmd!
  if v:version > 703 || v:version == 703 && has('patch598')
    autocmd CompleteDone * if !&previewwindow && &completeopt =~ 'preview' | silent! pclose | endif
  endif
augroup END "}}}
augroup vimrc_go "{{{
  au!
  au Filetype go command! -bang A call go#alternate#Switch(<bang>0, 'edit')
  au Filetype go command! -bang AV call go#alternate#Switch(<bang>0, 'vsplit')
  au Filetype go command! -bang AS call go#alternate#Switch(<bang>0, 'split')
  au Filetype go command! -bang AT call go#alternate#Switch(<bang>0, 'tabe')

  au FileType go nmap <Leader>dd <Plug>(go-def-vertical)
  au FileType go nmap <Leader>dv <Plug>(go-doc-vertical)
  au FileType go nmap <Leader>db <Plug>(go-doc-browser)

  au FileType go nmap <leader>r  <Plug>(go-run)
  au FileType go nmap <leader>t  <Plug>(go-test)
  au FileType go nmap <Leader>gt <Plug>(go-coverage-toggle)
  au FileType go nmap <Leader>i <Plug>(go-info)
  au FileType go nmap <silent> <Leader>l <Plug>(go-metalinter)
  au FileType go nmap <C-g> :GoDecls<cr>
  au FileType go nmap <leader>dr :GoDeclsDir<cr>
  au FileType go imap <C-g> <esc>:<C-u>GoDecls<cr>
  au FileType go imap <leader>dr <esc>:<C-u>GoDeclsDir<cr>
  au FileType go nmap <leader>rb :<C-u>call <SID>build_go_files()<CR>
augroup END "}}}

"" Mappings {{{1

" terminal emulation
nnoremap <silent> <leader>sh :terminal<CR>

" Search mappings: These will make it so that going to the next one in a
" search will center on the line it's found in.
nnoremap n nzzzv
nnoremap N Nzzzv

if exists("*fugitive#statusline")
  set statusline+=%{fugitive#statusline()}
endif

"" Tabs
nnoremap <Tab> gt
nnoremap <S-Tab> gT
nnoremap <silent> <S-t> :tabnew<CR>

"" Copy/Paste/Cut
if has('unnamedplus')
  set clipboard=unnamed,unnamedplus
endif

noremap YY "+y<CR>
noremap XX "+x<CR>

if has('macunix')
  " pbcopy for OSX copy/paste
  vmap <C-x> :!pbcopy<CR>
  vmap <C-c> :w !pbcopy<CR><CR>
endif


"" Switching windows
noremap <C-j> <C-w>j
noremap <C-k> <C-w>k
noremap <C-l> <C-w>l
noremap <C-h> <C-w>h

"" Vmap for maintain Visual Mode after shifting > and <
vmap < <gv
vmap > >gv

"" Move visual block
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv

" Leader Mappings {{{1
let g:which_key_map = {}

let g:which_key_map['e'] = [':NERDTreeToggle', 'tree']
let g:which_key_map['h'] = [':<C-u>split<CR>', 'split']
let g:which_key_map['v'] = [':<C-u>vsplit<CR>', 'vsplit']
let g:which_key_map['~'] = [':lcd %:p:h', 'cd-here']
"" Opens an edit command with the path of the currently edited file filled in
"let g:which_key_map['e'] = [':e <C-R>=expand("%:p:h") . "/"', 'edit..']
"" Opens a tab edit command with the path of the currently edited file filled
"let g:which_key_map['te'] = [':tabe <C-R>=expand("%:p:h") . "/"', 'tabedit..']
let g:which_key_map[' '] = [':noh', 'clear-search']
let g:which_key_map['p'] = ['"+gP', 'paste']

" Window Managment
let g:which_key_map['w'] = {
      \ 'name' : '+windows' ,
      \ 'w' : ['<C-W>w'     , 'other-window'],
      \ 'd' : ['<C-W>c'     , 'delete-window'],
      \ '-' : ['<C-W>s'     , 'split-window-below'],
      \ '|' : ['<C-W>v'     , 'split-window-right'],
      \ '2' : ['<C-W>v'     , 'layout-double-columns'],
      \ 'h' : ['<C-W>h'     , 'window-left'],
      \ 'j' : ['<C-W>j'     , 'window-below'],
      \ 'l' : ['<C-W>l'     , 'window-right'],
      \ 'k' : ['<C-W>k'     , 'window-up'],
      \ 'H' : ['<C-W>5<'    , 'expand-window-left'],
      \ 'J' : [':resize +5'  , 'expand-window-below'],
      \ 'L' : ['<C-W>5>'    , 'expand-window-right'],
      \ 'K' : [':resize -5'  , 'expand-window-up'],
      \ '=' : ['<C-W>='     , 'balance-window'],
      \ 's' : ['<C-W>s'     , 'split-window-below'],
      \ 'v' : ['<C-W>v'     , 'split-window-below'],
      \ '?' : ['Windows'    , 'fzf-window'],
      \ }

" Git repo management
let g:which_key_map['g'] = {
      \ 'name' : '+git',
      \ 'w' : [':Gwrite',  'write+stage'],
      \ 'c' : [':Gcommit', 'commit'],
      \ 'P' : [':Gpush',   'push'],
      \ 'p' : [':Gpull',   'pull'],
      \ 's' : [':Gstatus', 'status'],
      \ 'b' : [':Gblame',  'blame'],
      \ 'd' : [':Gvdiff',  'vdiff'],
      \ 'r' : [':Gremove', 'remove'],
      \ }

" Session management
let g:which_key_map['s'] = {
      \ 'name' : '+session',
      \ 'o' : [':OpenSession',  'open'],
      \ 's' : [':SaveSession', 'save'],
      \ 'd' : [':DeleteSession',   'delete'],
      \ 'c' : [':CloseSession',   'close'],
      \ }

"" Buffer nav
let g:which_key_map['b'] = {
      \ 'name' : '+buffer',
      \ 'n' : [':bn', 'next'],
      \ 's' : [':bp', 'prev'],
      \ 'd' : [':bd', 'delete'],
      \ 'f' : [':bfirst', 'first'],
      \ 'l' : [':blast', 'last'],
      \ 'N' : [':enew', 'new'],
      \ }

"" fuzzy finder
let g:which_key_map['f'] = {
      \ 'name' : '+find',
      \ 'f' : [':Files', 'file'],
      \ 't' : [':Tags', 'tag'],
      \ '?' : [':Helptags', 'help'],
      \ 'l' : [':Lines', 'line'],
      \ 'b' : [':Buffers', 'buffer'],
      \ 'w' : [':Windows', 'window'],
      \ 'c' : [':Commands', 'command'],
      \ 'H' : [':History', 'history'],
      \ }

call which_key#register(',', "g:which_key_map") 
nnoremap <silent> <leader> :WhichKey ','<CR>
vnoremap <silent> <leader> :WhichKeyVisual ','<CR>
"1}}}
"*****************************************************************************
"" Custom Language Configs {{{1
"*****************************************************************************
" Go {{{2
let g:go_list_type = "quickfix"
let g:go_fmt_command = "goimports"
let g:go_fmt_fail_silently = 1
let g:go_highlight_types = 1
let g:go_highlight_fields = 1
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_operators = 1
let g:go_highlight_build_constraints = 1
let g:go_highlight_structs = 1
let g:go_highlight_generate_tags = 1
let g:go_highlight_space_tab_error = 0
let g:go_highlight_array_whitespace_error = 0
let g:go_highlight_trailing_whitespace_error = 0
let g:go_highlight_extra_types = 1

" run :GoBuild or :GoTestCompile based on the go file
function! s:build_go_files()
  let l:file = expand('%')
  if l:file =~# '^\f\+_test\.go$'
    call go#test#Test(0, 1)
  elseif l:file =~# '^\f\+\.go$'
    call go#cmd#Build(0)
  endif
endfunction

autocmd BufNewFile,BufRead *.go setlocal noexpandtab tabstop=4 shiftwidth=4 softtabstop=4



" html {{{2
" for html files, 2 spaces
autocmd Filetype html setlocal ts=2 sw=2 expandtab


" javascript {{{2
let g:javascript_enable_domhtmlcss = 1

augroup vimrc_javascript "{{{
  autocmd!
  autocmd FileType javascript call s:setupWrapping()
augroup END "}}}

" python {{{2

augroup vimrc_python "{{{
  autocmd!
  autocmd FileType python setlocal expandtab shiftwidth=4 tabstop=8 colorcolumn=79
      \ formatoptions+=croq softtabstop=4
      \ cinwords=if,elif,else,for,while,try,except,finally,def,class,with
augroup END "}}}

" jedi-vim
let g:jedi#popup_on_dot = 0
let g:jedi#goto_assignments_command = "<leader>g"
let g:jedi#goto_definitions_command = "<leader>d"
let g:jedi#documentation_command = "K"
let g:jedi#usages_command = "<leader>n"
let g:jedi#rename_command = "<leader>r"
let g:jedi#show_call_signatures = "0"
let g:jedi#completions_command = "<C-Space>"
let g:jedi#smart_auto_mappings = 0

" Syntax highlight
let python_highlight_all = 1

" typescript {{{2
let g:yats_host_keyword = 1

"" Include user's local vim config {{{1
if filereadable(expand("~/.vimrc.local"))
  source ~/.vimrc.local
endif " }}}1
"" Plugin Configs {{{1
  " This is the default extra key bindings
  let g:fzf_action = {
        \ 'ctrl-t': 'tab split',
        \ 'ctrl-x': 'split',
        \ 'ctrl-v': 'vsplit' }

  " An action can be a reference to a function that processes selected lines
  function! s:build_quickfix_list(lines)
    call setqflist(map(copy(a:lines), '{ "filename": v:val }'))
    copen
    cc
  endfunction

  let g:fzf_action = {
        \ 'ctrl-q': function('s:build_quickfix_list'),
        \ 'ctrl-t': 'tab split',
        \ 'ctrl-x': 'split',
        \ 'ctrl-v': 'vsplit' }

  " Default fzf layout
  " - Popup window
  let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.6 } }

  " - down / up / left / right
  " let g:fzf_layout = { 'down': '40%' }

  " - Window using a Vim command
  " let g:fzf_layout = { 'window': 'enew' }
  " let g:fzf_layout = { 'window': '-tabnew' }
  " let g:fzf_layout = { 'window': '10new' }

  " Customize fzf colors to match your color scheme
  " - fzf#wrap translates this to a set of `--color` options
  let g:fzf_colors =
        \ { 'fg':      ['fg', 'Normal'],
        \ 'bg':      ['bg', 'Normal'],
        \ 'hl':      ['fg', 'Comment'],
        \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
        \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
        \ 'hl+':     ['fg', 'Statement'],
        \ 'info':    ['fg', 'PreProc'],
        \ 'border':  ['fg', 'Ignore'],
        \ 'prompt':  ['fg', 'Conditional'],
        \ 'pointer': ['fg', 'Exception'],
        \ 'marker':  ['fg', 'Keyword'],
        \ 'spinner': ['fg', 'Label'],
        \ 'header':  ['fg', 'Comment'] }

  " Enable per-command history
  " - History files will be stored in the specified directory
  " - When set, CTRL-N and CTRL-P will be bound to 'next-history' and
  "   'previous-history' instead of 'down' and 'up'.
  let g:fzf_history_dir = '~/.local/share/fzf-history'
  if executable('rg')
    let $FZF_DEFAULT_COMMAND = 'rg --files --hidden --follow --glob "!.git/*"'
    command! -bang -nargs=* Find call fzf#vim#grep('rg --column --line-number --no-heading --fixed-strings --ignore-case --hidden --follow --glob "!.git/*" --color "always" '.shellescape(<q-args>).'| tr -d "\017"', 1, <bang>0)
  else
    let $FZF_DEFAULT_COMMAND =  "find * -path '*/\.*' -prune -o -path 'node_modules/**' -prune -o -path 'target/**' -prune -o -path 'dist/**' -prune -o  -type f -print -o -type l -print 2> /dev/null"
  endif
  cnoremap <C-P> <C-R>=expand("%:p:h") . "/" <CR>

  silent! aunmenu Fi&nd
  an 50.350.10 Fi&nd.&Buffer 	  :Buffers<CR>
  an 50.350.20 Fi&nd.&Command 	:Commands<CR>
  an 50.350.21 Fi&nd.Command\ (&Recent) 	:History:<CR>
  an 50.350.30 Fi&nd.&File	    :Files<CR>
  an 50.350.31 Fi&nd.Fil&e\ (GIT) 	:GFiles<CR>
  an 50.350.32 Fi&nd.Fil&e\ (Modified) 	:GFiles?<CR>
  an 50.350.34 Fi&nd.Fil&e\ (Recent) 	:History<CR>
  an 50.350.40 Fi&nd.&Help 	    :Helptags<CR>
  an 50.350.50 Fi&nd.&Mapping	  :Maps<CR>
  an 50.350.60 Fi&nd.&Mark 	    :Marks<CR>
  an 50.350.70 Fi&nd.&Tags 	    :Tags<CR>
  an 50.350.80 Fi&nd.&Window 	  :Windows<CR>
  an 50.350.90 Fi&nd.Fi&leType	:Filetypes<CR>

  let g:UltiSnipsExpandTrigger="<tab>"
  let g:UltiSnipsJumpForwardTrigger="<tab>"
  let g:UltiSnipsJumpBackwardTrigger="<c-b>"
  let g:UltiSnipsEditSplit="vertical"
  let g:ale_linters = {
        \ "go": ['golint', 'go vet'],
        \ 'python': ['flake8'],
        \ }
  let g:ale_fixers = {"javascript": ['prettier', 'eslint']}
  " You should not turn this setting on if you wish to use ALE as a completion
  " source for other completion plugins, like Deoplete.
  set omnifunc=ale#completion#OmniFunc
  let g:ale_completion_autoimport = 1
  let g:ale_set_balloons = 1
  let g:ale_hover_cursor = 1
  let g:ale_completion_enabled = 1
nmap <silent> <F4> :TagbarToggle<CR>
let g:tagbar_autofocus = 1
  let g:NERDTreeNaturalSort=1
  let g:NERDTreeChDirMode=2
  let g:NERDTreeMouseMode=2
  let g:NERDTreeQuitOnOpen=3
  let g:NERDTreeShowHidden=1
  let g:NERDTreeCreatePrefix='silent keepalt keepjumps'
  let g:NERDTreeIgnore=['\.rbc$', '\~$', '\.pyc$', '\.db$', '\.sqlite$', '__pycache__']
  let g:NERDTreeSortOrder=['^__\.py$', '\/$', '*', '\.swp$', '\.bak$', '\~$']
  let g:NERDTreeShowBookmarks=1
  let g:nerdtree_tabs_focus_on_files=1
  let g:NERDTreeMapOpenInTabSilent = '<RightMouse>'
  let g:NERDTreeWinSize = 32
  nnoremap <silent> <F2> :NERDTreeFind<CR>
  nnoremap <silent> <F3> :NERDTreeToggle<CR>
  execute printf('let g:airline_theme = "%s"', g:colors_name)
  let g:airline#extensions#branch#enabled = 1
  let g:airline#extensions#ale#enabled = 1
  let g:airline#extensions#tabline#enabled = 1
  let g:airline#extensions#tagbar#enabled = 1
  let g:airline_skip_empty_sections = 1
  let g:airline#extensions#virtualenv#enabled = 1

  if !exists('g:airline_symbols')
    let g:airline_symbols = {}
  endif

  if !exists('g:airline_powerline_fonts')
    let g:airline#extensions#tabline#left_sep = ' '
    let g:airline#extensions#tabline#left_alt_sep = '|'
    let g:airline_left_sep          = ' '
    let g:airline_left_alt_sep      = '»'
    let g:airline_right_sep         = ' '
    let g:airline_right_alt_sep     = '«'
    let g:airline#extensions#branch#prefix     = '⤴' "➔, ➥, ⎇
    let g:airline#extensions#readonly#symbol   = '⊘'
    let g:airline#extensions#linecolumn#prefix = '¶'
    let g:airline#extensions#paste#symbol      = 'ρ'
    let g:airline_symbols.linenr    = '␊'
    let g:airline_symbols.branch    = '⎇'
    let g:airline_symbols.paste     = 'ρ'
    let g:airline_symbols.paste     = 'Þ'
    let g:airline_symbols.paste     = '∥'
    let g:airline_symbols.whitespace = 'Ξ'
  else
    let g:airline#extensions#tabline#left_sep = ''
    let g:airline#extensions#tabline#left_alt_sep = ''

    " powerline symbols
    let g:airline_left_sep = ''
    let g:airline_left_alt_sep = ''
    let g:airline_right_sep = ''
    let g:airline_right_alt_sep = ''
    let g:airline_symbols.branch = ''
    let g:airline_symbols.readonly = ''
    let g:airline_symbols.linenr = ''
  endif

let g:session_directory = $VIM_DIR . "/session"
let g:session_menu = 0
let g:session_autoload = "no"
let g:session_autosave = "no"
let g:session_command_aliases = 1
let Grep_Default_Options = '-IR'
let Grep_Skip_Files = '*.log *.db'
let Grep_Skip_Dirs = '.git node_modules'
" Menu Bar Items {{{1
" - see also :help menu
if has('menu')
  "" load default menu items
  "let did_install_default_menus = 1
  " source $VIMRUNTIME/menu.vim

  " remove the default menu entirely.
  silent! aunmenu *

  " File menu
  an 1.301 &File.&New.&Buffer<Tab>:enew :confirm enew<CR>
  an 1.302 &File.&New.&Tab<Tab>:tab  	 :confirm tab<CR>
  an 1.303 &File.&New.&H-Split<Tab>:sp  :confirm sp<CR>
  an 1.304 &File.&New.&V-Split<Tab>:vs  :confirm vs<CR>
  an 1.305 &File.&New.&Session          :NewSession<CR>
  an 1.320 &File.-SEP1-				               <Nop>
  an 1.321 &File.&Open.in\ Current\ Buffer   :browse confirm e<CR>
  an 1.322 &File.&Open.in\ new\ tab          :browse tabnew<CR>
  an 1.323 &File.&Open.in\ new\ split        :browse sp<CR>
  an 1.324 &File.&Open.Session               :OpenSession<CR>
  an 1.330 &File.-SEP2-				               <Nop>

  an <silent> 1.330 &File.&Close.Current\ &Buffer :call SmartClose('buffer')<CR>
  an 1.330 &File.&Close.Current\ &Window<Tab>^Wc :confirm close<CR>
  an 1.330 &File.&Close.Current\ &Tab            :confirm tabclose<CR>
  an 1.330 &File.&Close.&Other\ Windows<Tab>^Wo  :confirm only<CR>
  an 1.340 &File.-SEP3-				<Nop>
  an <silent> 1.341 &File.&Save
        \ :if expand("%") == ""<Bar>browse confirm w<Bar>
        \  else<Bar>confirm w<Bar>
        \  endif<CR>
  an 1.342 &File.Save\ &As\.\.\.    :browse confirm saveas<CR>
  an 1.600 &File.-SEP4-				      <Nop>
  an 1.620 &File.&Quit              :confirm qa<CR>

  an 20.335.10  &Edit.&Spell\ Check.&Toggle	              :set spell! spl=en<CR>
  an 20.335.130 &Edit.&Spell\ Check.&Next\ Suggestion<Tab>]s	      ]s
  an 20.335.130 &Edit.&Spell\ Check.&Previous\ Suggestion<Tab>[s	  [s
  an 20.335.140 &Edit.&Spell\ Check.Possible\ &Corrections<Tab>z=	  z=
  an 20.335.150 &Edit.&Spell\ Check.&Repeat\ Correction<Tab>:spellrepall	:spellrepall<CR>
  an 20.335.200 &Edit.&Spell\ Check.-SEP1-				        <Nop>
  an 20.335.240 &Edit.&Spell\ Check.Check\ with\ "en_gb"	:set spell  spl=en_gb<CR>
  an 20.335.260 &Edit.&Spell\ Check.Check\ with\ "en_us"	:set spell  spl=en_us<CR>

  an 20.370    &Edit.&Change\ List.&List\ Errors<Tab>:cl			:cl<CR>
  an 20.380    &Edit.&Change\ List.L&ist\ Messages<Tab>:cl!		:cl!<CR>
  an 20.390    &Edit.&Change\ List.&Next\ Error<Tab>:cn			  :cn<CR>
  an 20.400    &Edit.&Change\ List.&Previous\ Error<Tab>:cp		:cp<CR>
  an 20.410    &Edit.&Change\ List.&Older\ List<Tab>:cold			:colder<CR>
  an 20.420    &Edit.&Change\ List.N&ewer\ List<Tab>:cnew			:cnewer<CR>
  an 20.430.50 &Edit.&Change\ List.Error\ &Window.&Update<Tab>:cwin	:cwin<CR>
  an 20.430.60 &Edit.&Change\ List.Error\ &Window.&Open<Tab>:copen	:copen<CR>
  an 20.430.70 &Edit.&Change\ List.Error\ &Window.&Close<Tab>:cclose	:cclose<CR>

  " open close folds
  an 20.340.110 &Edit.&Fold.&Enable/Disable<Tab>zi		      zi
  an 20.340.120 &Edit.&Fold.Unfold\ to\ Cursor<Tab>zv		    zv
  an 20.340.120 &Edit.&Fold.Fold\ All\ Except\ Cursor<Tab>zMzx	zMzx
  inoremenu 20.340.120 &Edit.&Fold.Fold\ All\ Except\ Cursor<Tab>zMzx  <C-O>zM<C-O>zx
  an 20.340.130 &Edit.&Fold.Fold\ More<Tab>zm		  zm
  an 20.340.140 &Edit.&Fold.Fold\ All<Tab>zM		  zM
  an 20.340.150 &Edit.&Fold.Unfold\ More<Tab>zr		zr
  an 20.340.160 &Edit.&Fold.Unfold\ All<Tab>zR		zR
  " fold method
  an 20.340.200 &Edit.&Fold.-SEP1-			<Nop>
  an 20.340.210 &Edit.&Fold.Met&hod.M&anual	          :set fdm=manual<CR>
  an 20.340.210 &Edit.&Fold.Met&hod.I&ndent	          :set fdm=indent<CR>
  an 20.340.210 &Edit.&Fold.Met&hod.E&xpression       :set fdm=expr<CR>
  an 20.340.210 &Edit.&Fold.Met&hod.S&yntax	          :set fdm=syntax<CR>
  an 20.340.210 &Edit.&Fold.Met&hod.&Diff	            :set fdm=diff<CR>
  an 20.340.210 &Edit.&Fold.Met&hod.Ma&rker	          :set fdm=marker<CR>
  " create and delete folds
  vnoremenu 20.340.220 &Edit.&Fold.Create\ &Fold<Tab>zf	    zf
  an 20.340.230 &Edit.&Fold.&Delete\ Fold<Tab>zd		        zd
  an 20.340.240 &Edit.&Fold.Delete\ &All\ Folds<Tab>zD	    zD

  an 20.9999.1 &Edit.&VIM\ Config.Edit      :EditConfig<CR>
  an 20.9999.2 &Edit.&VIM\ Config.Reload      :source $MYVIMRC<CR>

  an &Plugs.&Plug.&Install 	                     :PlugInstall<CR>
  an &Plugs.&Plug.&Clean 	                       :PlugClean<CR>
  an &Plugs.&Plug.&Update 	                     :PlugUpdate<CR>
  an &Plugs.&Plug.Up&grade	                     :PlugUpgrade<CR>
  an &Plugs.&Plug.&Status 	                     :PlugStatus<CR>
  an &Plugs.-SEP1- 	                             <Nop>

  an &Plugs.&ALE.Toggle                          :ALEToggle<CR>
  an &Plugs.&ALE.Toggle\ Buffer                  :ALEToggleBuffer<CR>
  an &Plugs.&ALE.Rename\ Symbol                  :ALERename<CR>

  an &Plugs.&FZF.:FZF                            :FZF<CR>
  an &Plugs.&FZF.Colorschemes                    :Colors<CR>
  an &Plugs.&FZF.Commands                        :Commands<CR>
  an &Plugs.&FZF.Command\ History                :History:<CR>
  an &Plugs.&FZF.Files                           :Files<CR>
  an &Plugs.&FZF.Filetypes                       :Filetypes<CR>
  an &Plugs.&FZF.Helptags                        :Helptags<CR>
  an &Plugs.&FZF.Marks                           :Marks<CR>
  an &Plugs.&FZF.Tags                            :Tags<CR>

  an &Git.&Status                      :Gstatus<CR>
  an &Git.&Write+Stage<Tab>:Gw         :Gw<CR>
  an &Git.&Write+Stage+Close<Tab>:Gwq  :Gwq<CR>
  an &Git.&Blame                       :Gblame<CR>
  an &Git.&Pull 	                     :Git pull<CR>
  an &Git.&P&ush                       :Git push<CR>
  an &Git.&Commit                      :Git commit<CR>

  an &Plugs.&NERDTree.:NERDTreeToggle<Tab><F2>   :NERDTreeToggle<CR>

  an &Plugs.&Tagbar.:TagbarToggle<Tab><F4>       :TagbarToggle<CR>

  " Window menu
  silent! aunmenu Window
  an 70.300 &Window.&New<Tab>^Wn			<C-W>n
  an 70.310 &Window.Split.&Horizontal<Tab>^Ws		<C-W>s
  an 70.311 &Window.Split.&Vertically<Tab>^Wv	<C-W>v
  an 70.312 &Window.Split.to\ #<Tab>^W^^	<C-W><C-^>
  an <silent> 70.313 &Window.Split.File\ E&xplorer	:call MenuExplOpen()<CR>
  an 70.350 &Window.-SEP2-				                <Nop>
  an 70.355 &Window.Move.To\ &Top<Tab>^WK		      <C-W>K
  an 70.355 &Window.Move.To\ &Bottom<Tab>^WJ		  <C-W>J
  an 70.355 &Window.Move.To\ &Left\ Side<Tab>^WH	<C-W>H
  an 70.355 &Window.Move.To\ &Right\ Side<Tab>^WL	<C-W>L

  an 70.360 &Window.&Rotate.&Up<Tab>^WR			<C-W>R
  an 70.362 &Window.&Rotate.&Down<Tab>^Wr			<C-W>r

  an 70.370 &Window.Resi&ze.&Equal\ Size<Tab>^W=			<C-W>=
  an 70.380 &Window.Resi&ze.&Max\ Height<Tab>^W_			<C-W>_
  an 70.390 &Window.Resi&ze.M&in\ Height<Tab>^W1_			<C-W>1_
  an 70.400 &Window.Resi&ze.Max\ &Width<Tab>^W\|			<C-W>\|
  an 70.410 &Window.Resi&ze.Min\ Widt&h<Tab>^W1\|			<C-W>1\|

  " Help Menu (#9999)
  silent! aunmenu Help
  an 9999.1.1 &Help.&VIM.&Overview<Tab><F1>	:help<CR>
  an 9999.1.1 &Help.&VIM.-sep1-			        <Nop>
  an 9999.1.1 &Help.&VIM.&User\ Manual		  :help usr_toc<CR>
  an 9999.1.1 &Help.&VIM.&How-To\ Links		  :help how-to<CR>
  an 9999.1.1 &Help.&VIM.-sep2-			        <Nop>
  an 9999.1.1 &Help.&VIM.&Version		        :version<CR>
  an 9999.1.1 &Help.&VIM.&About			        :intro<CR>

  an &Help.&Plugins.fzf-vim           :tab help fzf-vim<CR>
  an &Help.&Plugins.ALE               :tab help ale<CR>
  an &Help.&Plugins.NERDTree          :tab help NERDTree<CR>

endif " End of Menu Bar Items 1}}}
" vim: fdm=marker fen fdl=0
  '';
  vimrcConfig.packages.myVimPackage = with unstable.vimPlugins; {
    start = [ 
      fugitive 
      polyglot 
      vim-startify
      vim-plug
      vim-which-key
      vim-automkdir
      jq-vim
      i3config-vim
      vim-sensible
      vim-surround
      vim-scriptease
      easy-align
      ale
      onedark-vim
      delimitMate
      vim-speeddating
      vim-nix
    ];
    /* manually loadable by calling `:packadd $plugin-name` */
    opt = [];
  };
}
