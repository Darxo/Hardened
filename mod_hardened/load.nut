
::include("mod_hardened/reforged/reach");	// This file needs priority
::includeFiles(::IO.enumerateFiles("mod_hardened/reforged"));

::includeFiles(::IO.enumerateFiles("mod_hardened/hooks"));		// This will load and execute all hooks that you created
