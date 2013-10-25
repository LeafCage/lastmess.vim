if exists('s:save_cpo')| finish| endif
let s:save_cpo = &cpo| set cpo&vim
"=============================================================================
function! lastmess#view(count) "{{{
  let mess = s:_get_messages()
  if g:lastmess_ignore_pattern!=''
    let mess = filter(mess, 'v:val!~g:lastmess_ignore_pattern')
  end
  let n = a:count==0 ? g:lastmess_default_count : a:count
  let messlen = len(mess)
  let n = abs(n)>messlen ? messlen : n
  let n = n<0 ? n : n*-1
  let lang = v:lang=='ja' ? 'ja' : 'en'
  redraw!
  try
    for mes in mess[(n):-1]
      call s:_echohl_{lang}(mes)
      ec mes
    endfor
  finally
    echoh NONE
  endtry
endfunction
"}}}

"=============================================================================
function! s:_get_messages() "{{{
  let save_vfile = &verbosefile
  set verbosefile=
  redir => _
  silent! messages
  redir END
  let &verbosefile = save_vfile
  return filter(split(_, "\n"), 'v:val!=""')
endfunction
"}}}
function! s:_echohl_en(mes) "{{{
  if a:mes=~#'^search hit \%(BOTTOM\|TOP\)'
    echoh WarningMsg
  elseif a:mes=~#'^E\d\+:\|^Error detected while processing'
    echoh ErrorMsg
  elseif a:mes=~#'^line\s\+\d'
    echoh LineNr
  elseif a:mes=~#'^replace with\|^Scanning\%(:\| tags.\)'
    echoh Question
  elseif a:mes=~#'<[a-zA-Z0-9.!#$%&''*+/=?^_`{|}~-]\+@[a-zA-Z0-9-]\+\%(\.[a-zA-Z0-9-]\+\)*>$'
    echoh Title
  else
    echoh NONE
  end
endfunction
"}}}
function! s:_echohl_ja(mes) "{{{
  if a:mes=~#'に戻ります$'
    echoh WarningMsg
  elseif a:mes=~#'^E\d\+:\|の処理中にエラーが検出されました:'
    echoh ErrorMsg
  elseif a:mes=~#'^行\s\+\d'
    echoh LineNr
  elseif a:mes=~#'\%(\sに置換しますか?\)\|\%(^スキャン中:\)\|\%(^タグをスキャン中.\)'
    echoh Question
  elseif a:mes=~#'<[a-zA-Z0-9.!#$%&''*+/=?^_`{|}~-]\+@[a-zA-Z0-9-]\+\%(\.[a-zA-Z0-9-]\+\)*>$'
    echoh Title
  else
    echoh NONE
  end
endfunction
"}}}

"=============================================================================
"END "{{{1
let &cpo = s:save_cpo| unlet s:save_cpo
