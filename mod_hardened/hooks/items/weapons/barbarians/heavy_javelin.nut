::Hardened.HooksMod.hook("scripts/items/weapons/barbarians/heavy_javelin", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.Value = 500;				// In Vanilla this is 300
		this.m.StaminaModifier = 0;	// In Vanilla this is -8
		this.m.AmmoMax = 5;				// In Vanilla this is 5
		this.m.RegularDamage = 40;		// In Vanilla this is 35
		this.m.RegularDamageMax = 50;	// In Vanilla this is 50
		this.m.ArmorDamageMult = 0.85;	// In Vanilla this is 0.8
		this.m.AdditionalAccuracy = 0;	// In Vanilla this is -5

		this.m.AmmoCost = 2;			// In Vanilla this is 3

		this.m.AmmoWeight = 3.0;
	}

	q.onEquip = @() function()
	{
		this.weapon.onEquip();
		local throwJavelinSkill = ::Reforged.new("scripts/skills/actives/throw_javelin", function(o) {
			o.m.ActionPointCost += 1;
			o.m.FatigueCost += 3;
		});
		this.addSkill(throwJavelinSkill);
	}

	q.onCombatStarted = @(__original) function()
	{
		__original();
		if (!this.getContainer().getActor().isPlayerControlled())
		{
			this.m.Ammo = 4;	// Otherwise NPCs are stuck too long with throwing
		}
	}
});
