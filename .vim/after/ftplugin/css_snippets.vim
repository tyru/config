if !exists('loaded_snippet') || &cp
    finish
endif

let st = g:snip_start_tag
let et = g:snip_end_tag
let cd = g:snip_elem_delim

exec "Snippet visibility ".st.et.";"
exec "Snippet list list-style-image: url(".st.et.");"
exec "Snippet text text-shadow: rgb(".st.et.", ".st.et.", ".st.et.", ".st.et." ".st.et." ".st.et.";"
exec "Snippet overflow overflow: ".st.et.";"
exec "Snippet white white-space: ".st.et.";"
exec "Snippet clear cursor: url(".st.et.");"
exec "Snippet margin padding-top: ".st.et.";"
exec "Snippet background background #".st.et." url(".st.et.") ".st.et." ".st.et." top left/top center/top right/center left/center center/center right/bottom left/bottom center/bottom right/x% y%/x-pos y-pos')".et.";"
exec "Snippet word word-spaceing: ".st.et.";"
exec "Snippet z z-index: ".st.et.";"
exec "Snippet vertical vertical-align: ".st.et.";"
exec "Snippet marker marker-offset: ".st.et.";"
exec "Snippet cursor cursor: ".st.et.";"
exec "Snippet border border-right: ".st.et."px ".st.et." #".st.et.";"
exec "Snippet display display: block;"
exec "Snippet padding padding: ".st.et." ".st.et.";"
exec "Snippet letter letter-spacing: ".st.et."em;"
exec "Snippet color color: rgb(".st.et.", ".st.et.", ".st.et.");"
exec "Snippet font font-weight: ".st.et.";"
exec "Snippet position position: ".st.et.";"
exec "Snippet direction direction: ".st.et.";"
exec "Snippet float float: ".st.et.";"
