
var FSO = WScript.CreateObject('Scripting.FileSystemObject');
var SH = WScript.CreateObject('WScript.Shell');

function chdirToScriptParentDir() {
	SH.CurrentDirectory = FSO.GetParentFolderName(WScript.ScriptFullName);
}
function debug(msg) {
	WScript.Echo("[DEBUG] " + msg);
}
function info(msg) {
	WScript.Echo("[INFO] " + msg);
}
function warn(msg) {
	WScript.Echo("[WARN] " + msg);
}
function getDotfilesList() {
	var READONLY = 1, NO_CREATE = false;
	var conf = FSO.OpenTextFile("dotfiles.lst.mswin", READONLY, NO_CREATE);
	var ret = [];
	try {
		while (! conf.AtEndOfStream) {
			var line = conf.ReadLine();
			if (/^\s*(\S+)(?:\s+(\S+))?\s*$/.test(line)) {
				ret.push({
					src: RegExp.$1,
					dst: (RegExp.$2 !== '' ? RegExp.$2 : RegExp.$1)
				});
			}
			else {
				debug("Ignoring line: " + line);
			}
		}
	}
	finally {
		conf.Close();
	}
	return ret;
}
function linkToHome(filelist) {
	var HOME = SH.ExpandEnvironmentStrings("%HOME%");
	if (HOME === '%HOME%') {
		HOME = SH.ExpandEnvironmentStrings("%USERPROFILE%");
	}

	var i;
	for (i = 0; i < filelist.length; i++) {
		var src = FSO.BuildPath("dotfiles", filelist[i].src);
		var dst = FSO.BuildPath(HOME, filelist[i].dst);
		info(dst + " ==> " + src);
		if (FSO.FolderExists(dst) || FSO.FileExists(dst)) {
			warn(dst + " exists, skipping ...");
			continue;
		}
		if (FSO.FolderExists(src)) {
			SH.Run("cmd /c mklink /j " + dst + " " + src);
		}
		else if (FSO.FileExists(src)) {
			SH.Run("cmd /c mklink /h " + dst + " " + src);
		}
		else {
			warn("'" + src + "' does not exist...");
		}
	}
}

chdirToScriptParentDir();
var filelist = getDotfilesList();
linkToHome(filelist);
