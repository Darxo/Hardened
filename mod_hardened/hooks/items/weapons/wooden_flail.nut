::Hardened.HooksMod.hook("scripts/items/weapons/wooden_flail", function(q) {
	q.create = @(__original) function()
	{
		__original();

		this.m.Reach = 3;		// In Reforged this is 2
	}

	// We overwrite Reforged skill additions, because we dont hand out any discounts
	q.onEquip = @() { function onEquip()
	{
		this.weapon.onEquip();

		this.addSkill(::Reforged.new("scripts/skills/actives/flail_skill", function(o) {
			o.m.Icon = "skills/active_62.png";
			o.m.IconDisabled = "skills/active_62_sw.png";
			o.m.Overlay = "active_62";
		}));

		this.addSkill(::Reforged.new("scripts/skills/actives/lash_skill", function(o) {
			o.m.Icon = "skills/active_94.png";
			o.m.IconDisabled = "skills/active_94_sw.png";
			o.m.Overlay = "active_94";
		}));
	}}.onEquip;
});
