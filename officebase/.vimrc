scriptencoding utf-8
" ^^ Please leave the above line at the start of the file.

" Default configuration file for Vim

" Written by Aron Griffis <agriffis@gentoo.org>
" Modified by Ryan Phillips <rphillips@gentoo.org>
" Modified some more by Ciaran McCreesh <ciaranm@gentoo.org>
" Added Redhat's vimrc info by Seemant Kulleen <seemant@gentoo.org>

" You can override any of these settings on a global basis via the
" "/etc/vim/vimrc.local" file, and on a per-user basis via "~/.vimrc". You may
" need to create these.

" {{{ General settings
" The following are some sensible defaults for Vim for most users.
" We attempt to change as little as possible from Vim's defaults,
" deviating only where it makes sense
set nocompatible        " Use Vim defaults (much better!)
set bs=2                " Allow backspacing over everything in insert mode
set ai                  " Always set auto-indenting on
set history=50          " keep 50 lines of command history
set ruler               " Show the cursor position all the time

set viminfo='20,\"500   " Keep a .viminfo file.

" Don't use Ex mode, use Q for formatting
map Q gq

" When doing tab completion, give the following files lower priority. You may
" wish to set 'wildignore' to completely ignore files, and 'wildmenu' to enable
" enhanced tab completion. These can be done in the user vimrc file.
set suffixes+=.info,.aux,.log,.dvi,.bbl,.out,.o,.lo

" When displaying line numbers, don't use an annoyingly wide number column. This
" doesn't enable line numbers -- :set number will do that. The value given is a
" minimum width to use for the number column, not a fixed size.
if v:version >= 700
  set numberwidth=3
endif
" }}}

" {{{ Modeline settings
" We don't allow modelines by default. See bug #14088 and bug #73715.
" If you're not concerned about these, you can enable them on a per-user
" basis by adding "set modeline" to your ~/.vimrc file.
set nomodeline
" }}}

" {{{ Locale settings
" Try to come up with some nice sane GUI fonts. Also try to set a sensible
" value for fileencodings based upon locale. These can all be overridden in
" the user vimrc file.
if v:lang =~? "^ko"
  set fileencodings=euc-kr
  set guifontset=-*-*-medium-r-normal--16-*-*-*-*-*-*-*
elseif v:lang =~? "^ja_JP"
  set fileencodings=euc-jp
  set guifontset=-misc-fixed-medium-r-normal--14-*-*-*-*-*-*-*
elseif v:lang =~? "^zh_TW"
  set fileencodings=big5
  set guifontset=-sony-fixed-medium-r-normal--16-150-75-75-c-80-iso8859-1,-taipei-fixed-medium-r-normal--16-150-75-75-c-160-big5-0
elseif v:lang =~? "^zh_CN"
  set fileencodings=gb2312
  set guifontset=*-r-*
endif

" If we have a BOM, always honour that rather than trying to guess.
if &fileencodings !~? "ucs-bom"
  set fileencodings^=ucs-bom
endif

" Always check for UTF-8 when trying to determine encodings.
if &fileencodings !~? "utf-8"
  " If we have to add this, the default encoding is not Unicode.
  " We use this fact later to revert to the default encoding in plaintext/empty
  " files.
  let g:added_fenc_utf8 = 1
  set fileencodings+=utf-8
endif

" Make sure we have a sane fallback for encoding detection
if &fileencodings !~? "default"
  set fileencodings+=default
endif
" }}}

" {{{ Syntax highlighting settings
" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
endif
" }}}

