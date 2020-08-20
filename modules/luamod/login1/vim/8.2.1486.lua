local install_home = "/autofs/nccsopen-svm1_home/manc568/installs/vim-v8.2.1486"
prepend_path("PATH", pathJoin(install_home, "bin"))
prepend_path("MANPATH", pathJoin(install_home, "share", "man"))
