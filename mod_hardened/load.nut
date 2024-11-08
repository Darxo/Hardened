::include("mod_hardened/msu_settings");		// generate all msu mod settings

::include("mod_hardened/msu_settings");

::include("mod_hardened/reforged/reach");	// This file needs priority
::includeFiles(::IO.enumerateFiles("mod_hardened/reforged"));

::include("mod_hardened/global_helper_functions");

// API Hooks
::includeFiles(::IO.enumerateFiles("mod_hardened/api"));

// Regular Hooks
::includeFiles(::IO.enumerateFiles("mod_hardened/hooks"));
