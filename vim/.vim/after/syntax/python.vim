" Unset the syntax to allow the rst syntax file to load
unlet b:current_syntax

" Check for 'prior_isk' to prevent recursive loading in code blocks
if !exists("prior_isk")
    syn include @pythonRst syntax/rst.vim

    syn match rstTransition /^\s*[=`:.'"~^_*+#-]\{4,}\s*$/

    syn region pythonDocstring start=+^\s*"""+ end=+"""+ contains=@pythonRst,pythonDoctest

    hi def pythonDocstring ctermfg=20 term=italic cterm=italic
endif

" Reset the syntax to python
let b:current_syntax = "python"
