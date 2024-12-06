this.pg_special_hd_tactician <- ::inherit(::DynamicPerks.Class.SpecialPerkGroup, {
	m = {},
	function create()
	{
		this.special_perk_group.create();
		this.m.ID = "pg.rf_tactician";
		this.m.Name = "Tactician";
		this.m.Icon = "ui/perk_groups/rf_tactician.png";
		this.m.Chance = 3;	// This is the same chance as Leadership in Reforged has
		this.m.Tree = [
			[],
			["perk.rf_bestial_vigor"],	// New: Bestial Vigor (Backup Plan)
			["perk.rf_shield_sergeant"],
			["perk.rf_onslaught"],
			["perk.rf_hold_steady"],
			[],
			["perk.rf_blitzkrieg"],
		];
	}
});
