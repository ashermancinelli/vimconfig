conflict("gcc")
pushenv("CC", "clang")
pushenv("CXX", "clang++")
prepend_path("PATH", "/usr/local/Cellar/open-mpi/4.0.4_1/bin/mpicc/bin")
prepend_path("LD_LIBRARY_PATH", "/usr/local/Cellar/open-mpi/4.0.4_1/bin/mpicc/lib")
