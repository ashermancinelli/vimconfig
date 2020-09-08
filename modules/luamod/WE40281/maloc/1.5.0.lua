local root = "/Users/manc568/workspace/installs/maloc/1.5.0"
prepend_path("MALOC_ROOT", root)
prepend_path("LD_LIBRARY_PATH", pathJoin(root, "lib"))
prepend_path("C_INCLUDE_PATH", pathJoin(root, "include"))
prepend_path("CPLUS_INCLUDE_PATH", pathJoin(root, "include"))
prepend_path("CPATH", pathJoin(root, "include"))
