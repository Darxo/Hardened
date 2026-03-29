::Hardened.HooksMod.hook("scripts/items/weapons/scimitar", function(q) {
	// We overwrite Reforged skill additions, because we dont hand out any discounts
	q.onEquip = @() { function onEquip()
	{
		this.weapon.onEquip();
		this.addSkill(::Reforged.new("scripts/skills/actives/slash", function(o) {
			o.m.Icon = "skills/active_172.png";
			o.m.IconDisabled = "skills/active_172_sw.png";
			o.m.Overlay = "active_172";
		}));
		this.addSkill(::new("scripts/skills/actives/gash_skill"));
	}}.onEquip;
});
