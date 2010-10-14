" Vim color file based on bluegreen
" Maintainer:   Sergey Khorev <sergey.khorev@gmail.com>
" Last Change: Dec 04 2009
" URL:	http://sites.google.com/site/khorser/opensource/vim
" vim: sw=2:sts=2:
" if your text terminal supports font attributes like bold you might want 
" to set g:CtermAttrs = 1 for better results

set background=dark
hi clear
if exists("syntax_on")
  syntax reset
endif
let g:colors_name="northsky"

hi Normal	guifg=white guibg=#061A3E

hi Search	guibg=#3D5B8C guifg=yellow gui=bold
hi IncSearch	guifg=bg guibg=cyan gui=bold

hi Cursor	guibg=#D74141 guifg=#e3e3e3
hi lCursor	guibg=SeaGreen1 guifg=NONE   "

hi VertSplit	guibg=#C0FFFF guifg=#075554 gui=none
hi Folded	guifg=plum1 guibg=#061A3E
hi FoldColumn	guibg=#800080 guifg=tan
hi ModeMsg	guifg=#404040 guibg=#C0C0C0
hi MoreMsg	guifg=darkturquoise guibg=#188F90
hi NonText	guibg=#334C75 guifg=#9FADC5
hi Question	guifg=#F4BB7E

hi SpecialKey	guifg=#BF9261
hi StatusLine	guibg=#067C7B guifg=cyan gui=none
hi StatusLineNC	guibg=#004443 guifg=DimGrey gui=none
hi Title	guifg=#8DB8C3
hi Visual	gui=bold guifg=black guibg=#84AF84
hi WarningMsg	guifg=#F60000 gui=underline

hi Comment	guifg=DarkGray
hi Constant	guifg=#72A5E4 gui=bold  term=none
hi Number	guifg=chartreuse2 gui=bold
hi Identifier	guifg=#ADCBF1
hi Statement	guifg=yellow
hi PreProc	guifg=#14967C
hi Type		guifg=#FFAE66
hi Special	guifg=#EEBABA
hi Ignore	guifg=grey60
hi Todo		guibg=#9C8C84 guifg=#244C0A
hi Label	guifg=#ffc0c0

hi WildMenu	guifg=Black guibg=Yellow

hi ErrorMsg	guifg=White guibg=Red
hi DiffAdd	guibg=DarkBlue
hi DiffDelete	gui=bold guifg=Yellow guibg=DarkBlue
hi DiffChange	guibg=aquamarine4
hi DiffText	gui=bold guibg=firebrick3

hi Directory	guifg=Cyan
hi LineNr	guifg=DarkGreen

hi VisualNOS	gui=underline,bold
hi SignColumn   guibg=Grey guifg=Cyan

hi PmenuThumb	guibg=black
hi PmenuSbar	guibg=lightgray
hi PmenuSel	guifg=lightcyan guibg=blue gui=bold
hi PMenu	guibg=darkgray guifg=black

hi Error	guifg=White guibg=Red
hi Underlined	gui=underline guifg=#80a0ff

hi MatchParen   guifg=bg guibg=DarkGray

" terminal with bold, italic etc attrs
if exists('g:CtermAttrs') && g:CtermAttrs
  hi Normal	ctermfg=lightgray ctermbg=black cterm=none

  hi Search	ctermbg=darkblue ctermfg=yellow cterm=bold
  hi IncSearch	ctermfg=bg ctermbg=cyan cterm=bold

  hi Cursor	ctermfg=white ctermbg=red cterm=none
  hi lCursor	ctermbg=lightgreen ctermfg=NONE " cterm=none

  hi VertSplit	ctermfg=darkblue ctermbg=cyan cterm=none
  hi Folded	ctermfg=magenta ctermbg=bg cterm=none
  hi FoldColumn	ctermfg=lightgray ctermbg=darkmagenta cterm=none
  hi ModeMsg	ctermfg=black ctermbg=gray cterm=bold
  hi MoreMsg	ctermfg=darkblue ctermbg=darkcyan cterm=none
  hi NonText	ctermfg=gray ctermbg=darkblue cterm=none
  hi Question	ctermfg=yellow cterm=none

  hi SpecialKey	ctermfg=brown cterm=none
  hi StatusLine	ctermfg=darkblue ctermbg=darkcyan cterm=bold
  hi StatusLineNC ctermbg=darkgray ctermfg=black cterm=bold
  hi Title	ctermfg=blue cterm=none
  hi Visual	ctermbg=darkgreen ctermfg=black cterm=none
  hi WarningMsg	ctermfg=red cterm=none

  hi Comment	ctermfg=darkgray cterm=none
  hi Constant   ctermfg=cyan term=none
  hi Number	ctermfg=green cterm=bold
  hi Identifier	ctermfg=white cterm=bold
  hi Statement	ctermfg=yellow cterm=bold
  hi PreProc	ctermfg=darkgreen cterm=none
  hi Type	ctermfg=darkmagenta cterm=bold
  hi Special	ctermfg=darkmagenta cterm=none
  hi Ignore	ctermfg=gray cterm=none
  hi Todo	ctermfg=darkblue ctermbg=lightgray cterm=none
  hi Label	ctermfg=yellow cterm=none

  hi WildMenu	cterm=bold

  hi ErrorMsg   ctermbg=darkred ctermfg=white cterm=none
  hi DiffAdd    ctermbg=DarkBlue ctermfg=white cterm=none
  hi DiffDelete ctermfg=yellow ctermbg=darkblue cterm=bold
  hi DiffChange ctermbg=DarkMagenta cterm=none
  hi DiffText   cterm=bold ctermbg=Red

  hi Directory	ctermfg=darkcyan cterm=none
  hi LineNr	ctermfg=blue cterm=none

  hi VisualNOS	cterm=underline,bold
  hi SignColumn	ctermbg=DarkGrey ctermfg=Cyan

  hi Pmenu	ctermbg=darkgray ctermfg=black cterm=bold
  hi PmenuSel	ctermbg=darkblue ctermfg=white cterm=bold
  hi PmenuSbar	ctermbg=lightgray cterm=none
  hi PmenuThumb ctermbg=black cterm=none

  hi Error	ctermfg=white ctermbg=red cterm=bold
  hi Underlined	ctermfg=lightblue cterm=bold,underline

  hi MatchParen  ctermfg=bg ctermbg=DarkGray

  hi TabLine	ctermfg=82 ctermbg=15 cterm=underline
  hi TabLineSel	ctermbg=15 ctermbg=82 cterm=bold
  hi TabLineFill cterm=reverse
