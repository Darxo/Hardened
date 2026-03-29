::Hardened.HooksMod.hook("scripts/items/weapons/butchers_cleaver", function(q) {
	// We overwrite Reforged skill additions, because we dont hand out any discounts
	// We also revert the gash skill back to decapitate
	q.onEquip = @() { function onEquip()
	{
		this.weapon.onEquip();
		this.addSkill(::Reforged.new("scripts/skills/actives/cleave", function(o) {
			o.m.Icon = "skills/active_68.png";
			o.m.IconDisabled = "skills/active_68_sw.png";
			o.m.Overlay = "active_68";
		}));
		this.addSkill(::new("scripts/skills/actives/decapitate"));
	}}.onEquip;
});
