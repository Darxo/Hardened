::Hardened <- {
	ID = "hardened",
	Name = "Hardened",
	Version = "0.2.4",
	GitHubURL = "https://github.com/Darxo/Hardened",
}

::mods_registerMod(::Hardened.ID, ::Hardened.Version, ::Hardened.Name);

::mods_queue(::Hardened.ID, "mod_reforged", function()
{
	::Hardened.Mod <- ::MSU.Class.Mod(::Hardened.ID, ::Hardened.Version, ::Hardened.Name);

	::Hardened.Mod.Registry.addModSource(::MSU.System.Registry.ModSourceDomain.GitHub, ::Hardened.GitHubURL);
	::Hardened.Mod.Registry.setUpdateSource(::MSU.System.Registry.ModSourceDomain.GitHub);

	::include("mod_hardened/load");		// Load Reforged-Adjustments and other hooks

	// Remove the Fangshire Helmet
	foreach(index, itemScript in ::Const.World.Assets.NewCampaignEquipment)
	{
		if (itemScript == "scripts/items/helmets/legendary/fangshire")
		{
			::Const.World.Assets.NewCampaignEquipment.remove(index);
			break;
		}
	}
});

// Wipe all functions in the passed class
::Hardened.wipeFunctions <- function( _hookedClass )
{
	local toDelete = [];
	foreach (name, func in _hookedClass)
	{
		if (typeof func == "function") toDelete.push(name);
	}

	foreach(functionName in toDelete)
	{
		delete _hookedClass[functionName];
	}
}
