help([[

NodeJS v14.5.0

]])
local nodehome = "/Users/manc568/workspace/installs/node-v14.5.0-darwin-x64"
prepend_path("PATH", pathJoin(nodehome, "bin"))
prepend_path("LD_LIBRARY_PATH", pathJoin(nodehome, "lib"))
prepend_path("MANPATH", pathJoin(nodehome, "share/man"))
