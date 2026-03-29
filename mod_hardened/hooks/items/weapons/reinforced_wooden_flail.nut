::Hardened.HooksMod.hook("scripts/items/weapons/reinforced_wooden_flail", function(q) {
	// We overwrite Reforged skill additions, because we dont hand out any discounts
	q.onEquip = @() { function onEquip()
	{
		this.weapon.onEquip();

		this.addSkill(::Reforged.new("scripts/skills/actives/flail_skill", function(o) {
			o.m.Icon = "skills/active_65.png";
			o.m.IconDisabled = "skills/active_65_sw.png";
			o.m.Overlay = "active_65";
		}));

		this.addSkill(::Reforged.new("scripts/skills/actives/lash_skill", function(o) {
			o.m.Icon = "skills/active_92.png";
			o.m.IconDisabled = "skills/active_92_sw.png";
			o.m.Overlay = "active_92";
		}));
	}}.onEquip;
});
