" An example for a vimrc file.
"
" Maintainer:	Bram Moolenaar <Bram@vim.org>
" Last change:	2016 Jul 28
"
" To use it, copy it to
"     for Unix and OS/2:  ~/.vimrc
"	      for Amiga:  s:.vimrc
"  for MS-DOS and Win32:  $VIM\_vimrc
"	    for OpenVMS:  sys$login:.vimrc

" When started as "evim", evim.vim will already have done these settings.
if v:progname =~? "evim"
  finish
endif

" Get the defaults that most users want.
source $VIMRUNTIME/defaults.vim

if has("vms")
  set nobackup		" do not keep a backup file, use versions instead
"else
"  set backup		" keep a backup file (restore to previous version)
"  if has('persistent_undo')
"    set undofile	" keep an undo file (undo changes after closing)
"  endif
endif

if &t_Co > 2 || has("gui_running")
  " Switch on highlighting the last used search pattern.
  set hlsearch
endif

" Only do this part when compiled with support for autocommands.
if has("autocmd")

  " Put these in an autocmd group, so that we can delete them easily.
  augroup vimrcEx
  au!

  " For all text files set 'textwidth' to 78 characters.
  autocmd FileType text setlocal textwidth=78

  augroup END

else

  set autoindent		" always set autoindenting on

endif " has("autocmd")

" Add optional packages.
"
" The matchit plugin makes the % command work better, but it is not backwards
" compatible.
if has('syntax') && has('eval')
  packadd matchit
endif

set mouse=
"syntax on
set nu
set autoindent      "ai
"set cindent
set smartindent     "si
set shiftwidth=4    "indent length
set tabstop=4       "tabwidth=4 spaces
set expandtab       "change tab into space
"set ignorecase
"set hlsearch
set bg=dark
"set paste
filetype plugin indent on

set grepprg=grep\ -nH\ $*
let g:tex_flavor = "latex"
"set iskeyword+=:
"let g:ycm_server_keep_logfiles = 1
"let g:ycm_server_log_level = 'debug'
"let g:ycm_global_ycm_extra_conf = '~/Documents/.ycm_extra_conf.py'
if exists("g:loaded_fix_indentkeys")
    finish
endif

let g:loaded_fix_indentkeys = 1

" Set indentkeys option again on changed filetype option.
" This fixes TeX \item indentation in combination with YouCompleteMe.
" See https://github.com/Valloric/YouCompleteMe/issues/1244
" You may add more filetypes if necessary.
autocmd FileType tex,plaintex execute "setlocal indentkeys=" . &indentkeys

" fix meta-keys which generate <Esc>a .. <Esc>z
"let c='a'
"while c <= 'z'
"  exec "set <M-".toupper(c).">=\e".c
"  exec "imap \e".c." <M-".toupper(c).">"
"  let c = nr2char(1+char2nr(c))
"endw
let c='a'
while c <= 'z'
  exec "set <A-".c.">=\e".c
  exec "imap \e".c." <A-".c.">"
  let c = nr2char(1+char2nr(c))
endw

set timeout ttimeoutlen=50

" vim-airline
set laststatus=2
let g:airline_powerline_fonts = 1
if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif
let g:airline_symbols.linenr = '¶'
let g:airline#extensions#tabline#enabled = 1 " buffertab
nnoremap <C-N> :bn<CR>
nnoremap <C-P> :bp<CR>

" NERDTree
map <F2> :NERDTreeToggle<CR>
let NERDTreeShowLineNumbers = 1

" Tagbar
map <F9> :TagbarToggle<CR>
let g:tagbar_show_linenumbers = 1

"split navigations
let g:C_Ctrl_j = 'off'
nnoremap <C-_> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

" vim in tmux
if &term =~ '^screen'
    " tmux will send xterm-style keys when its xterm-keys option is on
    execute "set <xUp>=\e[1;*A"
    execute "set <xDown>=\e[1;*B"
    execute "set <xRight>=\e[1;*C"
    execute "set <xLeft>=\e[1;*D"
endif
map! <C-a> <Home>
map! <C-e> <End>
map <C-a> <Home>
map <C-e> <End>
