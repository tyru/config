let s:config = BundleConfigGet()

function! s:config.config()
    DefMacroMap [n] anything s

    Map [n] <anything>d        :<C-u>FufDir<CR>
    Map [n] <anything>f        :<C-u>FufFile<CR>
    Map [n] <anything>h        :<C-u>FufMruFile<CR>
    Map [n] <anything>r        :<C-u>FufRenewCache<CR>

    let g:fuf_modesDisable = ['mrucmd', 'bookmark', 'givenfile', 'givendir', 'givencmd', 'callbackfile', 'callbackitem', 'buffer', 'tag', 'taggedfile']
    let fuf_keyOpenTabpage = '<C-t>'
    let fuf_keyNextMode    = '<C-l>'
    let fuf_keyPrevMode    = '<C-h>'
    let fuf_keyOpenSplit   = '<C-s>'
    let fuf_keyOpenVsplit  = '<C-v>'
    let fuf_enumeratingLimit = 20
    let fuf_previewHeight = 0
endfunction