" {{{ Terminal fixes
if &term ==? "xterm"
  set t_Sb=^[4%dm
  set t_Sf=^[3%dm
  set ttymouse=xterm2
endif

if &term ==? "gnome" && has("eval")
  " Set useful keys that vim doesn't discover via termcap but are in the
  " builtin xterm termcap. See bug #122562. We use exec to avoid having to
  " include raw escapes in the file.
  exec "set <C-Left>=\eO5D"
  exec "set <C-Right>=\eO5C"
endif
" }}}

" {{{ Filetype plugin settings
" Enable plugin-provided filetype settings, but only if the ftplugin
" directory exists (which it won't on livecds, for example).
if isdirectory(expand("$VIMRUNTIME/ftplugin"))
  filetype plugin on

  " Uncomment the next line (or copy to your ~/.vimrc) for plugin-provided
  " indent settings. Some people don't like these, so we won't turn them on by
  " default.
  " filetype indent on
endif
" }}}

" {{{ Fix &shell, see bug #101665.
if "" == &shell
  if executable("/bin/bash")
    set shell=/bin/bash
  elseif executable("/bin/sh")
    set shell=/bin/sh
  endif
endif
"}}}

" {{{ Our default /bin/sh is bash, not ksh, so syntax highlighting for .sh
" files should default to bash. See :help sh-syntax and bug #101819.
if has("eval")
  let is_bash=1
endif
" }}}

" {{{ Autocommands
if has("autocmd")

augroup gentoo
  au!

  " Gentoo-specific settings for ebuilds.  These are the federally-mandated
  " required tab settings.  See the following for more information:
  " http://www.gentoo.org/proj/en/devrel/handbook/handbook.xml
  " Note that the rules below are very minimal and don't cover everything.
  " Better to emerge app-vim/gentoo-syntax, which provides full syntax,
  " filetype and indent settings for all things Gentoo.
  au BufRead,BufNewFile *.e{build,class} let is_bash=1|setfiletype sh
  au BufRead,BufNewFile *.e{build,class} set ts=4 sw=4 noexpandtab

  " In text files, limit the width of text to 78 characters, but be careful
  " that we don't override the user's setting.
  autocmd BufNewFile,BufRead *.txt
        \ if &tw == 0 && ! exists("g:leave_my_textwidth_alone") |
        \     setlocal textwidth=78 |
        \ endif

  " When editing a file, always jump to the last cursor position
  autocmd BufReadPost *
        \ if ! exists("g:leave_my_cursor_position_alone") |
        \     if line("'\"") > 0 && line ("'\"") <= line("$") |
        \         exe "normal! g'\"" |
        \     endif |
        \ endif

  " When editing a crontab file, set backupcopy to yes rather than auto. See
  " :help crontab and bug #53437.
  autocmd FileType crontab set backupcopy=yes

  " If we previously detected that the default encoding is not UTF-8
  " (g:added_fenc_utf8), assume that a file with only ASCII characters (or no
  " characters at all) isn't a Unicode file, but is in the default encoding.
  " Except of course if a byte-order mark is in effect.
  autocmd BufReadPost *
        \ if exists("g:added_fenc_utf8") && &fileencoding == "utf-8" &&
        \    ! &bomb && search('[\x80-\xFF]','nw') == 0 && &modifiable |
        \       set fileencoding= |
        \ endif

augroup END

endif " has("autocmd")
" }}}

" We don't want VIM to load their own built-in defaults, preferring ours here
" instead. This option cannot apply to minimal builds, so it is guarded by a
" test that's guaranteed to fail for those, owing to the lack of +eval.
if 1
  let g:skip_defaults_vim = 1
endif

" Enable Omni completion when opening a file only if a specific plugin does
" not already exist for that filetype. This allows Omni completion
" (Ctrl-x/Ctrl-o) to work with any programming language if and only if a syntax
" file exists for the said language.
if exists("+omnifunc")
   autocmd Filetype *
          \	if &omnifunc == "" |
          \		setlocal omnifunc=syntaxcomplete#Complete |
          \	endif
endif

" {{{ vimrc.local
if filereadable("/etc/vim/vimrc.local")
  source /etc/vim/vimrc.local
endif
" }}}

set fileencodings=utf-8,ucs-bom,latin1,gb2312,default
set mouse=
syntax on
verbose set modeline
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
set showcmd
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

" ycm
let g:ycm_auto_trigger = 1  " 1 for enable; 0 for disable
"let g:SuperTabDefaultCompletionType="context"
"let g:ycm_server_python_interpreter='/usr/bin/python3.6'
"let g:ycm_server_python_interpreter='python3.6'
let g:ycm_complete_in_comments = 1
let g:ycm_collect_identifiers_from_comments_and_strings = 1
let g:ycm_collect_identifiers_from_tags_files = 1
let g:ycm_seed_identifiers_with_syntax = 1

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
map <F8> :TagbarToggle<CR>
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

" indentLine
let g:vim_json_conceal=0
let g:markdown_syntax_conceal=0
