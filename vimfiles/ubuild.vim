"==============------------------------------------------------=================
"========                                                         ==============
"  _   _ ____        _ _     _
" | | | | __ ) _   _(_) | __| |
" | | | |  _ \| | | | | |/ _` |
" | |_| | |_) | |_| | | | (_| |
"  \___/|____/ \__,_|_|_|\__,_|
"
"
" IDE for Vim.
" ------------
"
" Some highlights:
" ----------------
"
"   - Remote build servers
"   - Build kits
"   - Source syncronization between systems
"   - Psuedo GUI menu
"
" Asher Mancinelli <ashermancinelli@gmail.com>
"
"========                                                         ==============
"==============------------------------------------------------=================


"======-------------------------------------------------------------------======
"
" General Utilities
"
"======-------------------------------------------------------------------======

" Static variables for ubuild#*
let g:_ubuild_vars = [
      \ '_ubuild_persistent_term_id',
      \ '_ubuild_config',
      \ ]

" Initialize all global ubuild vars to -1
for v in g:_ubuild_vars
  if !exists("g:" . v)
    exe "let g:".v." = -1"
  endif
endfor

" Call term_sendkeys and wait on results before continuing
"
" \param term_id[in] int ID of the terminal instance
" \param command[in] string String-ified command to be run in terminal
function! ubuild#term_sendkeys_await(term_id, command)

  call term_wait(a:term_id)

  call term_sendkeys(a:term_id, a:command)

  call term_wait(a:term_id)

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

" Wraps private variables into an object of handles.
"
" \returns object with keys _terminal_handle_
function! ubuild#create_tabbed_terminal_object()

  let terminal_handle = g:_ubuild_persistent_term_id
  return {
    \ 'terminal_handle': terminal_handle,
  \ }

endfunction

" Ensure configuration contians the given keys, ordered by nesting.
"
" For example, to check if the key 'inner_key' exists in the following
" configuration:
"
" ```json
" {
"   'outter_key': {
"     'inner_key': true
"   }
" }
" ```
"
" One would call this function like so:
"
" ```vim
" call ubuild#assert_config_has_key('outter_key', 'inner_key')
" ```
function! ubuild#assert_config_has_key(...)

  if a:0 == 0
    throw "UBuild function _config_has_key requires >= 1 argument!"
  endif

  if g:_ubuild_config == -1
    throw "ubuild#assert_config_has_key was called, but config is not initialized!"
  endif

  let config = g:_ubuild_config

  for k in a:000

    if !type(config) == type({})
      throw "Config component '" . config . "' is missing key " . k . "!"
    endif

    if !has_key(config, k)
      throw "Config component '" . config . "' is missing key " . k . "!"
    endif

    let config = config[k]

  endfor

endf

" Use terminal with buffer ID to send build/test commands to.
"
" \param buffer_id[in] string ID of buffer to use for remote commands
function! ubuild#use_terminal_with_buffer_id(buffer_id)

  let g:_ubuild_persistent_term_id = a:buffer_id

endf

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

"======-------------------------------------------------------------------======
"
" Configuration Utilities
" -----------------------
"
"======-------------------------------------------------------------------======

function! ubuild#edit_config()

  " Get configuration file name
  let config_file = ubuild#get_config_file(0)
  let basename = split(config_file, '/')[-1]

  " Try to find a buffer with it already open
  let id = bufnr(basename)

  if id != -1
    exe "edit #" . id
    return
  endif

  exe "$tabnew"
  exe "edit " . config_file

endf

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

" Create a _.ubuild.json_ file in the current working directory using the
" template configuration file installed alongside ubuild.
function! ubuild#create_config_template()

  let config_file = ubuild#get_config_file(0)
  let template_path = getenv('HOME') . "/.vim/ubuild-template.json"
  let config_template = readfile(template_path)
  call writefile(config_template, config_file)

endfunction

