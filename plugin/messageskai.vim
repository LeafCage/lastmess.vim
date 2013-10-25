let g:messageskai_default_count = get(g:, 'messageskai_default_count', 10)
let g:messageskai_ignore_pattern = get(g:, 'messageskai_ignore_pattern', '')
command! -count=0   Messages    call messageskai#view(<count>)
nnoremap <Plug>(messages-kai-view)    :<C-u>call messageskai#view(v:count)<CR>
