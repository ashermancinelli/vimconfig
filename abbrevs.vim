" Asher Mancinelli
"
" Some helpful abbreviations:
"
"
" Python abbreviations
iabbrev scipy <BS>import pandas as pdimport matplotlib.pyplot as pltimport numpy as np
iabbrev osxplt <BS>import matplotlibmatplotlib.use('TkAgg')import matplotlib.pyplot as plt

" jinja bracket
iabbrev `[ {% %}bhi
" think 'jinja variable'
iabbrev `v {{ }}bhi
" think 'jinja block'
iabbrev `b {% block block_name %}{% endblock %}?block_nameh

" Bash / shell abbreviations
iabbrev sbatchh #!/usr/bin/env bash#SBATCH -t 1:00:00#SBATCH -N 1#SBATCH -n 1#SBATCH -p phi#SBATCH -o slurm.%j.out#SBATCH -e slurm.%j.err

" C-Style abbreviations
iabbrev printarr for (i=0; i<arr_len; i++)fprintf(stdout, "arr[%i] = %i\n", i, arr[i]);?arr_len0/arr_len\\|arrh
iabbrev dbg #ifdef __DEBUG#endifk
iabbrev inc #include <>i
iabbrev incall #include <stdio.h>#include <string.h>#include <stdlib.h>#include <unistd.h>
iabbrev cmpi :read ~/.vim/templates/mpi_template.c/###C
iabbrev chead ggO#ifndef ####define ###Go#endifgg:%s/###/

" Makefiles
iabbrev makec :read ~/.vim/templates/c_template.Makefilegg

" Php
iabbrev phpp <?php ?>bhi
" think 'php for each in [h]ash'
iabbrev phpfh <?php foreach($array as $key=>$value): ?><?php endforeach; ?>?array0/array\\|key\\|valueh
" think 'php for [e]ach'
iabbrev phpfe <?php foreach($array as $value): ?><?php endforeach; ?>?array0/array\\|key\\|valueh

" Misc abbreviations
iabbrev htmll k:read ~/.vim/templates/template.html/titlevith
inoreabbrev @@g ashermancinelli@gmail.com
inoreabbrev @@p asher.mancinelli@pnnl.gov
iabbrev teh the

function! SyntaxAwareFor(iterator, cli)
    let c_types = ['c', "cpp", "php", "js", "rust"]

    if a:cli | else
        call getchar()
    endif

    let cmd_str = 'normal! ifor '

    call inputsave()
    if (index(c_types, &filetype) >= 0)
        let l = input('Lower bound: ')
        let h = input('Upper bound: ')
        let it = input('Delta: ', a:iterator.'++')
        " c style for loop:
        let cmd_str .= '(' . a:iterator . '=' . l . '; ' . a:iterator . '<' . h . '; ' . it . '){// bodycc}?body'
    elseif (&filetype ==# 'python')
        let cmd_str .= a:iterator . " in thing:pass?thingk/func\\|thing\\|passh"
    elseif (&filetype ==# 'sh')
        let aname = input('Array name: ')
        let cmd_str .= a:iterator." in \"${".aname."[@]}\"doecho \$".a:iterator."done"
    endif
    call inputrestore()

    exe cmd_str
endfunction

function! SyntaxAwareMain()
    if (&filetype ==# 'c')
        exe "normal! :read ~/.vim/templates/template.c/return"
    elseif (&filetype ==# 'python')
        exe "normal! :read ~/.vim/templates/template.py/pass"
    endif
endfunction

function! PythonClass()
    call inputsave()
    let name = input('Class name: ')
    let cmd_str = "normal! iclass " . name . ":"
 
    let init = input('def __init__(self, ')
    if init == ''
        let cmd_str .= "def __init__(self):pass"
    else
        let cmd_str .= "def __init__(self, " . init . "):"
        let args = split(init, ',')
        for i in range(len(args))
            " Remove default values
            let args[i] = substitute(args[i], '\v\=.+', '', 'g')
            " Remove whitespace
            let args[i] = substitute(args[i], ' ', '', 'g')
        endfor
        for i in args
            let cmd_str .= 'self.' . i . ' = ' . i . ''
        endfor
    endif

    let first = 1
    let method = input('Enter method name (blank for none): ')
    while method != ''
        let cmd_str .= 'def ' . method . '('
        let m_args = input(method . '(', 'self')
        let cmd_str .= m_args . '):'
        if first && init != ''
            let cmd_str .= '<<'
            let first -= 1
        endif
        let cmd_str .= 'opass'
        let method = input('Enter method name (blank for none): ')
    endwhile
    call inputrestore()

    exe cmd_str
endfunction

noreabbrev forr :call SyntaxAwareFor('i', 1)
noreabbrev fori :call SyntaxAwareFor('i', 1)
noreabbrev forj :call SyntaxAwareFor('j', 1)
noreabbrev fork :call SyntaxAwareFor('k', 1)
noreabbrev forl :call SyntaxAwareFor('l', 1)

cnoreabbrev forr call SyntaxAwareFor('i', 0)
cnoreabbrev fori call SyntaxAwareFor('i', 0)
cnoreabbrev forj call SyntaxAwareFor('j', 0)
cnoreabbrev fork call SyntaxAwareFor('k', 0)
cnoreabbrev forl call SyntaxAwareFor('l', 0)
cnoreabbrev main call SyntaxAwareMain()

noreabbrev pyclass :call PythonClass()
