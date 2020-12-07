local home = '/opt/local/libexec/llvm-10/'
local spackhome = '/Users/manc568/workspace/spack/share/spack/modules/darwin-catalina-skylake'

conflict('appleclang')

prepend_path('PATH', pathJoin(home, 'bin'))

prepend_path('LD_LIBRARY_PATH', pathJoin(home, 'lib'))
prepend_path('LD_LIBRARY_PATH', pathJoin(home, 'libexec'))

prepend_path('DYLD_LIBRARY_PATH', pathJoin(home, 'lib'))
prepend_path('DYLD_LIBRARY_PATH', pathJoin(home, 'libexec'))

prepend_path('MODULEPATH', spackhome)
