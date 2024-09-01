::mods_registerJS("mod_hardened/setup.js");

/*
local prefixLen = "ui/mods/".len();
foreach (file in ::IO.enumerateFiles("ui/mods/mod_hardened/js_hooks"))
{
	::mods_registerJS(file.slice(prefixLen) + ".js");
}
*/
