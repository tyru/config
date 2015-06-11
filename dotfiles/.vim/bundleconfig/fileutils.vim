
let g:fileutils_commands = 'noprefix'
" or
" call fileutils#load('noprefix')

MapAlterCommand rm Delete
MapAlterCommand del[ete] Delete
MapAlterCommand mv Rename
MapAlterCommand ren[ame] Rename
MapAlterCommand mkd[ir] Mkdir
MapAlterCommand mkc[d] Mkcd
MapAlterCommand co[py] Copy
MapAlterCommand cp     Copy

let g:fileutils_debug = 1
