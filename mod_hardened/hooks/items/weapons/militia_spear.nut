::Hardened.HooksMod.hook("scripts/items/weapons/militia_spear", function(q) {
	// We overwrite Reforged skill additions, because we dont hand out any discounts
	q.onEquip = @() { function onEquip()
	{
		this.weapon.onEquip();
		this.addSkill(::new("scripts/skills/actives/thrust"));
		this.addSkill(::new("scripts/skills/actives/spearwall"));
	}}.onEquip;
});
