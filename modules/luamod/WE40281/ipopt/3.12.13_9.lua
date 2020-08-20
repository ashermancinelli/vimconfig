local home = "/usr/local/Cellar/ipopt/3.12.13_9"
prepend_path("C_INCLUDE_PATH", pathJoin(home, "include"))
prepend_path("CPLUS_INCLUDE_PATH", pathJoin(home, "include"))
prepend_path("LD_LIBRARY_PATH", pathJoin(home, "lib"))
setenv("IPOPT_DIR", home)
