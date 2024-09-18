::Hardened.HooksMod.hook("scripts/items/weapons/greenskins/orc_metal_club", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.Value = 400;		// In Vanilla this is 300
		this.m.RegularDamage = 60;		// In Vanilla this is 30
		this.m.RegularDamageMax = 60;	// In Vanilla this is 50
		this.m.ArmorDamageMult = 1.1;	// In Vanilla this is 0.9

		this.m.Reach = 5;
	}

	q.onEquip = @() function()
	{
		this.weapon.onEquip();

		this.addSkill(::Reforged.new("scripts/skills/actives/bash", function(o) {
			o.m.ActionPointCost += 1;
			o.m.FatigueCost -= 3;	// So that we land on 15 when we factor in the 5 orc fatigue
		}));

		this.addSkill(::Reforged.new("scripts/skills/actives/knock_out", function(o) {
			o.m.StunChance = 100;
		}));
	}
});
