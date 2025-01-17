::Hardened.HooksMod.hook("scripts/entity/tactical/enemies/zombie_yeoman", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.Name = ::Const.Strings.EntityName[this.m.Type];	// Armored Zombies are now actually called this during combat instead of just "Zombie"
	}

	q.onSpawned = @(__original) function()
	{
		__original();
		this.getSkills().add(::new("scripts/skills/perks/perk_overwhelm"));	// Re-Add Overwhelm because it was removed from base zombie class
	}
});
