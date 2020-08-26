local home = "/Users/manc568/workspace/installs/gawk/5.1.0"
prepend_path("PATH", pathJoin(home, "bin"))
prepend_path("LD_LIBRARY_PATH", pathJoin(home, "lib"))
prepend_path("LD_LIBRARY_PATH", pathJoin(home, "libexec"))
prepend_path("C_INCLUDE_PATH", pathJoin(home, "include"))
prepend_path("CPLUS_INCLUDE_PATH", pathJoin(home, "include"))
