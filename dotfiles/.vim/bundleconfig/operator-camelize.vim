
Map -remap [nxo] <operator>c <Plug>(operator-camelize-toggle)
let g:operator_camelize_all_uppercase_action = 'camelize'
let g:operator_decamelize_all_uppercase_action = 'lowercase'


" Test: g:operator_camelize_detect_function
" function! Camelized(word)
"     return 0
" endfunction
" let g:operator_camelize_detect_function = 'Camelized'
" E704: Funcref variable name must start with a capital: g:operator_camelize_detect_function
" let g:operator_camelize_detect_function = function('Camelized')

" Test: mappings
" Map -remap [nxo] <operator>c <Plug>(operator-camelize)
" Map -remap [nxo] <operator>C <Plug>(operator-decamelize)


" See "keymappings" branch.
" Map -remap [nxo] <operator>c <Plug>(operator-camelize/camelize)
" Map -remap [nxo] <operator>C <Plug>(operator-decamelize/lowercase)
