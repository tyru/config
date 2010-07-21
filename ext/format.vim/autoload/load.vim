runtime plugin/load.vim
function load#LoadFuncdict(...)
    return call("LoadFuncdict", a:000, {})
endfunction

