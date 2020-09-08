local root = "/Users/manc568/workspace/installs/pybind11"
prepend_path("CPLUS_INCLUDE_PATH", pathJoin(root, include))
setenv("pybind11_DIR", root)
