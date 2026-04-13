::Hardened.HooksMod.hook("scripts/items/weapons/oriental/two_handed_saif", function(q) {
	// We overwrite Reforged skill additions, because we dont hand out any discounts
	q.onEquip = @() { function onEquip()
	{
		this.weapon.onEquip();

		this.addSkill(::Reforged.new("scripts/skills/actives/cleave", function(o) {
			o.m.Icon = "skills/active_210.png";
			o.m.IconDisabled = "skills/active_210_sw.png";
			o.m.Overlay = "active_210";
		}));

		this.addSkill(::new("scripts/skills/actives/decapitate"));
	}}.onEquip;
});
