::Hardened.Const.getAmmoType <- function( _ammoType )
{
	foreach (ammoType in ::Hardened.Const.AmmoType)
	{
		if (ammoType.Type == _ammoType)
		{
			return ammoType;
		}
	}

	return ::Hardened.Const.AmmoType[0];	// None
}
::Hardened.Const.AmmoType <- [	// This mirrors the Vanilla Array ::Const.Items.AmmoType
	{
		Type = ::Const.Items.AmmoType.None,
		Name = "None",
		NamePlural = "None",
	},
	{
		Type = ::Const.Items.AmmoType.Arrows,
		Name = "Arrow",
		NamePlural = "Arrows",
	},
	{
		Type = ::Const.Items.AmmoType.Bolts,
		Name = "Bolt",
		NamePlural = "Bolts",
	},
	{
		Type = ::Const.Items.AmmoType.Spears,
		Name = "Spear",
		NamePlural = "Spears",
	},
	{
		Type = ::Const.Items.AmmoType.Powder,
		Name = "Powder",
		NamePlural = "Powder",
	},
];

// These types of settlements are that many tiles further apart during map generation
::Hardened.Const.SettlementsSpaceModifier <- {
	SmallFort = 2,
	Small = -2,
	Medium = 2,
	Large = 10,
}

// These are the five tiers for resource mults that can be assigned to any faction
// Tier 1 = bad for the player; Tier 5 = good for the player
::Hardened.Const.ResourceTierMult <- {
	Tier1 = 1.4,
	Tier2 = 1.2,
	Tier3 = 1.0,
	Tier4 = 0.8,
	Tier5 = 0.6,
};

// These are the five tiers for experience mults that can be assigned to any faction
// Tier 1 = bad for the player; Tier 5 = good for the player
::Hardened.Const.ExperienceTierMult <- {
	Tier1 = 0.6,
	Tier2 = 1.0,
	Tier3 = 1.2,
	Tier4 = 1.4,
	Tier5 = 1.6,
};
