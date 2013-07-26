@echo off

cd %~dp0
if not errorlevel 0 goto err_chdir

if not defined home set home=%USERPROFILE%

setlocal enabledelayedexpansion
for /f %%F in (dotfiles.lst) do (
	set src=!CD!\dotfiles\%%F
	set src=!src:/=\!
	set dst=!home!\%%F
	set dst=!dst:/=\!

	if exist "!dst!" (
		echo !dst! exists, skipping ...
	) else (
		for %%D in ("!dst!") do (
			if not exist "%%~dpD" mkdir "%%~dpD"
		)
		if exist "!src!\" (
			rem ### Folder(Junction)
			mklink /j "!dst!" "!src!"
		) else (
			rem ### File(Hardlink)
			mklink /h "!dst!" "!src!"
		)
	)
)
endlocal

goto EOF
rem ====== END ======

:err_chdir
echo error: could not chdir into script directory.

:EOF
