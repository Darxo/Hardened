::Hardened.HooksMod.hook("scripts/entity/tactical/enemies/zombie_knight", function(q) {
	q.onInit = @(__original) function()
	{
		__original();
		this.m.ResurrectionChance = 100;	// In Vanilla this is 90
		this.getBaseProperties().Hitpoints -= 10;
	}

	q.onSpawned = @(__original) function()
	{
		__original();
		this.getSkills().add(::new("scripts/skills/perks/perk_overwhelm"));	// Re-Add Overwhelm because it was removed from base zombie class
	}

	q.onResurrected = @(__original) function( _info)
	{
		__original(_info);
		if (!_info.IsHeadAttached)
		{
			this.getSkills().add(::new("scripts/skills/effects/hd_headless_effect"));
		}
	}

	q.assignRandomEquipment = @(__original) function()
	{
		__original();
		::Hardened.util.replaceMainhand(this, "scripts/items/weapons/winged_mace", ["weapon.morning_star"]);
		::Hardened.util.replaceMainhand(this, "scripts/items/weapons/fighting_axe", ["weapon.hand_axe"]);
	}
});
