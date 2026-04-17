::Hardened.HooksMod.hook("scripts/items/weapons/greenskins/orc_metal_club", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.Value = 600;		// In Vanilla this is 300
		this.m.RegularDamage = 45;		// In Vanilla this is 30
		this.m.RegularDamageMax = 65;	// In Vanilla this is 50
		this.m.ArmorDamageMult = 1.2;	// Vanilla: 0.9

		this.m.Reach = 4;

		this.setWeight(24);		// Vanilla: 20
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
