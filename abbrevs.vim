" Asher Mancinelli
"
" Some helpful abbreviations:
"
"
" Python abbreviations
iabbrev pyfn def func(params):pass?funck/func\\|params\\|passh
iabbrev pyfor for i in thing:pass?thingk/func\\|thing\\|passh
iabbrev pyclass class Thing:'''Some docstring here'''def __init__(self, param):self.param = paramdef method(self, param):pass?Thing0/Thing\\|Some\\|param\\|methodh
iabbrev pymain :read ~/.vim/template.py/###C
iabbrev scipy <BS>import pandas as pdimport matplotlib.pyplot as pltimport numpy as np
iabbrev osxplt <BS>import matplotlibmatplotlib.use('TkAgg')import matplotlib.pyplot as plt

" Bash / shell abbreviations
iabbrev sbatch #!/usr/bin/env bash#SBATCH -t 1:00:00#SBATCH -N 1#SBATCH -n 1#SBATCH -p phi#SBATCH -o slurm.%j.out#SBATCH -e slurm.%j.err
iabbrev bashfor for i in "${arrayName[@]}"douse i heredone?usev/re

" C-Style abbreviations
iabbrev fori for (i=low; i<high; i++){// bodycc}?low0/low\\|high\\|bodyh
iabbrev forj for (j=low; j<high; j++){// bodycc}?low0/low\\|high\\|bodyh
iabbrev fork for (k=low; k<high; k++){// bodycc}?low0/low\\|high\\|bodyh
iabbrev printarr for (i=0; i<arr_len; i++)fprintf(stdout, "arr[%i] = %i\n", i, arr[i]);?arr_len0/arr_len\\|arrh
iabbrev cfn void name(){return;}?namek/void\\|name\\|return
iabbrev cmain :read ~/.vim/template.c/###C
iabbrev dbg #ifdef __DEBUG#endifk
iabbrev inc #include <>
iabbrev incall #include <stdio.h>#include <string.h>#include <stdlib.h>#include <unistd.h>
iabbrev csign /*Asher Mancinelliasher.mancinelli@pnnl.gov/
iabbrev cmpi :read ~/.vim/mpi_template.c/###C
iabbrev header ggO#ifndef ####define ###Go#endifgg:%s/###/

" Misc abbreviations
iabbrev htmll k:read ~/.vim/template.html/titlevith
inoreabbrev @g ashermancinelli@gmail.com
inoreabbrev @p asher.mancinelli@pnnl.gov