" Ensure that a file _.ubuild.vim_ exists in the current working directory and 
" that all the needed variables are set.
function! ubuild#verify_config()

  let config_file = ubuild#get_config_file()

  let json_string = join(readfile(config_file))
  let g:_ubuild_config = json_decode(json_string)

  call ubuild#assert_config_has_key('configure_commands')
  call ubuild#assert_config_has_key('build_commands')
  call ubuild#assert_config_has_key('test_commands')
  call ubuild#assert_config_has_key('remote_build_server')
  call ubuild#assert_config_has_key('remote_build_server', 'enabled')

  if g:_ubuild_config.remote_build_server.enabled

    call ubuild#assert_config_has_key('remote_build_server', 'enabled')
    call ubuild#assert_config_has_key('remote_build_server', 'local_directory')
    call ubuild#assert_config_has_key('remote_build_server', 'remote_host')
    call ubuild#assert_config_has_key('remote_build_server', 'remote_directory')
    call ubuild#assert_config_has_key('remote_build_server', 'connect_commands')
    call ubuild#assert_config_has_key('remote_build_server', 'rsync_exclude')

    if type(g:_ubuild_config.remote_build_server.rsync_exclude) != type([])
      throw "UBuild expected config key `remote_build_server.rsync_exclude` to have type `list`!"
    endif

  endif

endfunction

"======-------------------------------------------------------------------======
"
" Command Functions
" -----------------
"
"======-------------------------------------------------------------------======

" Build rsync command used to sync with build server.
"
" \returns string
function! ubuild#build_rsync_command()

  let rsync_exclude = ''
  if has_key(g:_ubuild_config['remote_build_server'], 'rsync_exclude')
    let exclude = g:_ubuild_config.remote_build_server.rsync_exclude
    if len(exclude) > 0
      let rsync_exclude = ' --exclude=' .
        \ join(exclude, ' --exclude=') . ' '
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

" Connect to remote build server and instantiate terminal for configure,
" build, and test commands to use.
function! ubuild#connect()

  call ubuild#verify_config()
  echo 'Connecting to ' . g:ubuild_remote
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

"======-------------------------------------------------------------------======
"
" GUI
" ---
"
"======-------------------------------------------------------------------======

let g:_ubuild_notification_messages = [
      \ 'Syncing...',
      \ 'Connecting...',
      \ 'Configuring...',
      \ 'Building...',
      \ 'Testing...',
      \ 'Editing Configuration...',
      \ ]

let g:_ubuild_popup_menu_options = [
      \ 'Sync',
      \ 'Connect',
      \ 'Configure',
      \ 'Build',
      \ 'Test',
      \ 'Edit Config',
      \ ]

function! ubuild#popup_menu()

  call popup_menu(g:_ubuild_popup_menu_options, #{
        \ callback: 'ubuild#menu_handler',
        \ })

endf

function! ubuild#popup_notification(message)

  call popup_notification(a:message, #{ 
        \ col: 1,
        \ time: 3000,
        \ })

endf

function! ubuild#menu_handler(id, result)

  if a:result == -1
    return
  endif

  echom "id=".a:id." result=".a:result

  call ubuild#popup_notification(g:_ubuild_notification_messages[a:result-1])

  if a:result == 1
    call ubuild#sync()
  endif

  if a:result == 2
    call ubuild#connect()
  endif

  if a:result == 3
    call ubuild#configure()
  endif

  if a:result == 4
    call ubuild#build()
  endif

  if a:result == 5
    call ubuild#test()
  endif

  if a:result == 6
    call ubuild#edit_config()
  endif

endf

"======-------------------------------------------------------------------======
"
" Remappings
" ----------
"
"======-------------------------------------------------------------------======

nnoremap <c-u><c-s> :call ubuild#sync()<cr>
nnoremap <c-u><c-a> :call ubuild#connect()<cr>
nnoremap <c-u><c-c> :call ubuild#configure()<cr>
nnoremap <c-u><c-b> :call ubuild#build()<cr>
nnoremap <c-u><c-t> :call ubuild#test()<cr>
nnoremap <c-u><c-u> :call ubuild#popup_menu()<cr>
