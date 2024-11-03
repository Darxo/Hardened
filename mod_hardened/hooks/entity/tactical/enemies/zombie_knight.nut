::Hardened.HooksMod.hook("scripts/entity/tactical/enemies/zombie_knight", function(q) {
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
