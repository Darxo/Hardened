::Hardened.HooksMod.hook("scripts/items/weapons/woodcutters_axe", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.RegularDamage = 40;		// Vanilla: 35
		this.m.RegularDamageMax = 65;	// Vanilla: 70
	}

	// Overwrite, because we completely remove any Reforged AP and Fatigue discount on skills
	q.onEquip = @() { function onEquip()
	{
		this.weapon.onEquip();

		this.addSkill(::Reforged.new("scripts/skills/actives/split_man"));
		this.addSkill(::Reforged.new("scripts/skills/actives/round_swing"));
		this.addSkill(::Reforged.new("scripts/skills/actives/split_shield"));
	}}.onEquip;
});
