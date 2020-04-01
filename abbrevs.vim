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
iabbrev dbg #ifdef __DEBUG#endifk
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

let g:c_std_libs = [
\   "assert.h",
\   "complex.h",
\   "ctype.h",
\   "errno.h",
\   "fenv.h",
\   "float.h",
\   "inttypes.h",
\   "iso646.h",
\   "limits.h",
\   "locale.h",
\   "math.h",
\   "setjmp.h",
\   "signal.h",
\   "stdalign.h",
\   "stdarg.h",
\   "stdatomic.h",
\   "stdbool.h",
\   "stddef.h",
\   "stdint.h",
\   "stdio.h",
\   "stdlib.h",
\   "stdnoreturn.h",
\   "string.h",
\   "tgmath.h",
\   "threads.h",
\   "time.h",
\   "uchar.h",
\   "wchar.h",
\   "wctype.h",
\   "concepts",
\   "coroutine",
\   "cstdlib",
\   "csignal",
\   "csetjmp",
\   "cstdarg",
\   "typeinfo",
\   "typeindex",
\   "type_traits",
\   "bitset",
\   "functional",
\   "utility",
\   "ctime",
\   "chrono",
\   "cstddef",
\   "initializer_list",
\   "tuple",
\   "any",
\   "optional",
\   "variant",
\   "compare",
\   "version",
\   "new",
\   "memory",
\   "scoped_allocator",
\   "memory_resource",
\   "climits",
\   "cfloat",
\   "cstdint",
\   "cinttypes",
\   "limits",
\   "exception",
\   "stdexcept",
\   "cassert",
\   "system_error",
\   "cerrno",
\   "contract",
\   "cctype",
\   "cwctype",
\   "cstring",
\   "cwchar",
\   "cuchar",
\   "string",
\   "string_view",
\   "charconv",
\   "array",
\   "vector",
\   "deque",
\   "list",
\   "forward_list",
\   "set",
\   "map",
\   "unordered_set",
\   "unordered_map",
\   "stack",
\   "queue",
\   "span",
\   "iterator",
\   "ranges",
\   "algorithm",
\   "cmath",
\   "complex",
\   "valarray",
\   "random",
\   "numeric",
\   "ratio",
\   "cfenv",
\   "bit",
\   "iosfwd",
\   "ios",
\   "istream",
\   "ostream",
\   "iostream",
\   "fstream",
\   "sstream",
\   "syncstream",
\   "strstream",
\   "iomanip",
\   "streambuf",
\   "cstdio",
\   "locale",
\   "clocale",
\   "codecvt",
\   "regex",
\   "atomic",
\   "thread",
\   "mutex",
\   "shared_mutex",
\   "future",
\   "condition_variable",
\   "filesystem",
\   "experimental/filesystem",
\   "experimental/algorithm",
\   "experimental/execution_policy",
\   "experimental/exception_list",
\   "experimental/numeric",
\   "experimental/algorithm",
\   "experimental/any",
\   "experimental/chrono",
\   "experimental/deque",
\   "experimental/forward_list",
\   "experimental/future",
\   "experimental/list",
\   "experimental/functional",
\   "experimental/map",
\   "experimental/memory",
\   "experimental/memory_resource",
\   "experimental/optional",
\   "experimental/ratio",
\   "experimental/regex",
\   "experimental/set",
\   "experimental/string",
\   "experimental/string_view",
\   "experimental/system_error",
\   "experimental/tuple",
\   "experimental/type_traits",
\   "experimental/unordered_map",
\   "experimental/unordered_set",
\   "experimental/utility",
\   "experimental/vector",
\   "experimental/atomic",
\   "experimental/barrier",
\   "experimental/future",
\   "experimental/latch",
\   "experimental/algorithm",
\   "experimental/array",
\   "experimental/deque",
\   "experimental/forward_list",
\   "experimental/functional",
\   "experimental/iterator",
\   "experimental/list",
\   "experimental/map",
\   "experimental/memory",
\   "experimental/numeric",
\   "experimental/propagate_const",
\   "experimental/random",
\   "experimental/set",
\   "experimental/source_location",
\   "experimental/string",
\   "experimental/type_traits",
\   "experimental/unordered_map",
\   "experimental/unordered_set",
\   "experimental/vector",
\   "experimental/ranges/algorithm",
\   "experimental/ranges/concepts",
\   "experimental/ranges/functional",
\   "experimental/ranges/iterator",
\   "experimental/ranges/random",
\   "experimental/ranges/range",
\   "experimental/ranges/tuple",
\   "experimental/ranges/type_traits",
\   "experimental/ranges/utility",
\   "assert.h",
\   "ctype.h",
\   "errno.h",
\   "fenv.h",
\   "float.h",
\   "inttypes.h",
\   "limits.h",
\   "locale.h",
\   "math.h",
\   "setjmp.h",
\   "signal.h",
\   "stdarg.h",
\   "stddef.h",
\   "stdint.h",
\   "stdio.h",
\   "stdlib.h",
\   "string.h",
\   "time.h",
\   "uchar.h",
\   "wchar.h",
\   "wctype.h",
\   ]

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

function! Include()

    let exe_str = 'normal! '

    call inputsave()
    let prompt = 'Enter include: '
    let headers = []
    let header = input(prompt, '', 'file')
    while header != ''
        call add(headers, header)
        let header = input(prompt, '', 'file')
    endwhile
    echo 'Input ' . len(headers) . ' headers/includes.'
    call inputrestore()

    for h in headers
        if &filetype ==# 'python'
            let pre = 'import '
            let post = ''
        elseif &filetype ==# 'c' || &filetype ==# 'cpp'
            if &filetype ==# 'c' && (index(g:c_std_libs, h) >= 0)
                let pre = '#include <'
                let post = '>'
            else
                let pre = '#include "'
                let post = '"'
            endif
        elseif &filetype ==# 'php'
            let pre = 'use \'
            let post = ';'
        endif
        let exe_str .= 'i'. pre . h . post . ''
    endfor

    exe exe_str
endfunction

function! CPrintArr(iter)
    call inputsave()
    let length = input('Length: ')
    let name = input('Array name: ')
    call inputrestore()

    let s = 'normal! '
    let s .= 'ifor ('.a:iter.'=0; '.a:iter.'<'
    let s .= length.'; '.a:iter.'++)'
    let s .= 'fprintf(stdout, "'.name.'[%i] = %i\n"'
    let s .= ', '.a:iter.', ' . name . '['.a:iter.']);'

    exe s
endfunction
