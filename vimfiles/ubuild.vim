

" Static variables for ubuild#
if !exists("g:_ubuild_persistent_term_id")
  let g:_ubuild_persistent_term_id = -1
endif

" Call term_sendkeys and wait on results before continuing
"
" \param term_id[in] int ID of the terminal instance
" \param command[in] string String-ified command to be run in terminal
function! ubuild#term_sendkeys_await(term_id, command)
  call term_wait(a:term_id)

  call term_sendkeys(a:term_id, a:command)

  call term_wait(a:term_id)
endfunction

" Wraps private variables into an object of handles.
"
" \returns object with keys _terminal_handle_
function! ubuild#create_tabbed_terminal_object()
  let terminal_handle = g:_ubuild_persistent_term_id
  return {
    \ 'terminal_handle': terminal_handle,
  \ }
endfunction

" Create a _.ubuild.json_ file in the current working directory using the
" template configuration file installed alongside ubuild.
function! ubuild#create_config_template()
  let config_file = ubuild#get_config_file(g:false)
  let template_path = getenv('HOME') . "/.vim/ubuild-template.json"
  let config_template = readfile(template_path)
  call writefile(config_template, config_file)
endfunction

" Create a terminal in a new window and return an object with fields needed to
" operate on them.
"
" \param tab_name[in] string Name to be used for the newly created tab
" \param minimal[in] bool Should use minimal shell?
function! ubuild#get_tabbed_terminal(tab_name, ...)

  let shell = &shell

  if a:0 > 0
    let shell = 'env -i ' . &shell . ' --noprofile --norc'
  endif

  " Create the terminal in the bottom right of the current window
  rightbelow let term_handle = term_start(shell, {
        \ 'term_finish': 'close',
        \ 'term_name': a:tab_name,
        \ 'term_rows': 8,
        \ })

  return { 'terminal_handle': term_handle }
endfunction

" Get path to configuration file.
"
" \param check[in] bool Should check for existence of config file?
function! ubuild#get_config_file(...)
  let config = getcwd() . '/.ubuild.json'

  let check = 1
  if a:0 > 0
    let check = a:1
  endif

  if check && !filereadable(config)
    throw 'Could not find config file ' . config
  endif

  return config
endfunction

" Ensure that a file _.ubuild.vim_ exists in the current working directory and 
" that all the needed variables are set.
function! ubuild#verify_config()
  let config = ubuild#get_config_file()

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
      throw "Could not find required UBuild parameter '".v."'."
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

endfunction

" Use terminal with buffer ID to send build/test commands to.
"
" \param buffer_id[in] string ID of buffer to use for remote commands
function! ubuild#use_terminal_with_buffer_id(buffer_id)
  let g:_ubuild_persistent_term_id = a:buffer_id
endf

" Build rsync command used to sync with build server.
"
" \returns string
function! ubuild#build_rsync_command()
  let rsync_exclude = ''
  if exists("g:ubuild_sync_ignore")
    if len(g:ubuild_sync_ignore) > 0
      let rsync_exclude = ' --exclude=' .
        \join(g:ubuild_sync_ignore, ' --exclude=') . ' '
    endif
  endif

  let rsync_command = 'rsync -aP ' . rsync_exclude . g:ubuild_local_directory . ' '
    \ . g:ubuild_remote . ':' . g:ubuild_remote_directory . "\<cr>exit\<cr>"

  return rsync_command
endfunction

" Sync the source directory with the remote directory in a new window.
function! ubuild#sync()

  call ubuild#verify_config()

  let rsync_command = ubuild#build_rsync_command()

  let init_tab = tabpagenr()
  execute '$tabnew'
  
  let minimal_shell = 'env -i ' . &shell . ' --noprofile --norc'
  let term_id = term_start(minimal_shell, {
        \   'term_finish': 'close',
        \   'curwin': 1
        \ })
  call ubuild#term_sendkeys_await(term_id, rsync_command)

  exe "tabnext " . init_tab

endfunction

" Send commands to existing terminal used by ubuild.
"
" \param title[in] string Title of tab while command is running.
" \param commands[in] list[string] Commands to be run in the terminal instance
function! ubuild#send_commands_to_persistent_terminal(title, commands)
  call ubuild#verify_config()

  let command_string = join(a:commands, "\<cr>") . "\<cr>"

  if g:_ubuild_persistent_term_id == -1
    let term_handles = ubuild#get_tabbed_terminal('UBuild')
    let g:_ubuild_persistent_term_id = term_handles.terminal_handle
  endif

  let term_id = g:_ubuild_persistent_term_id

  call ubuild#term_sendkeys_await(term_id, command_string)

endfunction

" Connect to remote build server and instantiate terminal for configure,
" build, and test commands to use.
function! ubuild#connect()
  echo 'Connecting to ' . g:ubuild_remote
  call ubuild#verify_config()
  call ubuild#send_commands_to_persistent_terminal(
        \ 'UBuild Connect', 
        \ g:ubuild_connect_commands
        \ )
endfunction

" Configure build in persistent terminal
function! ubuild#configure()
  call ubuild#verify_config()
  echo 'Configuring on ' . g:ubuild_remote
  call ubuild#send_commands_to_persistent_terminal(
        \ 'UBuild Configure', 
        \ g:ubuild_configure_commands
        \ )
endfunction

" Run build commands in persistent terminal
function! ubuild#build()
  call ubuild#verify_config()
  echo 'Building on ' . g:ubuild_remote
  call ubuild#send_commands_to_persistent_terminal(
        \ 'UBuild Build', 
        \ g:ubuild_build_commands
        \ )
endfunction

" Run test commands in persistent terminal
function! ubuild#test()
  call ubuild#verify_config()
  echo 'Testing on ' . g:ubuild_remote
  call ubuild#send_commands_to_persistent_terminal(
        \ 'UBuild Test', 
        \ g:ubuild_test_commands
        \ )
endfunction

nnoremap <c-x><c-s> :call ubuild#sync()<cr>
nnoremap <c-x><c-a> :call ubuild#connect()<cr>
nnoremap <c-x><c-c> :call ubuild#configure()<cr>
nnoremap <c-x><c-b> :call ubuild#build()<cr>
nnoremap <c-x><c-t> :call ubuild#test()<cr>
