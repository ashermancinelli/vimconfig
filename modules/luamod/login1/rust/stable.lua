local rust_home = "/autofs/nccsopen-svm1_home/manc568/installs/rust/stable/"
setenv("CARGO_HOME", pathJoin(rust_home, "cargo_home"))
setenv("RUSTUP_HOME", pathJoin(rust_home, "rustup_home"))
prepend_path("PATH", pathJoin(rust_home, "cargo_home", "bin"))
