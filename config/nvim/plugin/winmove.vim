" Window movement shortcuts
function s:WinMove(key)
    let t:curwin = winnr()
    exec "wincmd ".a:key
endfunction

nnoremap <Plug>WinMoveLeft :<C-U>call <SID>WinMove('h')<CR>
nnoremap <Plug>WinMoveDown :<C-U>call <SID>WinMove('j')<CR>
nnoremap <Plug>WinMoveUp :<C-U>call <SID>WinMove('k')<CR>
nnoremap <Plug>WinMoveRight :<C-U>call <SID>WinMove('l')<CR>
