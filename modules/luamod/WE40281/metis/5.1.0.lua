local home = "/usr/local/Cellar/metis/5.1.0"
prepend_path("PATH", pathJoin(home, "bin"))
prepend_path("C_INCLUE_PATH", pathJoin(home, "include"))
prepend_path("CPLUS_INCLUE_PATH", pathJoin(home, "include"))
prepend_path("LD_LIBRARY_PATH", pathJoin(home, "lib"))
setenv("METIS_DIR", home)
