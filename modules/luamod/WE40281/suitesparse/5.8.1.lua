--
-- Installed from brew
--

local home = "/usr/local/Cellar/suite-sparse/5.8.1"
prepend_path("PATH", pathJoin(home, "bin"))
prepend_path("LD_LIBRARY_PATH", pathJoin(home, "lib"))
prepend_path("C_INCLUDE_PATH", pathJoin(home, "include"))
prepend_path("CPLUS_INCLUDE_PATH", pathJoin(home, "include"))
setenv("SUITESPARSE_DIR", home)
