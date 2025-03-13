// generate all msu related things. This should happen early because other parts of the code might expect these to be fetchable at an early point
::includeFiles(::IO.enumerateFiles("mod_hardened/msu"));

// Namespaces are not self-contained and usualy dont require other namespaces. They should load very early
::includeFiles(::IO.enumerateFiles("mod_hardened/namespaces"));

::include("mod_hardened/hooks/config/strings/strings.nut");	// This needs priority, because perk_defs hooks build upon this
::include("mod_hardened/reforged/reach");	// This file needs priority

::includeFiles(::IO.enumerateFiles("mod_hardened/reforged"));

// API Hooks
::includeFiles(::IO.enumerateFiles("mod_hardened/api"));

// Regular Hooks
::includeFiles(::IO.enumerateFiles("mod_hardened/hooks"));
