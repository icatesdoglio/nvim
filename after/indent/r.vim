let g:r_indent_debug = 1

if exists("b:did_indent")
  finish
endif
let b:did_indent = 1

setlocal indentexpr=GetRIndent(v:lnum)
setlocal indentkeys=0{,0},!^F,o,O,0),0],0=,:,=else,=elseif
setlocal autoindent
setlocal nolisp

let b:undo_indent = "setlocal indentexpr< indentkeys< autoindent< nolisp<"

function! GetRIndent(lnum)
  echo 'Current line: ' . a:lnum
  let line = getline(a:lnum)
  let prev_lnum = prevnonblank(a:lnum - 1)
  let prev_line = getline(prev_lnum)

  " If the current line is blank, just copy the previous indent
  if line =~ '^\s*$'
    return indent(prev_lnum)
  endif

  " If previous line ends in a pipe, indent further
  if prev_line =~# '%>%\s*$\|\\|>\s*$'
    return indent(prev_lnum) + &shiftwidth
  endif

  " If current line starts with a closing bracket, dedent
  if line =~# '^\s*[\])}]'
    return indent(prev_lnum) - &shiftwidth
  endif

  " Otherwise, match previous indent
  return indent(prev_lnum)
endfunction
