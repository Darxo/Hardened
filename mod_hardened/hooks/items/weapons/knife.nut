::Hardened.HooksMod.hook("scripts/items/weapons/knife", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.RegularDamageMax = 20;	// Vanilla: 25
	}

	// We overwrite Reforged skill additions, because we dont hand out any discounts
	q.onEquip = @() { function onEquip()
	{
		this.weapon.onEquip();
		this.addSkill(::new("scripts/skills/actives/stab"));
		this.addSkill(::new("scripts/skills/actives/puncture"));
	}}.onEquip;
});
