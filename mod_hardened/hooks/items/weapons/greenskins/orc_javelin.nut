::Hardened.HooksMod.hook("scripts/items/weapons/greenskins/orc_javelin", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.StaminaModifier = 0;		// In Vanilla this is -8
		this.m.AmmoMax = 4;				// In Vanilla this is 5
		this.m.RegularDamage = 35;		// In Vanilla this is 30
		this.m.RegularDamageMax = 45;	// In Vanilla this is 40

		this.m.AmmoCost = 1;			// In Vanilla this is 3

		this.m.AmmoWeight = 3.0;
	}

	q.onEquip = @() function()
	{
		this.weapon.onEquip();
		local throwJavelinSkill = ::Reforged.new("scripts/skills/actives/throw_javelin", function(o) {
			o.m.ActionPointCost += 1;
		});
		this.addSkill(throwJavelinSkill);
	}

	q.onCombatStarted = @(__original) function()
	{
		__original();
		if (!this.getContainer().getActor().isPlayerControlled())
		{
			this.m.Ammo = 3;	// Otherwise NPCs are stuck too long with throwing
		}
	}
});
