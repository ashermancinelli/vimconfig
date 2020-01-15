filetype plugin indent on
syntax on

nnoremap j jzz
nnoremap k kzz
nnoremap n nzz
nnoremap G Gzz
nnoremap gg ggzz
nnoremap gy :Goyo<Enter>
nnoremap tn gt
nnoremap tp gT
nnoremap tc :tabclose<Enter>
nnoremap T :NERDTree<Enter>
autocmd Filetype txt setlocal spell
autocmd Filetype tex setlocal spell

" Configuring folding
set foldmethod=expr
autocmd Filetype * AnyFoldActivate
let g:anyfold_fold_comments=1
" set foldlevel=0
set nofoldenable
" hi Folded term=NONE cterm=NONE

" For javascript backtick highlighting
let g:javascript_plugin_flow = 1
" ---

let g:fold_cycle_default_mapping = 0 "disable default mappings
nmap <Tab><Tab> <Plug>(fold-cycle-open)
nmap <S-Tab><S-Tab> <Plug>(fold-cycle-close)

set number
set relativenumber
set t_Co=256
" show existing tab with 4 spaces width
set tabstop=4
" when indenting with '>', use 4 spaces width
set shiftwidth=4
" On pressing tab, insert 4 spaces
set expandtab
set softtabstop=4

set backspace=indent,eol,start
set autoindent
set ruler
set showcmd

" Remap Ctrl-P to plug
let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'

call plug#begin('~/.vim/plugged')

Plug 'JuliaLang/julia-vim'
Plug 'arecarn/vim-fold-cycle'
Plug 'pseewald/vim-anyfold'
Plug 'scrooloose/nerdtree'
Plug 'altercation/vim-colors-solarized'
Plug 'flazz/vim-colorschemes'
Plug 'junegunn/goyo.vim'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'pangloss/vim-javascript'
Plug 'chrisbra/unicode.vim'

call plug#end()

" My plugin

function! MyNComment()
    let sep="//"

    if &filetype ==# 'c' || &filetype ==# 'c' || &filetype==#'js'
        let sep="//"
    elseif &filetype ==# 'python' || &filetype ==# 'bash'
        let sep="#"
    endif

    if stridx(getline("."), sep) != -1
        " exe 's/' . sep . '\s\+//ge'
        call setline(".", substitute(getline("."), sep . '\s\+', '', 'g'))
        echom "Found already"
    else
        exe "normal! I" . sep . " "
        echom "New Comment"
    endif
endfunction

function! MyVComment()
    let top_com="/*"
    let bottom_com="*/"

    if &filetype ==# 'c' || &filetype ==# 'c' || &filetype==#'js'
        let top_com="/*"
        let bottom_com="*/"
    elseif &filetype ==# 'python' || &filetype ==# 'bash'
        let top_com="'''"
        let bottom_com="'''"
    endif

    let top_pos=getpos("'<")[1]
    let bottom_pos=getpos("'>")[1]
    call cursor(top_pos, 1)
    exe "normal!O" . top_com
    call cursor(bottom_pos+1, 1)
    exe "normal!o" . bottom_com
endfunction

nnoremap  :call MyNComment()
vnoremap  :call MyVComment()

" End my plugin

" set background=light
" colorscheme material
" colorscheme materialbox
" colorscheme minimalist
" colorscheme meta5
" colorscheme wolfpack
colorscheme apprentice
