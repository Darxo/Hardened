::Hardened.HooksMod.hook("scripts/items/weapons/warfork", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.Value = 400;		// In Reforged this is 600, In Vanilla this is 400
		this.m.StaminaModifier = -14;	// In Vanilla this is -10
	}

	// We overwrite Reforged skill additions, because we dont hand out any discounts
	q.onEquip = @() { function onEquip()
	{
		this.weapon.onEquip();

		local prong = ::Reforged.new("scripts/skills/actives/prong_skill", function(o) {
			o.m.Icon = "skills/active_174.png";
			o.m.IconDisabled = "skills/active_174_sw.png";
			o.m.Overlay = "active_174";
		});

		this.addSkill(prong);

		this.addSkill(::Reforged.new("scripts/skills/actives/spearwall", function(o) {
			o.m.Icon = "skills/active_173.png";
			o.m.IconDisabled = "skills/active_173_sw.png";
			o.m.Overlay = "active_173";
			o.m.BaseAttackName = prong.getName();
		}));
	}}.onEquip;
});
