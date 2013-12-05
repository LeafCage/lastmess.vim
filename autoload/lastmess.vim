if exists('s:save_cpo')| finish| endif
let s:save_cpo = &cpo| set cpo&vim
scriptencoding utf-8
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
      echoh NONE
      call s:_echohl_special(mes)
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
  elseif a:mes=~#'^Error detected while processing'
    exe 'echoh' g:lastmess_highlight_errstart
  elseif a:mes=~#'^E\d\+:'
    exe 'echoh' g:lastmess_highlight_errcontents
  elseif a:mes=~#'^line\s\+\d'
    echoh LineNr
  elseif a:mes=~#'^replace with\|^Scanning\%(:\| tags.\)'
    echoh Question
  elseif a:mes=~#'<[a-zA-Z0-9.!#$%&''*+/=?^_`{|}~-]\+@[a-zA-Z0-9-]\+\%(\.[a-zA-Z0-9-]\+\)*>$'
    echoh Title
  end
endfunction
"}}}
function! s:_echohl_ja(mes) "{{{
  if a:mes=~#'に戻ります$'
    echoh WarningMsg
  elseif a:mes=~#'の処理中にエラーが検出されました:'
    exe 'echoh' g:lastmess_highlight_errstart
  elseif a:mes=~#'^E\d\+:'
    exe 'echoh' g:lastmess_highlight_errcontents
  elseif a:mes=~#'^行\s\+\d'
    echoh LineNr
  elseif a:mes=~#'\%(\sに置換しますか?\)\|\%(^スキャン中:\)\|\%(^タグをスキャン中.\)'
    echoh Question
  elseif a:mes=~#'<[a-zA-Z0-9.!#$%&''*+/=?^_`{|}~-]\+@[a-zA-Z0-9-]\+\%(\.[a-zA-Z0-9-]\+\)*>$'
    echoh Title
  end
endfunction
"}}}
function! s:_echohl_special(mes) "{{{
  for [higroup, pat] in g:lastmess_special_highlight
    if a:mes=~# pat
      exe 'echoh' higroup
    end
  endfor
endfunction
"}}}

"=============================================================================
"END "{{{1
let &cpo = s:save_cpo| unlet s:save_cpo
