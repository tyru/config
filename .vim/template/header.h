#ifndef <% eval: substitute(toupper(expand('%:t:r')), '\.', '_', 'g') . '_H' %>
#define <% eval: substitute(toupper(expand('%:t:r')), '\.', '_', 'g') . '_H' %>

#if defined(_MSC_VER) && (_MSC_VER >= 1020)
# pragma once
#endif




#endif
