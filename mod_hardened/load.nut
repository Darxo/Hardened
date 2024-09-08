::include("mod_hardened/hooks/msu");	// This file needs priority as it contains new global functions

::include("mod_hardened/reforged/reach");	// This file needs priority
::includeFiles(::IO.enumerateFiles("mod_hardened/reforged"));

::include("mod_hardened/global_helper_functions");

::includeFiles(::IO.enumerateFiles("mod_hardened/hooks"));		// This will load and execute all hooks that you created
