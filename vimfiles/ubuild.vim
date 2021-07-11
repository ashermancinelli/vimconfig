"===============================================================================
"================-----------------------------------------------================
"========                                                               ========
"                          _   _ ____        _ _     _
"                         | | | | __ ) _   _(_) | __| |
"                         | | | |  _ \| | | | | |/ _` |
"                         | |_| | |_) | |_| | | | (_| |
"                          \___/|____/ \__,_|_|_|\__,_|
"
"
"                                 IDE for Vim.
"                                 ------------
"========                                                               ========
"================-----------------------------------------------================
"===============================================================================
"================-----------------------------------------------================
"========                                                               ========
"
"
"                   Some highlights:
"                   ----------------
"
"                     - Remote build servers
"                     - Build kits
"                     - Source syncronization between systems
"                     - TUI menu
"
"
"                  Asher Mancinelli <ashermancinelli@gmail.com>
"
"
"========                                                               ========
"================-----------------------------------------------================
"===============================================================================

"======-------------------------------------------------------------------======
"
"                              General Utilities
"                              -----------------
"
"======-------------------------------------------------------------------======

" Static variables for ubuild#*
let g:_ubuild_vars = [
      \ '_ubuild_persistent_term_id',
      \ '_ubuild_config',
      \ '_ubuild_enabled_kit_id',
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
function! s:term_sendkeys_await(term_id, command)

  call term_wait(a:term_id)

  call term_sendkeys(a:term_id, a:command)

  call term_wait(a:term_id)

endfunction

function! s:get_config()
  if type(g:_ubuild_config) != type({})
    throw "Attempted to get config, but config has not been created yet!"
  endif
  return g:_ubuild_config
endf

" Create a terminal in a new window and return an object with fields needed to
" operate on them.
"
" \param minimal[in] bool Should use minimal shell?
function! s:get_persistent_terminal(minimal)

  if g:_ubuild_persistent_term_id != -1
    return g:_ubuild_persistent_term_id
  endif

  let shell = &shell

  if a:minimal > 0
    let shell = 'env -i ' . &shell . ' --noprofile --norc'
  endif

  " Create the terminal in the bottom right of the current window
  rightbelow let term_handle = term_start(shell, {
        \ 'term_finish': 'close',
        \ 'term_rows': 8,
        \ })

  let g:_ubuild_persistent_term_id = term_handle

  return term_handle

endfunction

" Wraps private variables into an object of handles.
"
" \returns object with keys _terminal_handle_
function! s:create_tabbed_terminal_object()

  let terminal_handle = g:_ubuild_persistent_term_id
  return {
    \ 'terminal_handle': terminal_handle,
  \ }

endfunction

function! s:assert_is_type(sut, _type)

  let stringify_type = {
        \ v:t_blob: 'Blob',
        \ v:t_bool: 'Bool',
        \ v:t_channel: 'Channel',
        \ v:t_dict: 'Dictionary',
        \ v:t_float: 'Float',
        \ v:t_func: 'Function',
        \ v:t_job: 'Job',
        \ v:t_list: 'List',
        \ v:t_none: 'None',
        \ v:t_number: 'Number',
        \ v:t_string: 'String',
        \ }

  if type(a:sut) != a:_type
    let s = json_encode(a:sut)
    throw "Expected type of " . s . " to be " . stringify_type[a:_type] . "!"
  endif

endf

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
" call s:assert_config_has_key('outter_key', 'inner_key')
" ```
function! s:assert_config_has_key(config, ...)

  if type(a:config) != type({})
    throw "Config passed to s:assert_config_has_key is not of type Dict!"
  endif

  if a:0 == 0
    throw "UBuild function s:assert_config_has_key requires >= 1 argument!"
  endif

  let config = a:config

  for k in a:000

    if type(config) != type({})
      throw "Config ".config." is not of type Dict!"
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

  let term_id = s:get_persistent_terminal(v:false)

  call s:term_sendkeys_await(term_id, command_string)

endfunction

"======-------------------------------------------------------------------======
"
"                            Configuration Utilities
"                            -----------------------
"
"======-------------------------------------------------------------------======

function! ubuild#edit_config()

  " Get configuration file name
  let config_file = s:get_config_file(0)
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

function! s:get_all_kit_names()

  let config = s:get_config()

  let kits = config.kits

  let names = []
  for kit in kits
    call add(names, kit.name)
  endfor

  return names

endfunction

function! ubuild#select_kit()

  let names = s:get_all_kit_names()

  call popup_menu(names, #{
        \ callback: 'ubuild#kit_menu_handler',
        \ })

