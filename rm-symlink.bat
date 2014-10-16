@echo off

cd %~dp0
if not errorlevel 0 goto err_chdir

if not defined HOME set HOME=%USERPROFILE%

setlocal enabledelayedexpansion
for /f %%F in (dotfiles.lst) do (
	set srcfile=%%F
	set dstfile=%%F

	rem ### Convert destination folder name (e.g., src:.vim dst:vimfiles)
	for /f "tokens=1,2*" %%x in (dotfiles.lst.mswin) do (
		if "%%x"=="%%F" (
			set dstfile=%%y
		)
	)
	set srcfile=dot!srcfile!
	set srcfile=!srcfile:/=\!

	set dstfile=!dstfile!
	set dstfile=!dstfile:/=\!

	set src=!CD!\dotfiles\!srcfile!
	set dst=!HOME!\!dstfile!

	if exist "!dst!" (
		if exist "!src!\" (
			rem ### Folder(Junction)
			rmdir "!dst!"
		) else (
			rem ### File(Hardlink)
			del "!dst!"
		)
	)
)
endlocal

goto EOF
rem ====== END ======

:err_chdir
echo error: could not chdir into script directory.

:EOF
