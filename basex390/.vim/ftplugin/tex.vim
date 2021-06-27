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

"xe only
let g:Tex_CompileRule_pdf = 'xelatex -synctex=1 -interaction=nonstopmode -file-line-error-style $*'

""raa
"let g:Tex_FormatDependency_pdf='dvi,pdf'
"let g:Tex_MultipleCompileFormats = 'dvi'
"""let g:Tex_CompileRule_dvipdf= 'dvipdfm $*.dvi'
"""let g:Tex_CompileRule_pdf = 'dvipdfm $*.dvi'

let g:Tex_ViewRule_pdf = 'okular'

let g:Tex_AdvancedMath = 1
