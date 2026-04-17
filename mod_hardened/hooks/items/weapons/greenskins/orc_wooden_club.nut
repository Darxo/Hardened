::Hardened.HooksMod.hook("scripts/items/weapons/greenskins/orc_wooden_club", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.Value = 450;		// In Vanilla this is 150
		this.m.RegularDamage = 40;		// In Vanilla this is 25
		this.m.RegularDamageMax = 60;	// In Vanilla this is 40
		this.m.ArmorDamageMult = 0.9;	// In Vanilla this is 0.75

		this.m.Reach = 4;

		this.setWeight(18);		// In Vanilla this is 20
	}

	q.onEquip = @() function()
	{
		this.weapon.onEquip();

		this.addSkill(::Reforged.new("scripts/skills/actives/bash", function(o) {
			o.m.ActionPointCost += 1;
		}));

		this.addSkill(::new("scripts/skills/actives/strike_down_skill"));
	}
});
