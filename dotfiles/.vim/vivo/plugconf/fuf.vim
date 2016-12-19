let s:config = vivo#plugconf#new()

function! s:config.config()
  nnoremap s <SID>(anything)
  nnoremap <SID>(anything) <Nop>

  nmap <SID>(anything)d :<C-u>FufDir<CR>
  nmap <SID>(anything)f :<C-u>FufFile<CR>
  nmap <SID>(anything)h :<C-u>FufMruFile<CR>
  nmap <SID>(anything)r :<C-u>FufRenewCache<CR>

  let g:fuf_modesDisable = ['mrucmd', 'bookmark', 'givenfile', 'givendir', 'givencmd', 'callbackfile', 'callbackitem', 'buffer', 'tag', 'taggedfile']
  let fuf_keyOpenTabpage = '<C-t>'
  let fuf_keyNextMode    = '<C-l>'
  let fuf_keyPrevMode    = '<C-h>'
  let fuf_keyOpenSplit   = '<C-s>'
  let fuf_keyOpenVsplit  = '<C-v>'
  let fuf_enumeratingLimit = 20
  let fuf_previewHeight = 0
endfunction
