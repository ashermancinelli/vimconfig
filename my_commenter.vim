
function! MyNComment()
    let sep="//"

    if &filetype ==# 'c' || &filetype ==# 'c' || &filetype==#'js'
        let sep="//"
    elseif &filetype ==# 'python' || &filetype ==# 'sh' || &filetype ==# 'make' || &filetype ==# 'perl'
        let sep="#"
    elseif &filetype ==# 'vim'
        let sep='"'
    endif

    if stridx(getline("."), sep) != -1
        call setline(".", substitute(getline("."), sep . '\s\+', '', '1'))
        echom "Removing Comment"
    else
        exe "normal! I" . sep . " "
        echom "New Comment"
    endif
endfunction

function! MyVComment()
    let top_com="/*"
    let bottom_com="*/"
    let wrapping_comment=1 
    let sep='//'

    if &filetype ==# 'c' || &filetype ==# 'c++' || &filetype ==# 'js'
        let top_com="/*"
        let bottom_com="*/"
        let wrapping_comment=1
    elseif &filetype ==# 'python'
        let top_com="'''"
        let bottom_com="'''"
        let wrapping_comment=1
    elseif &filetype ==# 'sh' || &filetype ==# 'make' || &filetype ==# 'perl' || &filetype ==# 'cmake'
        let wrapping_comment=0
        let sep='#'
    elseif &filetype ==# 'vim'
        let wrapping_comment=0
        let sep='"'
    endif

    let top_pos=getpos("'<")[1]
    let bottom_pos=getpos("'>")[1]

    if wrapping_comment == 1
        call cursor(top_pos, 1)
        exe "normal!O" . top_com
        call cursor(bottom_pos+1, 1)
        exe "normal!o" . bottom_com
    else
        exe 'silent! ' . string(top_pos) . ',' . string(bottom_pos) . 's/^/' . sep . ' /g'
    endif
endfunction

" Remap c-k to my commenting function
nnoremap <c-c> :call MyNComment()
vnoremap <c-c> :call MyVComment()

