
" Select indented block
function! SelectIndent ()
  let temp_var=indent(line("."))
  while indent(line(".")-1) >= temp_var
    exe "normal k"
  endwhile
  exe "normal V"
  while indent(line(".")+1) >= temp_var
    exe "normal j"
  endwhile
endfun
nmap vip :call SelectIndent()<CR>

function! AutoFolding ()
  set foldenable
  set foldlevelstart=99
  set foldmethod=syntax
endfun

" Folding
if has("folding")
  " Automatic folding
  nmap <leader>af :call AutoFolding()<CR>

  "set foldcolumn=1
  "hi FoldColumn ctermfg=grey

  " toggle folds
  nnoremap <Space> za
  vnoremap <Space> za

  "fold tags
  nnoremap <leader>ft Vatzf
  "fold brackets
  nnoremap <leader>ff [{V%zf
  nnoremap <leader>fb V%zf
  "fold paragraph
  nnoremap <leader>fp V}kzf
  "fold same indentation
  nnoremap <leader>fi :call SelectIndent()<CR>zf

  function! FoldText()
    let l:lpadding = &fdc
    redir => l:signs
      execute 'silent sign place buffer='.bufnr('%')
    redir End
    let l:lpadding += l:signs =~ 'id=' ? 2 : 0
    if exists("+relativenumber")
      if (&number)
        let l:lpadding += max([&numberwidth, strlen(line('$'))]) + 1
      elseif (&relativenumber)
        let l:lpadding += max([&numberwidth, strlen(v:foldstart - line('w0')), strlen(line('w$') - v:foldstart), strlen(v:foldstart)]) + 1
      endif
    else
      if (&number)
        let l:lpadding += max([&numberwidth, strlen(line('$'))]) + 1
      endif
    endif
    " expand tabs
    let l:start = substitute(getline(v:foldstart), '\t', repeat(' ', &tabstop), 'g')
    let l:end = substitute(substitute(getline(v:foldend), '\t', repeat(' ', &tabstop), 'g'), '^\s*', '', 'g')
    let l:info = ' (' . (v:foldend - v:foldstart) . ')'
    let l:infolen = strlen(substitute(l:info, '.', 'x', 'g'))
    let l:width = winwidth(0) - l:lpadding - l:infolen
    let l:separator = ' … '
    let l:separatorlen = strlen(substitute(l:separator, '.', 'x', 'g'))
    let l:start = strpart(l:start , 0, l:width - strlen(substitute(l:end, '.', 'x', 'g')) - l:separatorlen)
    let l:text = '⊞' . l:start . ' … ' . l:end
    return l:text . repeat(' ', l:width - strlen(substitute(l:text, ".", "x", "g"))) . l:info
  endfunction
  set foldtext=FoldText()
endif
