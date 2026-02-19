// generate all msu related things. This should happen early because other parts of the code might expect these to be fetchable at an early point
::includeFiles(::IO.enumerateFiles("mod_hardened/msu"));

// Our adjustments to Unified Perk Descriptions mod are in here and it needs priority over the strings/strings inclusion
::includeFiles(::IO.enumerateFiles("mod_hardened/api/hooks/mods"));

// Namespaces are not self-contained and usualy dont require other namespaces. They should load very early
::includeFiles(::IO.enumerateFiles("mod_hardened/namespaces"));

// Load global variables
::includeFiles(::IO.enumerateFiles("scripts/mods/mod_hardened"));

::include("mod_hardened/hooks/config/strings/strings");	// This needs priority, because perk_defs hooks build upon this
::include("mod_hardened/reforged/reach");	// This file needs priority

::includeFiles(::IO.enumerateFiles("mod_hardened/reforged"));

// API Hooks
::includeFiles(::IO.enumerateFiles("mod_hardened/api"));

// Regular Hooks
::includeFiles(::IO.enumerateFiles("mod_hardened/hooks"));

// Crock Pot specific hooks
if (::mods_getRegisteredMod("mod_crock_pot") != null)
{
	::includeFiles(::IO.enumerateFiles("mod_hardened/crock_pot_hooks"));
}
