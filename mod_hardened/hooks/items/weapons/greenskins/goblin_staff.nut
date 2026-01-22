::Hardened.HooksMod.hook("scripts/items/weapons/greenskins/goblin_staff", function(q) {
	q.create = @(__original) function()
	{
		__original();

		this.m.StaminaModifier = -8;	// Vanilla: -4
	}

	// Overwrite, because we want to revert Reforged discounts
	q.onEquip = @() function()
	{
		this.weapon.onEquip();
		this.addSkill(::new("scripts/skills/actives/bash"));
		this.addSkill(::new("scripts/skills/actives/knock_out"));
	}
});
