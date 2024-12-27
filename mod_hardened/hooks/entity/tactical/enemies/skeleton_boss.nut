::Hardened.HooksMod.hook("scripts/entity/tactical/enemies/skeleton_boss", function(q) {
	q.onInit = @(__original) function()
	{
		__original();
		// The only purpose of this addition is to showcase that this character is immune to disarm
		this.getSkills().add(::new("scripts/skills/perks/perk_rf_savage_strength"));
	}
});
