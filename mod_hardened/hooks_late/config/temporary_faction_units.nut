{	// Beasts
	::Hardened.Global.addTemporaryEntity(
		"HD_HyenaHigh",
		"Frenzied Hyena",
		"Frenzied Hyenas",
		::Const.EntityIcon[::Const.EntityType.Hyena],
		::Const.EntityType.getDefaultFaction(::Const.EntityType.Hyena),
		"scripts/entity/tactical/enemies/hyena_high",
		::Const.EntityType.Hyena
	);

	::Hardened.Global.addTemporaryEntity(
		"HD_DirewolfHIGH",
		"Frenzied Direwolf",
		"Frenzied Direwolfs",
		::Const.EntityIcon[::Const.EntityType.Direwolf],
		::Const.EntityType.getDefaultFaction(::Const.EntityType.Direwolf),
		"scripts/entity/tactical/enemies/direwolf_high",
		::Const.EntityType.Direwolf
	);
	::Hardened.Global.addEntityFallback("scripts/entity/tactical/enemies/direwolf_bodyguard", ::Const.EntityType.Direwolf, ::Const.EntityType.HD_DirewolfHIGH);

	::Hardened.Global.addTemporaryEntity(
		"HD_Ghoul",
		"Medium Nachzehrer",
		"Medium Nachzehrers",
		::Const.EntityIcon[::Const.EntityType.Ghoul],
		::Const.EntityType.getDefaultFaction(::Const.EntityType.Ghoul),
		"scripts/entity/tactical/enemies/ghoul_medium",
		::Const.EntityType.Ghoul
	);

	::Hardened.Global.addTemporaryEntity(
		"HD_GhoulHIGH",
		"Large Nachzehrer",
		"Large Nachzehrers",
		::Const.EntityIcon[::Const.EntityType.Ghoul],
		::Const.EntityType.getDefaultFaction(::Const.EntityType.Ghoul),
		"scripts/entity/tactical/enemies/ghoul_high",
		::Const.EntityType.Ghoul
	);
}

{	// Bandits
	{ 	// Tough Bandits
		// Vandal (Tier 1 Tough)
		// In Reforged this is the Tier 2 Tough Brigand and sharing the name "Pillager" with the Tier 2 Balanced Brigand
		::Hardened.Global.addTemporaryEntity(
			"HD_BrigandVandal",
			"Brigand Vandal",
			"Brigand Vandals",
			"hd_bandit_pillager_orientation",
			::Const.EntityType.getDefaultFaction(::Const.EntityType.RF_BanditPillager),
			"scripts/entity/tactical/enemies/rf_bandit_pillager_tough",
			::Const.EntityType.RF_BanditPillager
		);

		// Pillager (Tier 2 Tough)
		// In Reforged this is the Tier 3 Tough Brigand and sharing the name "Raider" with the Tier 3 Balanced Brigand
		::Hardened.Global.addTemporaryEntity(
			"HD_BanditPillager",
			"Brigand Pillager",
			"Brigand Pillagers",
			"hd_bandit_outlaw_orientation",
			::Const.EntityType.getDefaultFaction(::Const.EntityType.BanditRaider),
			"scripts/entity/tactical/enemies/rf_bandit_raider_tough",
			::Const.EntityType.BanditRaider
		);

		// Marauder (Tier 3 Tough)
		// In Reforged this is the Tier 3 Tough Brigand and sharing the name "Marauder" with the Tier 3 Balanced Brigand
		::Hardened.Global.addTemporaryEntity(
			"HD_BanditMarauder",
			"Brigand Marauder",
			"Brigand Marauders",
			"hd_bandit_marauder_orientation",
			::Const.EntityType.getDefaultFaction(::Const.EntityType.RF_BanditMarauder),
			"scripts/entity/tactical/enemies/rf_bandit_marauder_tough",
			::Const.EntityType.RF_BanditMarauder
		);
	}

	{	// Fast Brigands
		// Scoundrel (Tier 1 Fast)
		// We use a temporary entity so that this unit has the name "Scoundrel" (Reforged: Vandal) while on the world map
		::Hardened.Global.addTemporaryEntity(
			"HD_BrigandScoundrel",
			"Brigand Scoundrel",
			"Brigand Scoundrels",
			"rf_bandit_vandal_orientation",
			::Const.EntityType.getDefaultFaction(::Const.EntityType.RF_BanditVandal),
			"scripts/entity/tactical/enemies/rf_bandit_vandal",
			::Const.EntityType.RF_BanditVandal
		);

		// Robber (Tier 2 Fast)
		// We use a temporary entity so that this unit has the name "Robber" (Reforged: Outlaw) while on the world map
		::Hardened.Global.addTemporaryEntity(
			"HD_BrigandRobber",
			"Brigand Robber",
			"Brigand Robber",
			"rf_bandit_outlaw_orientation",
			::Const.EntityType.getDefaultFaction(::Const.EntityType.RF_BanditOutlaw),
			"scripts/entity/tactical/enemies/rf_bandit_outlaw",
			::Const.EntityType.RF_BanditOutlaw
		);

		// Killer (Tier 3 Fast)
		// We use a temporary entity so that this unit has the name "Killer" (Reforged: Highwayman) while on the world map
		::Hardened.Global.addTemporaryEntity(
			"HD_BrigandKiller",
			"Brigand Killer",
			"Brigand Killer",
			"rf_bandit_highwayman_orientation",
			::Const.EntityType.getDefaultFaction(::Const.EntityType.RF_BanditHighwayman),
			"scripts/entity/tactical/enemies/rf_bandit_highwayman",
			::Const.EntityType.RF_BanditHighwayman
		);
	}
}

// Using editEntity is not enough to adjust the costs of the units accordingly, so we need to do that here too
foreach (unitDef in ::Reforged.Spawns.Units)
{
	// We dont care what Cost was defined by Reforged previously, as all enemy costs have been re-designed by Reforged
	unitDef.Cost <- ::Const.World.Spawn.Troops[unitDef.Troop].Cost;
}
