// We re-initialize the Leadership group but as a regular Perk Group so that it is not treated as a special perk group
this.pg_hd_leadership <- ::inherit(::DynamicPerks.Class.PerkGroup, {
	m = {},
	function create()
	{
		this.m.ID = "pg.special.rf_leadership";	// We reuse the Reforged ID, to grant compatibility with existing multipliers on various characters
		this.m.Name = "Leadership";
		this.m.Icon = "ui/perk_groups/rf_leadership.png";
		this.m.Tree = [
			["perk.rf_supporter"],
			["perk.rally_the_troops"],
			["perk.fortified_mind"],
			[],
			["perk.rf_command"],
			[],
			["perk.inspiring_presence"],
		];
	}

	function getSelfMultiplier( _perkTree )
	{
		return 0.1;		// This is the same chance as Tactician in Reforged has
	}
});

