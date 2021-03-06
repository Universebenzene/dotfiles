" this is mostly a matter of taste. but LaTeX looks good with just a bit
" of indentation.
set sw=2
" TIP: if you write your \label's as \label{fig:something}, then if you
" type in \ref{fig: and press <C-n> you will automatically cycle through
" all the figure labels. Very useful!
set iskeyword+=:

set tabstop=4
set shiftwidth=4

let g:Tex_UsePython = 0

let g:Tex_DefaultTargetFormat = 'pdf'

let g:Tex_CompileRule_pdf = 'xelatex -synctex=1 -interaction=nonstopmode -file-line-error-style $*'

let g:Tex_ViewRule_pdf = 'okular'

let g:Tex_AdvancedMath = 1

"let g:Tex_IgnoredWarnings =
"    \'Underfull'."\n".
"    \'Overfull'."\n".
"    \'specifier changed to'."\n".
"    \'You have requested'."\n".
"    \'Missing number, treated as zero.'."\n".
"    \'There were undefined references'."\n".
"    \'Citation %.%# undefined'."\n".
"    \'Package titlesec Warning'

"let g:Tex_IgnoreLevel = 8
