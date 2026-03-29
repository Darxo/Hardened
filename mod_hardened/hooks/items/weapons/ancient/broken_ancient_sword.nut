::Hardened.HooksMod.hook("scripts/items/weapons/ancient/broken_ancient_sword", function(q) {
	// Overwrite, because we add different skills under different discounts, than reforged
	q.onEquip = @() { function onEquip()
	{
		this.weapon.onEquip();

		this.addSkill(::Reforged.new("scripts/skills/actives/slash"));
		this.addSkill(::Reforged.new("scripts/skills/actives/riposte"));
	}}.onEquip;
});
