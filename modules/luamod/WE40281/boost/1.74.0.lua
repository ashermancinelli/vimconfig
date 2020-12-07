local home = '/usr/local/opt/boost/';
setenv("BOOST_ROOT", home)
prepend_path("CPLUS_INCLUDE_PATH", pathJoin(home, "include"))
prepend_path("LD_LIBRARY_PATH", pathJoin(home, "lib"))
prepend_path("DYLD_LIBRARY_PATH", pathJoin(home, "lib"))
