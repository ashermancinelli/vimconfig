
local home = "/Users/manc568/workspace/installs/sundials/v5.3.0/"
prepend_path("LD_LIBRARY_PATH", pathJoin(home, "lib"))
prepend_path("C_INCLUDE_PATH", pathJoin(home, "include"))
prepend_path("CPLUS_INCLUDE_PATH", pathJoin(home, "include"))
setenv("SUNDIALS_DIR", home)
setenv("SUNDIALS_ROOT_DIR", home)
