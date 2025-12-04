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
