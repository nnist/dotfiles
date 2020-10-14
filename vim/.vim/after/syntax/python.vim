" Unset the syntax to allow the rst syntax file to load
unlet b:current_syntax

" Disable inline code block highlighting. This -can- be enabled, but will
" currently break some minor other highlights (i.e. if/else, True/False)
" and cause some slowdown.
let g:rst_syntax_code_list = {}

" Check for 'prior_isk' to prevent recursive loading in code blocks
if !exists("prior_isk")
    syn include @pythonRst syntax/rst.vim

    " Allow indentation for titles
    syn match rstTransition /^\s*[=`:.'"~^_*+#-]\{4,}\s*$/
    
    " Clear hyperlink targets to prevent breakage for i.e. ':param dry_run:'
    syn clear rstHyperlinkTarget

    " Prevent having multiple quotes under a text from breaking highlighting
    syn clear rstSections
    syn match   rstSections "\v^%(([=`:.~^_*+#-])\1+\n)?.{1,2}\n([=`:.~^_*+#-])\2+$"
        \ contains=@Spell
    syn match   rstSections "\v^%(([=`:.~^_*+#-])\1{2,}\n)?.{3,}\n([=`:.~^_*+#-])\2{2,}$"
        \ contains=@Spell

    " Style field lists, as they aren't styled in the rst syntax file
    syn match docstringFieldListContents / :.*: /hs=s+2,he=e-2 contained
    syn match docstringFieldList / :.*: /hs=s+1,he=e-1 contains=docstringFieldListContents
    hi def link docstringFieldListContents Function
    hi def link docstringFieldList Delimiter

    " Aply rst styling to docstrings
    syn region pythonDocstring start=+^\s*"""+ end=+"""+
        \ contains=@pythonRst,pythonDoctest,docstringFieldList
    hi def pythonDocstring ctermfg=16
endif

" Reset the syntax to python
let b:current_syntax = "python"
