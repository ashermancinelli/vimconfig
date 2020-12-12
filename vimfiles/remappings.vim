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

" Map <c-a> to accept suggestion and exit to normal mode
inoremap <c-a> <c-y><esc>
inoremap <c-e> <esc>:w<enter>l

nnoremap <c-g> :Goyo<Enter>

" Better buffer navigation "
nnoremap <c-n> :bnext \| ls<cr>
nnoremap <c-p> :bprevious \| ls<cr>

" Bracket completion "
inoremap { {}<left>
inoremap {<CR> {<CR>}<ESC>O
inoremap {;<CR> {<CR>};<ESC>O

" Better javadoc comments "
autocmd FileType c,cpp,java inoreabbrev <buffer> /** /**<CR>/<Up>

" <c-]> takes you to the tag definition, so naturally
" <c-[> should take you back to the location from
" which you tried to find the definition
func! GenTags()
  exe "!ctags -R --c++-kinds=+p --extra=+q --fields=+iaS ."
  exe "echom 'Generated new ctags database.'"
endfunc

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

" :make runs cargo build when in rust
autocmd Filetype rs set makeprg=cargo\ build

" Set filetypes in cuda source/headers
au BufNewFile,BufRead *.cu set ft=cuda
au BufNewFile,BufRead *.cuh set ft=cuda

" Configuring folding
set foldmethod=manual
set nofoldenable

" Relative line numberings, except for the current line which
" shows the absolute line number
set number
" set relativenumber

" number of colors
set t_Co=256

" Tabbing
" show existing tab with 4 spaces width
set tabstop=2

" when indenting with '>', use 4 spaces width
set shiftwidth=2

" On pressing tab, insert 4 spaces
set expandtab
set softtabstop=2

set backspace=indent,eol,start
set autoindent
set ruler
set showcmd
