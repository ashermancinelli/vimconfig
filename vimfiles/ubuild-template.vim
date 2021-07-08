let g:ubuild_local_directory = "./"
let g:ubuild_remote_directory = "/people/manc568/workspace/haero"
let g:ubuild_remote = "deception"

let g:ubuild_build_commands = [
  \"ssh deception",
  \"ssh dc001.local",
  \"cd /scratch/manc568",
  \"source ~/workspace/haero/machines/marianas.pnl.gov.sh",
  \"cmake --build . --target mam_rename_fprocess_tests --parallel `nproc`",
  \]

let g:ubuild_sync_ignore = [
  \ '.git',
  \ 'ext',
  \]

let g:ubuild_test_commands = [
  \"ssh deception",
  \"ssh dc001.local",
  \"source ~/workspace/haero/machines/marianas.pnl.gov.sh",
  \"cd /scratch/manc568",
  \"mpirun -n 1 ./haero/tests/mam_rename_fprocess_tests",
  \]
