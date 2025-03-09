::Hardened.HooksMod.hook("scripts/items/weapons/barbarians/heavy_throwing_axe", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.RangeIdeal = 3;			// In Vanilla this is 4

		this.m.Value = 600;				// In Vanilla this is 300
		this.m.StaminaModifier = 0;	// In Vanilla this is -6
		this.m.AmmoMax = 5;				// In Vanilla this is 5
		this.m.RegularDamage = 45;		// In Vanilla this is 30
		this.m.RegularDamageMax = 60;	// In Vanilla this is 50
		this.m.ArmorDamageMult = 1.2;	// In Vanilla this is 1.15
		this.m.ChanceToHitHead = 10;	// In Vanilla this is 5
		this.m.AdditionalAccuracy = -10;	// In Vanilla this is -5

		this.m.AmmoCost = 4;			// In Vanilla this is 3 (the default)

		this.m.AmmoWeight = 3.0;
	}

	q.onEquip = @() function()
	{
		this.weapon.onEquip();
		local throwAxeSkill = ::Reforged.new("scripts/skills/actives/throw_axe", function(o) {
			o.m.ActionPointCost += 1;
			o.m.FatigueCost += 3;
		});
		this.addSkill(throwAxeSkill);
	}
});
