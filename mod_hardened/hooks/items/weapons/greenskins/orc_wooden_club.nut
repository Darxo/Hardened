::Hardened.HooksMod.hook("scripts/items/weapons/greenskins/orc_wooden_club", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.Value = 300;		// In Vanilla this is 150
		this.m.RegularDamage = 30;		// In Vanilla this is 25
		this.m.RegularDamageMax = 50;	// In Vanilla this is 40
		this.m.ArmorDamageMult = 0.9;	// In Vanilla this is 0.75

		this.setWeight(15);		// In Vanilla this is 20

		this.m.Reach = 4;
	}

	q.onEquip = @() function()
	{
		this.weapon.onEquip();

		this.addSkill(::Reforged.new("scripts/skills/actives/bash", function(o) {
			o.m.ActionPointCost += 1;
		}));

		this.addSkill(::Reforged.new("scripts/skills/actives/knock_out", function(o) {
			o.m.StunChance = 100;
		}));
	}
});
