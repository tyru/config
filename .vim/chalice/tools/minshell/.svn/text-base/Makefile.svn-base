# vim:set ts=8 sts=4 sw=4 tw=0:
# Last Change: 28-May-2003.

TARGET = minshell.exe minshell.dll
OBJS = minshell.obj
LIBS = kernel32.lib user32.lib shell32.lib
CFLAGS = /nologo /O1 /Os
LFLAGS = /nologo /SUBSYSTEM:WINDOWS /NODEFAULTLIB /ALIGN:4096

CC = cl
LD = link

default: $(TARGET)

minshell.exe: minshell-exe.obj
	$(LD) $(LFLAGS) /ENTRY:EntryExe $(LIBS) /OUT:$@ $**

minshell.dll: minshell-dll.obj
	$(LD) $(LFLAGS) $(LIBS) /OUT:$@ /DLL /NOENTRY $**
#	$(LD) $(LFLAGS) $(LIBS) /OUT:$@ /DLL /ENTRY:EntryDll $**

minshell-exe.obj: minshell.c
	$(CC) $(CFLAGS) /DVERYSMALL /c /Fo$@ $**

minshell-dll.obj: minshell.c
	$(CC) $(CFLAGS) /DBUILD_DLL /c /Fo$@ $**

clean :
	-del /F *.obj
	-del /F *.res
	-del /F *.exp
	-del /F *.lib

distclean: clean
	-del /F *.exe
	-del /F *.dll
