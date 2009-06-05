" This is a simple script. It extends the syntax highlighting to
" highlight each matching set of parens in different colors, to make
" it visually obvious what matches which.

" Obviously, most useful when working with lisp. But it's also nice othe
" times.

" I don't intend to maintain this script. I hacked it together for my
" own purposes, and it is sufficient to the day. If you want to improve it,
" knock yourself out.

" This file is public domain.


" define colors. Note that the one numbered '16' is the outermost pair,
" keep that in mind if you want to change the colors.
" Also, if this script doesn't work on your terminal, you may need to add
" guifg=xx or ever termfg=, though what good this script will do on a 
" black and white terminal I don't know.
hi level1c ctermfg=brown
hi level2c ctermfg=Darkblue
hi level3c ctermfg=darkgray
hi level4c ctermfg=darkgreen
hi level5c ctermfg=darkcyan
hi level6c ctermfg=darkred
hi level7c ctermfg=darkmagenta
hi level8c ctermfg=brown
hi level9c ctermfg=gray
hi level10c ctermfg=black
hi level11c ctermfg=darkmagenta
hi level12c ctermfg=Darkblue
hi level13c ctermfg=darkgreen
hi level14c ctermfg=darkcyan
hi level15c ctermfg=darkred
hi level16c ctermfg=red
" if &bg == "dark"
"   hi level1c  ctermfg=red         guifg=red1
"   hi level2c  ctermfg=yellow      guifg=orange1      
"   hi level3c  ctermfg=green       guifg=yellow1      
"   hi level4c  ctermfg=cyan        guifg=greenyellow  
"   hi level5c  ctermfg=magenta     guifg=green1       
"   hi level6c  ctermfg=red         guifg=springgreen1 
"   hi level7c  ctermfg=yellow      guifg=cyan1        
"   hi level8c  ctermfg=green       guifg=slateblue1   
"   hi level9c  ctermfg=cyan        guifg=magenta1     
"   hi level10c ctermfg=magenta     guifg=purple1
" else
"   hi level1c  ctermfg=red         guifg=red3
"   hi level2c  ctermfg=darkyellow  guifg=orangered3
"   hi level3c  ctermfg=darkgreen   guifg=orange2
"   hi level4c  ctermfg=blue        guifg=yellow3
"   hi level5c  ctermfg=darkmagenta guifg=olivedrab4
"   hi level6c  ctermfg=red         guifg=green4
"   hi level7c  ctermfg=darkyellow  guifg=paleturquoise3
"   hi level8c  ctermfg=darkgreen   guifg=deepskyblue4
"   hi level9c  ctermfg=blue        guifg=darkslateblue
"   hi level10c ctermfg=darkmagenta guifg=darkviolet
" endif



" These are the regions for each pair.
" This could be improved, perhaps, by makeing them match [ and { also,
" but I'm not going to take the time to figure out haw to make the
" end pattern match only the proper type.
syn region level1 matchgroup=level1c start=/(/ end=/)/ contains=TOP,level1,level2,level3,level4,level5,level6,level7,level8,level9,level10,level11,level12,level13,level14,level15, level16,NoInParens
syn region level2 matchgroup=level2c start=/(/ end=/)/ contains=TOP,level2,level3,level4,level5,level6,level7,level8,level9,level10,level11,level12,level13,level14,level15, level16,NoInParens
syn region level3 matchgroup=level3c start=/(/ end=/)/ contains=TOP,level3,level4,level5,level6,level7,level8,level9,level10,level11,level12,level13,level14,level15, level16,NoInParens
syn region level4 matchgroup=level4c start=/(/ end=/)/ contains=TOP,level4,level5,level6,level7,level8,level9,level10,level11,level12,level13,level14,level15, level16,NoInParens
syn region level5 matchgroup=level5c start=/(/ end=/)/ contains=TOP,level5,level6,level7,level8,level9,level10,level11,level12,level13,level14,level15, level16,NoInParens
syn region level6 matchgroup=level6c start=/(/ end=/)/ contains=TOP,level6,level7,level8,level9,level10,level11,level12,level13,level14,level15, level16,NoInParens
syn region level7 matchgroup=level7c start=/(/ end=/)/ contains=TOP,level7,level8,level9,level10,level11,level12,level13,level14,level15, level16,NoInParens
syn region level8 matchgroup=level8c start=/(/ end=/)/ contains=TOP,level8,level9,level10,level11,level12,level13,level14,level15, level16,NoInParens
syn region level9 matchgroup=level9c start=/(/ end=/)/ contains=TOP,level9,level10,level11,level12,level13,level14,level15, level16,NoInParens
syn region level10 matchgroup=level10c start=/(/ end=/)/ contains=TOP,level10,level11,level12,level13,level14,level15, level16,NoInParens
syn region level11 matchgroup=level11c start=/(/ end=/)/ contains=TOP,level11,level12,level13,level14,level15, level16,NoInParens
syn region level12 matchgroup=level12c start=/(/ end=/)/ contains=TOP,level12,level13,level14,level15, level16,NoInParens
syn region level13 matchgroup=level13c start=/(/ end=/)/ contains=TOP,level13,level14,level15, level16,NoInParens
syn region level14 matchgroup=level14c start=/(/ end=/)/ contains=TOP,level14,level15, level16,NoInParens
syn region level15 matchgroup=level15c start=/(/ end=/)/ contains=TOP,level15, level16,NoInParens
syn region level16 matchgroup=level16c start=/(/ end=/)/ contains=TOP,level16,NoInParens
