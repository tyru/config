let s:config = vivacious#bundleconfig#new()

function! s:config.config()
    let s:disable_open_in_project_tab = 1
    if !s:disable_open_in_project_tab
        autocmd vimrc VimEnter  if exists('g:loaded_tabpagecd')
        \   |     execute 'autocmd vimrc BufReadPost * call s:open_in_project_tab()'
        \   | endif

        " * g:hoge_open_cmd みたいな変数に ":ProjBuffer split"
        "   みたいに指定して管理下に置く
        " * 好きな位置に開ける。ウインドウグループというものを定義して、
        "   ウインドウグループに指定したバッファのウインドウが開かれていたらそこに開くなどできる
        " * 開くコマンドは1つだけでいい。開く位置はウインドウマネージャに任せればいい
        " * strategy: tiling, zen(mode)?, ide
        function! s:open_in_project_tab()
            if &buftype !=# '' || &bufhidden !=# ''
                return
            endif
            if tabpagenr('$') is 1
                return
            endif
            let curtabnr = tabpagenr()
            let lasttabnr = tabpagenr('$')
            for tabnr in range(1, lasttabnr)
                if tabnr is curtabnr
                    continue
                endif
                let afile = s:normalize_path(expand('<afile>'))
                let cwd = s:normalize_path(gettabvar(tabnr, 'cwd'))
                if stridx(afile, cwd) isnot -1
                    let bufnr = bufnr('%')
                    setlocal bufhidden=hide
                    try
                        close
                        if lasttabnr isnot tabpagenr('$')
                        \   && tabnr ># tabpagenr()
                            let tabnr -= 1
                        endif
                        execute 'tabnext' tabnr
                        execute 'SplitNicely sbuffer' bufnr
                    finally
                        setlocal bufhidden=
                    endtry
                    break
                endif
            endfor
        endfunction

        function! s:normalize_path(filepath)
            let p = a:filepath
            let p = fnamemodify(p, ':p')
            let p = substitute(p, '\', '/', 'g')
            let p = substitute(p, '/\{2,}', '/', 'g')
            return tolower(p)
        endfunction
    endif
endfunction
