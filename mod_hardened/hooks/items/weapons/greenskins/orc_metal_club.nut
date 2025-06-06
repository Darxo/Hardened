::Hardened.HooksMod.hook("scripts/items/weapons/greenskins/orc_metal_club", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.Value = 400;		// In Vanilla this is 300
		this.m.RegularDamage = 40;		// In Vanilla this is 30
		this.m.RegularDamageMax = 60;	// In Vanilla this is 50

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
