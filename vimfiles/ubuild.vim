
let g:_ubuild_term_id = -1
let g:_ubuild_tab_id = -1

" Wraps private variables into an object of handles
function! UBuild_CreateTabbedTerminalObject()
  let terminal_handle = g:_ubuild_term_id
  let tab_id = g:_ubuild_tab_id
  echom 'Creating tabbed term obj'
  echom 'tab_id = ' . tab_id
  echom 'terminal_handle = ' . terminal_handle
  return {
    \ 'terminal_handle': terminal_handle,
    \ 'tab_id': tab_id,
  \ }
endfunction

" Create a terminal in a new window and return an object with fields needed to
" operate on them.
function! UBuild_GetTabbedTerminal(tab_name)

  " Get current tab number
  let start_tab = tabpagenr()

  " Craeate a new tab to be consumed by the terminal at the end
  exe "$tabnew"
  let tab_id = tabpagenr('$')

  " Create the terminal in the new tab, taking up the entire window
  let term_handle = term_start('bash', {
        \ 'term_finish': 'close',
        \ 'curwin': 1,
        \ 'term_name': a:tab_name,
        \ })

  " Return to original tab while the commands run in the background
  exe 'tabnext ' . start_tab

  return { 'terminal_handle': term_handle, 'tab_id': tab_id }
endfunction

" Ensure that a file _.ubuild.vim_ exists in the current working directory and 
" that all the needed variables are set.
"
" \returns 1 on failure, 0 on success
function! UBuild_VerifyConfig()
  let config = getcwd() . '/.ubuild.json'

  if !filereadable(config)
    echom 'Could not find config file ' . config
    return 1
  endif

  let json_string = join(readfile(config))
  let config = json_decode(json_string)

  let required_vars = [
        \ "remote_host" ,
        \ "remote_directory" ,
        \ "local_directory",
        \ "connect_commands",
        \ "configure_commands",
        \ "build_commands",
        \ "test_commands",
        \ ]

  for v in required_vars
    if !has_key(config, v)
      echom "Could not find required UBuild parameter '".v."'."
      return 1
    endif
  endfor

  let g:ubuild_remote = config["remote_host"]
  let g:ubuild_remote_directory = config["remote_directory"]
  let g:ubuild_local_directory = config["local_directory"]
  let g:ubuild_connect_commands = config["connect_commands"]
  let g:ubuild_configure_commands = config["configure_commands"]
  let g:ubuild_build_commands = config["build_commands"]
  let g:ubuild_test_commands = config["test_commands"]
  let g:ubuild_sync_ignore = config["sync_ignore"]

  return 0
endfunction

" Sync the source directory with the remote directory in a new window.
function! UBuild_Sync(...)

  if UBuild_VerifyConfig() == 1
    return 1
  endif

  let term_handles = UBuild_GetTabbedTerminal('UBuild Sync')
  let term_id = term_handles.terminal_handle

  let rsync_exclude = ''
  if exists("g:ubuild_sync_ignore")
    if len(g:ubuild_sync_ignore) > 0
      let rsync_exclude = ' --exclude=' .
        \join(g:ubuild_sync_ignore, ' --exclude=') . ' '
    endif
  endif

  let rsync_command = 'rsync -aP ' . rsync_exclude . g:ubuild_local_directory . ' '
    \ . g:ubuild_remote . ':' . g:ubuild_remote_directory

  echom 'Using rsync command: ' . rsync_command

  call term_wait(term_id)

  call term_sendkeys(term_id, rsync_command . "\<cr>exit\<cr>")

  call term_wait(term_id)

endfunction

" Static variables for UBuild_Build
let g:_ubuild_persistent_term_id = -1
let g:_ubuild_persistent_tab_id = -1

function! UBuild_SendCommandsToPersistentTerminal(title, commands)
  if UBuild_VerifyConfig() == 1
    return 1
  endif

  let command_string = join(a:commands, "\<cr>") . "\<cr>"

  if g:_ubuild_persistent_term_id == -1 || g:_ubuild_persistent_tab_id == -1
    let term_handles = UBuild_GetTabbedTerminal('UBuild')
    let g:_ubuild_persistent_term_id = term_handles.terminal_handle
    let g:_ubuild_persistent_tab_id = term_handles.tab_id
  endif

  let term_id = g:_ubuild_persistent_term_id

  call term_wait(term_id)

  call term_sendkeys(term_id, command_string)

  call term_wait(term_id)

  return 0

endfunction

function! UBuild_Connect()
  if UBuild_VerifyConfig() == 1
    return 1
  endif
  return UBuild_SendCommandsToPersistentTerminal(
        \ 'UBuild Connect', 
        \ g:ubuild_connect_commands
        \ )
endfunction

function! UBuild_Configure()
  if UBuild_VerifyConfig() == 1
    return 1
  endif
  return UBuild_SendCommandsToPersistentTerminal(
        \ 'UBuild Configure', 
        \ g:ubuild_configure_commands
        \ )
endfunction

function! UBuild_Build()
  if UBuild_VerifyConfig() == 1
    return 1
  endif
  return UBuild_SendCommandsToPersistentTerminal(
        \ 'UBuild Build', 
        \ g:ubuild_build_commands
        \ )
endfunction

function! UBuild_Test()
  if UBuild_VerifyConfig() == 1
    return 1
  endif
  return UBuild_SendCommandsToPersistentTerminal(
        \ 'UBuild Test', 
        \ g:ubuild_test_commands
        \ )
endfunction

nnoremap <c-x><c-s> :call UBuild_Sync()<cr>
nnoremap <c-x><c-a> :call UBuild_Connect()<cr>
nnoremap <c-x><c-c> :call UBuild_Configure()<cr>
nnoremap <c-x><c-b> :call UBuild_Build()<cr>
nnoremap <c-x><c-t> :call UBuild_Test()<cr>
