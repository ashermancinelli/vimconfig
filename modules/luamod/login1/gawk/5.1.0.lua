local root = "/autofs/nccsopen-svm1_home/manc568/installs/gawk/5.1.0/"
prepend_path("PATH", pathJoin(root, "bin"))
prepend_path("LD_LIBRARY_PATH", pathJoin(root, "lib"))
prepend_path("LD_LIBRARY_PATH", pathJoin(root, "libexec"))
prepend_path("MANPATH", pathJoin(root, "share", "man"))
setenv("C_INCLUDE_DIR", pathJoin(root, "include"))
setenv("CPLUS_INCLUDE_DIR", pathJoin(root, "include"))
