::Hardened.HooksMod.hook("scripts/skills/actives/shoot_stake", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.AdditionalAccuracy = 20;	// Reforged: 10
	}

	q.onAdded = @(__original) function()
	{
		__original();

		// Copy of how vanilla adds the reload skill duing onUse
		local skillToAdd = ::new("scripts/skills/actives/reload_bolt");
		skillToAdd.setItem(this.getItem());
		skillToAdd.setFatigueCost(::Math.max(0, skillToAdd.getFatigueCostRaw() + this.getItem().m.FatigueOnSkillUse));
		this.getContainer().add(skillToAdd);
	}
});
