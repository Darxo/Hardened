::Hardened.HooksMod.hook("scripts/items/weapons/rf_swordstaff", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.StaminaModifier = -12;	// Reforged: -10
	}

	// Overwrite, to replace rf_overhead_strike_swordstaff_skill on this weapon with overhead_strike
	q.onEquip = @() function()
	{
		this.weapon.onEquip();

		local prong = ::new("scripts/skills/actives/prong_skill");
		this.addSkill(prong);

		this.addSkill(::Reforged.new("scripts/skills/actives/overhead_strike", function(o) {
			o.m.IsIgnoredAsAOO = true;
		}));

		this.addSkill(::Reforged.new("scripts/skills/actives/spearwall", function(o) {
			o.m.ActionPointCost += 2;
			o.m.FatigueCost += 5;
			o.m.Icon = "skills/active_124.png";
			o.m.IconDisabled = "skills/active_124_sw.png";
			o.m.Overlay = "active_124";
			o.m.BaseAttackName = prong.getName();
		}));
	}
});
