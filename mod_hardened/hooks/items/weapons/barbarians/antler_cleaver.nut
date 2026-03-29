::Hardened.HooksMod.hook("scripts/items/weapons/barbarians/antler_cleaver", function(q) {
	// We overwrite Reforged skill additions, because we dont hand out any discounts
	q.onEquip = @() { function onEquip()
	{
		this.weapon.onEquip();

		this.addSkill(::Reforged.new("scripts/skills/actives/cleave", function(o) {
			o.m.Icon = "skills/active_177.png";
			o.m.IconDisabled = "skills/active_177_sw.png";
			o.m.Overlay = "active_177";
		}));

		this.addSkill(::new("scripts/skills/actives/decapitate"));
	}}.onEquip;
});
