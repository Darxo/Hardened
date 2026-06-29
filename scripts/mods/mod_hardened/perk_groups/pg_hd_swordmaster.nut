this.pg_hd_swordmaster <- ::inherit(::DynamicPerks.Class.PerkGroup, {
	m = {},
	function create()
	{
		this.m.ID = "pg.hd_swordmaster";
		this.m.Name = "Swordmaster";
		this.m.Icon = "ui/perk_groups/rf_swordmaster.png";
		this.m.Tree = [
			[],
			[],
			[
				"perk.hd_zweikampf",
			],
			[],
			[
				"perk.hd_precise",
			],
			[],
			[
				"perk.hd_versatile",
			],
		];
	}

	function getPerkGroupMultiplier( _groupID, _perkTree )
	{
		switch (_groupID)
		{
			case "pg.rf_sword":
				return -1;
		}
	}
});