endf

function! ubuild#kit_menu_handler(id, result)

  if a:result == -1
    return
  endif

  let names = s:get_all_kit_names()

  echom "Selected kit '" . names[a:result-1] . "'"
  let g:_ubuild_enabled_kit_id = a:result - 1

endf

" Get path to configuration file.
"
" \param check[in] bool Should check for existence of config file?
function! s:get_config_file(...)

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
function! s:create_config_template()

  let config_file = s:get_config_file(v:false)
  let template_path = getenv('HOME') . "/.vim/ubuild-template.json"
  let config_template = readfile(template_path)
  call writefile(config_template, config_file)

endfunction

function! ubuild#get_enabled_kit()

  return g:_ubuild_config.kits[g:_ubuild_enabled_kit_id]

endf

" Ensure that a file _.ubuild.vim_ exists in the current working directory and 
" that all the needed variables are set.
function! ubuild#verify_config()

  let config_file = s:get_config_file()

  let json_string = join(readfile(config_file))
  let config = json_decode(json_string)

  call s:assert_config_has_key(config, 'project_name')
  call s:assert_config_has_key(config, 'kits')

  call s:assert_is_type(config.kits, v:t_list)

  if len(config.kits) == 0
    throw "Got config with 0 kits!"
  endif

  for kit in config.kits

    call s:assert_config_has_key(kit, 'configure_commands')
    call s:assert_is_type(kit.configure_commands, type([]))

    call s:assert_config_has_key(kit, 'build_commands')
    call s:assert_is_type(kit.build_commands, type([]))

    call s:assert_config_has_key(kit, 'test_commands')
    call s:assert_is_type(kit.test_commands, type([]))

    call s:assert_config_has_key(kit, 'remote_build_server')
    call s:assert_is_type(kit.remote_build_server, type({}))

    call s:assert_config_has_key(kit, 'remote_build_server', 'enabled')
    call s:assert_is_type(kit.remote_build_server.enabled, type(v:false))

    if kit.remote_build_server.enabled

      let remote = kit.remote_build_server

      call s:assert_config_has_key(remote, 'local_directory')
      call s:assert_is_type(remote.local_directory, type(''))

      call s:assert_config_has_key(remote, 'remote_host')
      call s:assert_is_type(remote.remote_host, type(''))

      call s:assert_config_has_key(remote, 'remote_directory')
      call s:assert_is_type(remote.remote_directory, type(''))

      call s:assert_config_has_key(remote, 'connect_commands')
      call s:assert_is_type(remote.connect_commands, type([]))

      call s:assert_config_has_key(remote, 'rsync_exclude')
      call s:assert_is_type(remote.rsync_exclude, type([]))

    endif

  endfor

  if g:_ubuild_enabled_kit_id == -1
    if has_key(config, 'enabled_kit')
      if index(s:get_all_kit_names(), config.enabled_kit) == -1
        throw "Default kit " . config.enabled_kit . " could not be found!"
      endif
      let g:_ubuild_enabled_kit_id = index(s:get_all_kit_names(), config.enabled_kit)
    else
      let g:_ubuild_enabled_kit_id = 0
    endif
  endif

  echom "Using kit with id " . g:_ubuild_enabled_kit_id

  let g:_ubuild_config = config

endfunction

"======-------------------------------------------------------------------======
"
"                               Command Functions
"                               -----------------
"
"======-------------------------------------------------------------------======

" Build rsync command used to sync with build server.
"
" \returns string
function! s:build_rsync_command()

  call ubuild#verify_config()

  let kit = ubuild#get_enabled_kit()

  if !kit.remote_build_server.enabled
    return
  endif

  let remote = kit.remote_build_server

  let rsync_exclude = ''
  let exclude = remote.rsync_exclude
  if len(exclude) > 0
    let rsync_exclude = ' --exclude=' .
      \ join(exclude, ' --exclude=') . ' '
  endif

  let rsync_command = 'rsync -aP ' . rsync_exclude . remote.local_directory . ' '
    \ . remote.remote_host . ':' . remote.remote_directory . "\<cr>exit\<cr>"

  return rsync_command

endfunction

" Sync the source directory with the remote directory in a new window.
function! ubuild#sync()

  call ubuild#verify_config()

  let kit = ubuild#get_enabled_kit()

  let rsync_command = s:build_rsync_command()

  let init_tab = tabpagenr()
  execute '$tabnew'
  
  let minimal_shell = 'env -i ' . &shell . ' --noprofile --norc'
  let term_id = term_start(minimal_shell, {
        \   'term_finish': 'close',
        \   'curwin': 1
        \ })
  call s:term_sendkeys_await(term_id, rsync_command)

  exe "tabnext " . init_tab

