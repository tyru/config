if exists("b:__STRUCTURES_C_LIKE_XPT_VIM__") 
    finish 
endif
let b:__STRUCTURES_C_LIKE_XPT_VIM__ = 1 

" containers
let [s:f, s:v] = XPTcontainer() 

" inclusion
XPTemplateDef

XPT enum hint=enum\ {\ ..\ }
enum `enumName^
{
    `elem^`...^,
    `subElem^`...^
}`cursor^;


XPT struct hint=struct\ {\ ..\ }
struct `structName^
{
    `type^ `field^;`...^
    `type^ `field^;`...^
}`cursor^;


XPT bitfield hint=struct\ {\ ..\ :\ n\ }
struct `structName^
{
    `type^ `field^ : `bits^;`...^
    `type^ `field^ : `bits^;`...^
}`cursor^;


