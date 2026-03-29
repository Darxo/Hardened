::Hardened.HooksMod.hook("scripts/items/weapons/hooked_blade", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.Value = 550;		// In Vanilla this is 700
		this.m.RegularDamageMax = 60;	// In Vanilla this is 70
	}

	// We overwrite Reforged skill additions, because we dont hand out any discounts
	q.onEquip = @() { function onEquip()
	{
		this.weapon.onEquip();

		this.addSkill(::Reforged.new("scripts/skills/actives/strike_skill", function(o) {
			o.m.Icon = "skills/active_93.png";
			o.m.IconDisabled = "skills/active_93_sw.png";
			o.m.Overlay = "active_93";
		}));

		this.addSkill(::new("scripts/skills/actives/hook"));
	}}.onEquip;
});
