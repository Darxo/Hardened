::Hardened.HooksMod.hook("scripts/items/weapons/goedendag", function(q) {
	// We overwrite, because there is currently no other way to cleanly remove item skills
	// Removal during the same onEquip does not work as the skills dont seem to be added yet completely
	// And even then there is still the issue with the MSU Dummyplayer, who will likely not realize the missing skill for item tooltip purposes
	q.onEquip = @() function()
	{
		this.weapon.onEquip();

		this.addSkill(::Reforged.new("scripts/skills/actives/thrust", function(o) {
			o.m.Icon = "skills/active_128.png";
			o.m.IconDisabled = "skills/active_128_sw.png";
			o.m.Overlay = "active_128";
			o.m.ActionPointCost += 1;
			o.m.FatigueCost += 5;
		}));

		this.addSkill(::Reforged.new("scripts/skills/actives/knock_out", function(o) {
			o.m.Icon = "skills/active_127.png";
			o.m.IconDisabled = "skills/active_127_sw.png";
			o.m.Overlay = "active_127";
			o.m.ActionPointCost += 1;
			o.m.StunChance = 100;	// In Vanilla this is 75
		}));
	}
});
