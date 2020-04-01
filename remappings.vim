" 
" Always keep the cursor in the center of the screen
nnoremap j jzz
nnoremap k kzz
nnoremap n nzz
nnoremap G Gzz
nnoremap gg ggzz

" Better window pane movement: c-[hjkl] for window movement
" instead of c-w c-[hjkl]
nnoremap <c-h> <c-w><c-h>
nnoremap <c-j> <c-w><c-j>
nnoremap <c-k> <c-w><c-k>
nnoremap <c-l> <c-w><c-l>

nnoremap <c-g> :Goyo<Enter>

" Better tab navigation
nnoremap tn gt
nnoremap tp gT
nnoremap tc :tabclose<Enter>

" Easy nerdtree binding
nnoremap T :NERDTree<Enter>

" Use spelling when in a spelling-dependent context
autocmd Filetype txt setlocal spell
autocmd Filetype md setlocal spell
autocmd Filetype tex setlocal spell
autocmd Filetype rs set makeprg=cargo\ build

" Configuring folding
set foldmethod=manual
set nofoldenable

" Relative line numberings, except for the current line which
" shows the absolute line number
set number
set relativenumber

" number of colors
set t_Co=256

" Tabbing
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

function! TODOList()
    let n = 0
    call inputrestore()

    while 1
        let item = input('(' . n . ') TODO item> ')
        if item == ''
            break
        endif
        let n += 1
        call append('.', ['- [ ] ' . item, ''])
    endwhile
    call inputsave()
endfunction

function! TODOListToggle()
    call setline('.', substitute(getline('.'), '\[X\]', '[+]', ''))
    call setline('.', substitute(getline('.'), '\[ \]', '[-]', ''))
    call setline('.', substitute(getline('.'), '\[+\]', '[ ]', ''))
    call setline('.', substitute(getline('.'), '\[-\]', '[X]', ''))
endfunction

nnoremap <c-t><c-t> :call TODOListToggle()
nnoremap <c-t>n :call TODOList()

