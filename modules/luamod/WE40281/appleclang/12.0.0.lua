local home = '/usr/bin'
local spackhome = '/Users/manc568/workspace/spack/share/spack/modules/darwin-catalina-x86_64'

conflict('clang')

setenv('CC', '/usr/bin/clang')
setenv('CXX', '/usr/bin/clang++')
prepend_path('MODULEPATH', spackhome)
