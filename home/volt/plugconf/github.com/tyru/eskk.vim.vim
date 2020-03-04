" vim:et:sw=2:ts=2

function! s:on_load_pre()
  " augroup vimrc-eskk-vimenter
  "   autocmd!
  "   autocmd VimEnter *
  "   \   let &statusline .= '%( | %{exists("g:loaded_autoload_eskk") ? eskk#statusline("IM:%s", "IM:off") : ""}%)' |
  "   \   autocmd! vimrc-eskk-vimenter
  " augroup END

  let g:eskk#dictionary = {
  \   'path': '~/.skkdict/user-dict',
  \   'encoding': 'utf-8',
  \}
  let g:eskk#large_dictionary = {
  \   'path': '~/.skkdict/system-dict',
  \   'encoding': 'euc-jp',
  \}
  " let g:eskk#server = {
  " \   'host': 'localhost',
  " \   'port': 1178,
  " \}

  " let g:eskk#log_cmdline_level = 2
  " let g:eskk#log_file_level = 4

  autocmd User eskk-initialize-pre call s:eskk_initial_pre()
  function! s:eskk_initial_pre()
      let t = eskk#table#new('rom_to_hira*', 'rom_to_hira')
      call t.add_map('~', '～')
      call t.add_map('zc', '©')
      call t.add_map('zr', '®')
      call t.add_map('tm', '™')
      call t.add_map('z ', '　')
      " FIXME: 「1gyou」と入力すると「ぎょう」になる。
      " これは以下の設定がある場合の一般的なSKKの動作的に想定通りだが(ほんとに？)
      " 「1Gyou」と入力しても「▽ぎょう」とならず「ぎょう」となってしまう。
      " また g:eskk#rom_input_style = 'msime' の時も考慮できてるか不明。
      " for n in range(10)
      "   call t.add_map(n . '.', n . '.')
      " endfor
      call eskk#register_mode_table('hira', t)
  endfunction

endfunction

" Plugin configuration like the code written in vimrc.
" This configuration is executed *after* a plugin is loaded.
function! s:on_load_post()
endfunction

function! s:loaded_on()
  " This function determines when a plugin is loaded.
  "
  " Possible values are:
  " * 'start' (a plugin will be loaded at VimEnter event)
  " * 'filetype=<filetypes>' (a plugin will be loaded at FileType event)
  " * 'excmd=<excmds>' (a plugin will be loaded at CmdUndefined event)
  " <filetypes> and <excmds> can be multiple values separated by comma.
  "
  " This function must contain 'return "<str>"' code.
  " (the argument of :return must be string literal)

  return 'start'
endfunction

function! s:depends()
  " Dependencies of this plugin.
  " The specified dependencies are loaded after this plugin is loaded.
  "
  " This function must contain 'return [<repos>, ...]' code.
  " (the argument of :return must be list literal, and the elements are string)
  " e.g. return ['github.com/tyru/open-browser.vim']

  return []
endfunction

function! s:eskk_initial_pre()
      let t = eskk#table#new('rom_to_hira*', 'rom_to_hira')
      call t.add_map('~', '～')
      call t.add_map('zc', '©')
      call t.add_map('zr', '®')
      call t.add_map('tm', '™')
      call t.add_map('z ', '　')
      " FIXME: 「1gyou」と入力すると「ぎょう」になる。
      " これは以下の設定がある場合の一般的なSKKの動作的に想定通りだが(ほんとに？)
      " 「1Gyou」と入力しても「▽ぎょう」とならず「ぎょう」となってしまう。
      " また g:eskk#rom_input_style = 'msime' の時も考慮できてるか不明。
      " for n in range(10)
      "   call t.add_map(n . '.', n . '.')
      " endfor
      call eskk#register_mode_table('hira', t)
  endfunction