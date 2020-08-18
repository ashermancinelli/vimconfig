local goroot = "/Users/manc568/workspace/installs/go-v1.14.6"
setenv("GOROOT", goroot)
prepend_path("PATH", pathJoin(goroot, "bin"))
