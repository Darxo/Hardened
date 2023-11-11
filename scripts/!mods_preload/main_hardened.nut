::Hardened <- {
	ID = "mod_hardened",
	Name = "Hardened",
	Version = "0.2.5",
	GitHubURL = "https://github.com/Darxo/Hardened",
}

::Hardened.HooksMod <- ::Hooks.register(::Hardened.ID, ::Hardened.Version, ::Hardened.Name);
::Hardened.HooksMod.require(["mod_reforged"]);

::Hardened.HooksMod.queue(">mod_reforged", function() {
	::Hardened.Mod <- ::MSU.Class.Mod(::Hardened.ID, ::Hardened.Version, ::Hardened.Name);

	::Hardened.Mod.Registry.addModSource(::MSU.System.Registry.ModSourceDomain.GitHub, ::Hardened.GitHubURL);
	::Hardened.Mod.Registry.setUpdateSource(::MSU.System.Registry.ModSourceDomain.GitHub);

	::include("mod_hardened/load");		// Load Hardened-Adjustments and other hooks

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
