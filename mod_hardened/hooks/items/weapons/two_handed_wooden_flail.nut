::Hardened.HooksMod.hook("scripts/items/weapons/two_handed_wooden_flail", function(q) {
	q.create = @(__original) function()
	{
		__original();

		this.m.Value = 600;			// Vanilla: 500
		this.m.RegularDamage = 35; 		// Vanilla: 30
		this.m.RegularDamageMax = 70; 	// Vanilla: 60
		this.m.DirectDamageMult = 0.4; 	// Vanilla: 0.3

		this.m.Reach = 4;		// In Reforged this is 5
	}

	// Overwrite, because we completely remove any Reforged AP and Fatigue discount on skills
	q.onEquip = @() { function onEquip()
	{
		this.weapon.onEquip();

		this.addSkill(::Reforged.new("scripts/skills/actives/pound", function(o) {
			o.m.Icon = "skills/active_129.png";
			o.m.IconDisabled = "skills/active_129_sw.png";
			o.m.Overlay = "active_129";
		}));

		this.addSkill(::Reforged.new("scripts/skills/actives/thresh", function(o) {
			o.m.Icon = "skills/active_130.png";
			o.m.IconDisabled = "skills/active_130_sw.png";
			o.m.Overlay = "active_130";
		}));
	}}.onEquip;
});
