::Hardened <- {
	ID = "hardened",
	Name = "Hardened",
	Version = "0.2.0",
}

::mods_registerMod(::Hardened.ID, ::Hardened.Version, ::Hardened.Name);

::mods_queue(::Hardened.ID, "mod_reforged", function()
{
	::Hardened.Mod <- ::MSU.Class.Mod(::Hardened.ID, ::Hardened.Version, ::Hardened.Name);

	::include("mod_hardened/load");		// Load Reforged-Adjustments and other hooks

});
