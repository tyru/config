syntax match TemplateMark /`\|\^/ contained
syntax match TemplateItem /`.\{-}\^/ contains=TemplateMark containedin=ALL

hi TemplateItem gui=none guifg=#5f4511 guibg=#efdfc1
hi TemplateMark gui=none guifg=#bfb39b guibg=#efdfc1