else " usual terminal

  hi Normal	ctermfg=7 ctermbg=0

  hi Search	ctermbg=4 ctermfg=3 cterm=NONE
  hi IncSearch	ctermbg=5 ctermfg=7 cterm=NONE

  "hi Cursor	ctermfg=1 cterm=NONE
  "hi lCursor	ctermbg=2* ctermfg=0

  hi VertSplit	ctermfg=0 ctermbg=7 cterm=NONE
  hi Folded	ctermfg=5 cterm=NONE
  hi FoldColumn	ctermfg=7 ctermbg=5 cterm=NONE
  hi ModeMsg	ctermfg=0 ctermbg=7 cterm=NONE
  hi MoreMsg	ctermfg=0 ctermbg=6 cterm=NONE
  hi NonText	ctermfg=6 cterm=bold
  hi Question	ctermfg=3 cterm=bold

  hi SpecialKey	ctermfg=5 cterm=NONE
  hi StatusLine	ctermfg=0 ctermbg=6 cterm=NONE
  hi StatusLineNC ctermfg=4 ctermbg=7 cterm=NONE
  hi Title	ctermfg=6 cterm=bold
  hi Visual	ctermbg=3 ctermfg=4 cterm=NONE
  hi WarningMsg	ctermfg=1 cterm=NONE

  hi Comment	ctermfg=0 cterm=bold
  hi Constant	ctermfg=4 cterm=bold
  hi Number	ctermfg=2 cterm=bold
  hi Identifier	ctermfg=6 cterm=NONE
  hi Statement	ctermfg=3 cterm=bold
  hi PreProc	ctermfg=2 cterm=NONE
  hi Type     	ctermfg=3 cterm=NONE
  hi Special	ctermfg=5 cterm=bold
  hi Ignore	ctermfg=4 cterm=NONE
  hi Todo     	ctermfg=4 ctermbg=3 cterm=NONE
  hi Label	ctermfg=1 cterm=bold

  hi WildMenu	ctermbg=3 cterm=NONE

  hi ErrorMsg	ctermfg=7 ctermbg=1 cterm=bold
  hi DiffAdd	ctermfg=3 ctermbg=4 cterm=bold
  hi DiffDelete	ctermfg=3 ctermbg=1 cterm=bold
  hi DiffChange	ctermfg=4 ctermbg=2 cterm=NONE
  hi DiffText	ctermfg=3 ctermbg=1 cterm=bold

  hi Directory	ctermfg=3 cterm=NONE
  hi LineNr	ctermfg=4 cterm=NONE

  hi VisualNOS	cterm=underline,bold
  hi SignColumn	ctermbg=0 ctermfg=6 cterm=bold

  hi Pmenu	ctermbg=4* ctermfg=0 cterm=none
  hi PmenuSel	ctermbg=5* ctermfg=7* cterm=none
  hi PmenuSbar	ctermbg=7 cterm=none
  hi PmenuThumb ctermbg=0 cterm=none

  hi Error	ctermfg=7 ctermbg=1 cterm=bold
  hi Underlined	ctermfg=4 cterm=bold,underline

  hi MatchParen ctermfg=0 ctermbg=7 cterm=bold

  hi TabLine	ctermfg=4 ctermbg=7 cterm=none
  hi TabLineSel ctermfg=7 ctermbg=4 cterm=none
  hi TabLineFill cterm=reverse
endif


