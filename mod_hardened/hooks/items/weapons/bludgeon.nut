::Hardened.HooksMod.hook("scripts/items/weapons/bludgeon", function(q) {
	// We overwrite Reforged skill additions, because we dont hand out any discounts
	q.onEquip = @() { function onEquip()
	{
		this.weapon.onEquip();
		this.addSkill(::new("scripts/skills/actives/bash"));
		this.addSkill(::new("scripts/skills/actives/knock_out"));
	}}.onEquip;
});
