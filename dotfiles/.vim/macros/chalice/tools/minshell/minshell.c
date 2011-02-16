/* vim:set ts=8 sts=4 sw=4 tw=0: */
/*
 * minshell.c -
 *
 * Last Change: 31-May-2003.
 * Written By:	MURAOKA Taro <koron@tka.att.ne.jp>
 */

#define WIN32_LEAN_AND_MEAN
#include <windows.h>
#include <shellapi.h>

#if 0
#define CMDSTR "open"
#else
#define CMDSTR NULL
#endif

#ifdef BUILD_DLL

    _declspec(dllexport) char*
ExecuteOpen(char *url)
{
    (void)ShellExecute(NULL, CMDSTR, url, NULL, NULL, SW_SHOW);
    return NULL;
}

#if 0
    BOOL WINAPI
EntryDll(HANDLE h, DWORD dw, LPVOID lp)
{
    return TRUE;
}
#endif

#else /* BUILD_DLL */

#ifndef VERYSMALL
    int WINAPI
WinMin(HINSTANCE hInstance, HINSTANCE hPrevInstance,
	LPSTR lpCmdLine, int nCmdShow)
#else
    void
EntryExe()
#endif
{
    char *url = GetCommandLine();
    int retval;
    if (*url == '"')
	for (++url; *url != '"' && *url != '\0'; )
	    ++url;
    while (*url != ' ' && *url != '\0')
	++url;
    while (*url == ' ' && *url != '\0')
	++url;
    retval = (int)ShellExecute(NULL, CMDSTR, url, NULL, NULL, SW_SHOW);
#ifndef VERYSMALL
    return retval;
#else
    ExitProcess(retval);
#endif
}

#endif /* BUILD_DLL */