endfunction

function! ubuild#connect_if_remote()

  let kit = ubuild#get_enabled_kit()

  if !kit.remote_build_server.enabled
    return
  endif

  call ubuild#send_commands_to_persistent_terminal(
        \ 'UBuild Open', 
        \ kit.remote_build_server.connect_commands,
        \ )

endf

" Connect to remote build server and instantiate terminal for configure,
" build, and test commands to use.
function! ubuild#open_terminal()

  call ubuild#verify_config()

  " Calling for the first time will create the terminal
  call s:get_persistent_terminal(v:false)

  call ubuild#connect_if_remote()

endfunction

" Configure build in persistent terminal
function! ubuild#configure()

  call ubuild#verify_config()

  let kit = ubuild#get_enabled_kit()

  echo 'Configuring...'
  call ubuild#send_commands_to_persistent_terminal(
        \ 'UBuild Configure', 
        \ kit.configure_commands,
        \ )

endfunction

" Run build commands in persistent terminal
function! ubuild#build()

  call ubuild#verify_config()

  let kit = ubuild#get_enabled_kit()

  echo 'Building...'
  call ubuild#send_commands_to_persistent_terminal(
        \ 'UBuild Build', 
        \ kit.build_commands,
        \ )

endfunction

" Run test commands in persistent terminal
function! ubuild#test()

  call ubuild#verify_config()

  let kit = ubuild#get_enabled_kit()

  echo 'Testing...'
  call ubuild#send_commands_to_persistent_terminal(
        \ 'UBuild Test', 
        \ kit.test_commands,
        \ )

endfunction

"======-------------------------------------------------------------------======
"
"                                     TUI
"                                     ---
"
"======-------------------------------------------------------------------======

function! s:get_menu_options()

  let options = []
  let messages = []
  let callbacks = []
  let kit = ubuild#get_enabled_kit()

  if len(kit.configure_commands) > 0
    call add(options, 'Configure')
    call add(messages, 'Configuring...')
    call add(callbacks, 'configure')
  endif

  if len(kit.build_commands) > 0
    call add(options, 'Build')
    call add(messages, 'Building...')
    call add(callbacks, 'build')
  endif

  if len(kit.test_commands) > 0
    call add(options, 'Test')
    call add(messages, 'Testing...')
    call add(callbacks, 'test')
  endif

  if kit.remote_build_server.enabled
    call add(options, 'Sync')
    call add(messages, 'Syncing with remote ' kit.remote_build_server.remote_host . '...')
    call add(callbacks, 'sync')
  endif

  if g:_ubuild_persistent_term_id == -1
    call add(options, 'Start UBuild Terminal')
    call add(messages, '')
    call add(callbacks, 'open_terminal')
  endif

  if len(s:get_config().kits) > 1
    call add(options, 'Select Kit')
    call add(messages, '')
    call add(callbacks, 'select_kit')
  endif

  call add(options, 'Edit Config')
  call add(messages, '')
  call add(callbacks, 'edit_config')

  return { 'options': options, 'messages': messages, 'callbacks': callbacks }

endf

function! ubuild#popup_menu()

  let options = s:get_menu_options()

  call popup_menu(options.options, #{
        \ callback: 'ubuild#menu_handler',
        \ })

endf

function! s:popup_notification(message)

  call popup_notification(a:message, #{ 
        \ col: 1,
        \ time: 3000,
        \ })

endf

function! ubuild#menu_handler(id, result)

  if a:result == -1
    return
  endif

  let options = s:get_menu_options()

  if a:result < len(s:notification_messages)
    echom a:result
    let msg = options.messages[a:result-1]
    if len(msg) > 0
      call s:popup_notification(msg)
    endif
  endif

  exe "call ubuild#" . options.callbacks[a:result-1] . "()"

endf

"======-------------------------------------------------------------------======
"
" Remappings
" ----------
"
"======-------------------------------------------------------------------======

nnoremap <c-u><c-c> :call ubuild#configure()<cr>
nnoremap <c-u><c-b> :call ubuild#build()<cr>
nnoremap <c-u><c-t> :call ubuild#test()<cr>
nnoremap <c-u><c-s> :call ubuild#sync()<cr>
nnoremap <c-u><c-o> :call ubuild#open_terminal()<cr>
nnoremap <c-u><c-k> :call ubuild#select_kit()<cr>
nnoremap <c-u><c-u> :call ubuild#popup_menu()<cr>
