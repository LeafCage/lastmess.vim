let g:lastmess_default_count = get(g:, 'lastmess_default_count', 10)
let g:lastmess_ignore_pattern = get(g:, 'lastmess_ignore_pattern', '')
command! -count=0   Messages    call lastmess#view(<count>)
nnoremap <silent><Plug>(lastmess)    :<C-u>call lastmess#view(v:count)<CR>
