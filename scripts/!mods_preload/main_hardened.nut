::Hardened <- {
	ID = "mod_hardened",
	Name = "Hardened",
	Version = "0.3.3",
	GitHubURL = "https://github.com/Darxo/Hardened",
}

::Hardened.HooksMod <- ::Hooks.register(::Hardened.ID, ::Hardened.Version, ::Hardened.Name);
::Hardened.HooksMod.require(["mod_reforged"]);

::Hardened.HooksMod.queue(">mod_reforged", function() {
	::Hardened.Mod <- ::MSU.Class.Mod(::Hardened.ID, ::Hardened.Version, ::Hardened.Name);

	::Hardened.Mod.Registry.addModSource(::MSU.System.Registry.ModSourceDomain.GitHub, ::Hardened.GitHubURL);
	::Hardened.Mod.Registry.setUpdateSource(::MSU.System.Registry.ModSourceDomain.GitHub);

	::include("mod_hardened/load");		// Load Hardened-Adjustments and other hooks
	::include("mod_hardened/ui/load");	// Load Hardened JS Adjustments and Hooks

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

// Adjust Reforged Perk Groups
::Hardened.HooksMod.queue(">mod_reforged", function() {
	// Always Group
	foreach (row in ::DynamicPerks.PerkGroups.findById("pg.rf_always_1").getTree())
	{
		foreach (i, perk in row)
		{
			if (perk == "perk.bags_and_belts") row.remove(i);		// Remove Bags and Belts
		}
	}

	// Laborer Group
	foreach (row in ::DynamicPerks.PerkGroups.findById("pg.rf_laborer").getTree())
	{
		foreach (i, perk in row)
		{
			if (perk == "perk.bags_and_belts") row.remove(i);		// Remove Bags and Belts
		}
	}

	// Light Armor Group
	local pgLightArmorGroup = ::DynamicPerks.PerkGroups.findById("pg.rf_light_armor");
	pgLightArmorGroup.getTree()[0].push("perk.bags_and_belts");	// Add Bags and Belts
	foreach (row in pgLightArmorGroup.getTree())
	{
		foreach (i, perk in row)
		{
			if (perk == "perk.dodge") row.remove(i);	// Remove Dodge
		}
	}

	::DynamicPerks.addPerkGroupToTooltips();	// Update all perk tooltips to reflect the possible changes done to them by moving them around
}, ::Hooks.QueueBucket.AfterHooks);

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
