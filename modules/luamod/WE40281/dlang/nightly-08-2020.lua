family("dlang_compiler")
local home =  "/Users/manc568/workspace/installs/dmd2-nightly-8-2020/"
prepend_path("PATH", pathJoin(home, "/osx/bin"))
prepend_path("LD_LIBRARY_PATH", pathJoin(home, "/osx/lib"))
prepend_path("MANPATH", pathJoin(home, "man"))
