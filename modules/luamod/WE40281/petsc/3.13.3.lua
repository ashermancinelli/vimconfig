family("library")

help([[

Configures the environment for using Petsc.

]])

local petsc_dir = "/Users/manc568/workspace/installs/petsc-v3.13.4/"

setenv("CXX", "/usr/local/bin/g++-8")
setenv("CC", "/usr/local/bin/gcc-8")
setenv("FC", "/usr/local/bin/gfortran-8")
setenv("PETSC_DIR", petsc_dir)
setenv("PETSC_ARCH", "arch-darwin-c-debug")
prepend_path("PATH", pathJoin(petsc_dir, "bin"))
prepend_path("LD_LIBRARY_PATH", pathJoin(petsc_dir, "lib"))
