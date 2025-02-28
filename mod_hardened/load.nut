::include("mod_hardened/msu_settings");		// generate all msu mod settings

// Namespaces are not self-contained and usualy dont require other namespaces. They should load very early
::includeFiles(::IO.enumerateFiles("mod_hardened/namespaces"));

::include("mod_hardened/hooks/config/strings/strings.nut");	// This needs priority, because perk_defs hooks build upon this
::include("mod_hardened/reforged/reach");	// This file needs priority

::includeFiles(::IO.enumerateFiles("mod_hardened/reforged"));

// API Hooks
::includeFiles(::IO.enumerateFiles("mod_hardened/api"));

// Regular Hooks
::includeFiles(::IO.enumerateFiles("mod_hardened/hooks"));
