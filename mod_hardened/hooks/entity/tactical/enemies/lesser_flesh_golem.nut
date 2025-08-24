::Hardened.HooksMod.hook("scripts/entity/tactical/enemies/lesser_flesh_golem", function(q) {
	q.onSpawned = @(__original) function()
	{
		__original();

		this.getSkills().removeByID("perk.rf_rattle");		// Remove Full Force

		// The only purpose of this addition is to showcase that this character is immune to disarm
		this.getSkills().add(::new("scripts/skills/perks/perk_rf_savage_strength"));
	}
});
