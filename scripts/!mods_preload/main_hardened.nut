::Hardened <- {
	ID = "hardened",
	Name = "Hardened",
	Version = "0.1.0",
}

::mods_registerMod(::Hardened.ID, ::Hardened.Version, ::Hardened.Name);

::mods_queue(::Hardened.ID, "mod_reforged", function()
{
	::Hardened.Mod <- ::MSU.Class.Mod(::Hardened.ID, ::Hardened.Version, ::Hardened.Name);

	::includeFiles(::IO.enumerateFiles("mod_hardened/hooks"));		// This will load and execute all hooks that you created

});
