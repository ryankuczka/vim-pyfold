" pyfold.vim -- Fancy folds for python
" Maintainer: Ryan Kuczka <ryan.kuczka@gmail.com>
" Last Updated: 2014-09-30

if exists('b:loaded_pyfold')
  finish
endif
let b:loaded_pyfold = 1

" Config Settings: {{{1
" ================
if !exists('g:pyfold_braces')
  let g:pyfold_braces = 1
endif
if !exists('g:pyfold_brackets')
  let g:pyfold_brackets = 1
endif
if !exists('g:pyfold_parens')
  let g:pyfold_parens = 0
endif
if !exists('b:pyfold_enabled')
  if exists('g:pyfold_enabled')
    let b:pyfold_enabled = g:pyfold_enabled
  else
    let b:pyfold_enabled = 1
  endif
endif

" Regex Patterns: {{{1
" ===============
let s:class_func_pattern = '^\s*\%(@\|class\>\|def\>\)'
let s:empty_line_pattern = '^\s*$'
let s:brace_open_pattern = '^.\{-}{[^}]*$'
let s:brace_close_pattern = '^[^{]\{-}}.*$'
let s:bracket_open_pattern = '^.\{-}\[[^\]]*$'
let s:bracket_close_pattern = '^[^\[]\{-}\].*$'
let s:paren_open_pattern = '^.\{-}([^)]*$'
let s:paren_close_pattern = '^[^(]\{-}):\@!.*$'

" Fold Option Functions: {{{1
" ======================
function! IndentLevel(lnum) " {{{2
  return indent(a:lnum) / &shiftwidth
endfunction

function! PythonFoldExpr(lnum)  " {{{2
  let text = getline(a:lnum)
  let chars = split(text, '\zs')

  " If this is a class, function, or decorator set foldlevel based on indent level
  if text =~# s:class_func_pattern
    return IndentLevel(a:lnum) + 1
  endif

  if g:pyfold_braces
    if text =~# s:brace_open_pattern
      return 'a1'
    elseif text =~# s:brace_close_pattern
      return 's1'
    endif
  endif

  if g:pyfold_brackets
    if text =~# s:bracket_open_pattern
      return 'a1'
    elseif text =~# s:bracket_close_pattern
      return 's1'
    endif
  endif

  " XXX: Still buggy in case like:
  "   if (foo and     <-- adds 1 to foldlevel...
  "       not bar):   <-- doesn't subtract 1...
  if g:pyfold_parens
    if text =~# s:paren_open_pattern
      return 'a1'
    elseif text =~# s:paren_close_pattern
      return 's1'
    endif
  endif

  " When we are on a blank line
  if text =~# s:empty_line_pattern
    " When the next line has no indent, but isn't blank, close foldlevel 1
    if IndentLevel(a:lnum + 1) == 0 && getline(a:lnum + 1) !~# s:empty_line_pattern
      return '<1'
    " When the next line has indent level 1, close foldlevel 2
    elseif IndentLevel(a:lnum + 1) == 1
      return '<2'
    " Otherwise, use the previous foldlevel
    else
      return '='
    endif
  endif

  " Reset foldlevel to 0 if no indent, but not blank
  if indent(a:lnum) == 0
    return 0
  endif

  " Everything else, use the previous foldlevel
  return '='
endfunction

function! PythonFoldText() " {{{2
  " Get the appropriate size string
  let size = 1 + v:foldend - v:foldstart
  if size < 10
    let size = '  '.size.' '
  elseif size < 100
    let size = ' '.size.' '
  elseif size < 1000
    let size = size.' '
  endif

  " Determine what foldtext should be
  let text = getline(v:foldstart)

  " If fold began on open brace, add a close brace to the fold text
  if g:pyfold_braces && text =~# s:brace_open_pattern
    let text = text.'}'

  " If fold began on open bracket, add a close bracket to the fold text
  elseif g:pyfold_brackets && text =~# s:bracket_open_pattern
    let text = text.']'

  " If fold begain on open paren, add a close paren to the fold text
  elseif g:pyfold_parens && text =~# s:paren_open_pattern
    let text = text.')'

  " If fold began on a decorator, keep adding decorators to fold text until
  " function/class is found
  " e.g. --> @property: my_property(self)
  elseif text =~ '^\s*@'
    let curline = v:foldstart
    while getline(curline) =~ '^\s*@'
      let text = text.': '.substitute(substitute(getline(curline + 1), '^\s*\(.\{-}\)\s*$', '\1', ''), '\%(def\|class\) ', '', 'g')
      let curline = curline + 1
    endwhile
  endif

  " Strip whitespace
  let text = substitute(text, '^\s*\(.\{-}\)\s*$', '\1', '')
  return '+'.v:folddashes.size.'lines: '.text
endfunction " }}}2

" Commands: {{{1
" =========
function! s:PyFoldEnable() " {{{2
  let b:pyfold_enabled = 1

  setlocal foldmethod=expr
  setlocal foldexpr=PythonFoldExpr(v:lnum)
  setlocal foldtext=PythonFoldText()
endfunction

function! s:PyFoldDisable() " {{{2
  let b:pyfold_enabled = 0

  setlocal foldmethod=manual
  setlocal foldexpr=0
  setlocal foldtext=foldtext()
endfunction

function! s:PyFoldToggle() " {{{2
  if b:pyfold_enabled
    call <SID>PyFoldDisable()
  else
    call <SID>PyFoldEnable()
  endif
endfunction " }}}2

command! PyFoldEnable call <SID>PyFoldEnable()
command! PyFoldDisable call <SID>PyFoldDisable()
command! PyFoldToggle call <SID>PyFoldToggle()

" Enable on load if desired
if b:pyfold_enabled
  call <SID>PyFoldEnable()
endif

" vim:fdm=marker:fmr={{{,}}}:fdl=1
