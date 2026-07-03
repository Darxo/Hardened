// Custom unit that is only spawned during the ijirok fight by the teleport_skill
this.hd_trickster_hollenhund <- ::inherit("scripts/entity/tactical/enemies/rf_hollenhund", {
	m = {},

	function onInit()
	{
		this.rf_hollenhund.onInit();

		// We don't want this character to be farmed forever by the player for loot and xp
		this.getSkills().add(::new("scripts/skills/special/hd_unworthy_effect"));
		this.getSkills().add(::new("scripts/skills/special/hd_worthless_effect"));
	}
});
