let g:lastmess_default_count = get(g:, 'lastmess_default_count', 20)
let g:lastmess_ignore_pattern = get(g:, 'lastmess_ignore_pattern', '')
let g:lastmess_highlight_errstart = get(g:, 'lastmess_highlight_errstart', 'ErrorMsg')
let g:lastmess_highlight_errcontents = get(g:, 'lastmess_highlight_errcontents', 'PreProc')
command! -count=0   LastMess    call lastmess#view(<count>)
nnoremap <silent><Plug>(lastmess)    :<C-u>call lastmess#view(v:count)<CR>
