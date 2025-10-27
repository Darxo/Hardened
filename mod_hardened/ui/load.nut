::Hooks.registerJS("ui/mods/mod_hardened/setup.js");

foreach (file in ::IO.enumerateFiles("ui/mods/mod_hardened/js_hooks"))
{
	::Hooks.registerJS(file + ".js");
}

foreach (file in ::IO.enumerateFiles("ui/mods/mod_hardened/js_hooks_late"))
{
	::Hooks.registerLateJS(file + ".js");
}

foreach (file in ::IO.enumerateFiles("ui/mods/mod_hardened/css_hooks"))
{
	::Hooks.registerCSS(file + ".css");
}
