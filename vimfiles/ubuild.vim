
function! UBuild_VerifyConfig()
  let config = getcwd() . '/.ubuild.vim'

  if filereadable(config)
    echom "Sourced " . config
    execute "source " . config
  else
    echom 'Could not find config file ' . config
    return 1
  endif

  if !exists("g:ubuild_remote") 
      \ || !exists("g:ubuild_remote_directory") 
      \ || !exists("g:ubuild_local_directory")
      \ || !exists("g:ubuild_build_commands")
      \ || !exists("g:ubuild_test_commands")
    echom "Could not find all needed ubuild parameters."
    echom "Expected:"
    echom "let g:ubuild_remote = ..."
    echom "let g:ubuild_remote_directory = ..."
    echom "let g:ubuild_local_directory = ..."
    echom "let g:ubuild_build_commands = [ ... ]"
    echom "let g:ubuild_test_commands = [ ... ]"
    return 1
  endif

  return 0
endfunction

function! UBuild_Sync(...)

  if UBuild_VerifyConfig() == 1
    return 1
  endif

  let rsync_command = 'rsync -aP ' . g:ubuild_local_directory . ' '
    \ . g:ubuild_remote . ':' . g:ubuild_remote_directory . '\n'

  echom 'Syncing to '. g:ubuild_remote

  let t = term_start('bash', { "term_finish": "close" })
  call term_sendkeys(t, rsync_command . "\<cr>exit\<cr>")

endfunction

function! UBuild_Build(...)

  if UBuild_VerifyConfig() == 1
    return 1
  endif

  let build_command = join(g:ubuild_build_commands, "\<cr>") . "\<cr>"

  let t = term_start('bash', { "term_finish": "close" })
  call term_sendkeys(t, build_command)

endfunction

function! UBuild_Test(...)

  if UBuild_VerifyConfig() == 1
    return 1
  endif

  let test_command = join(g:ubuild_test_commands, "\<cr>") . "\<cr>"

  let t = term_start('bash', { "term_finish": "close" })
  call term_sendkeys(t, test_command)

endfunction

nnoremap <c-x><c-s> :call UBuild_Sync()<cr>
nnoremap <c-x><c-b> :call UBuild_Build()<cr>
nnoremap <c-x><c-t> :call UBuild_Test()<cr>
