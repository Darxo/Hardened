::Hardened.HooksMod.hook("scripts/skills/actives/shoot_stake", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.AdditionalAccuracy += 10;	// In Reforged this is 15
	}

	q.onAdded = @(__original) function()
	{
		__original();

		// Copy of how vanilla adds the reload skill duing onUse
		local skillToAdd = this.new("scripts/skills/actives/reload_bolt");
		skillToAdd.setItem(this.getItem());
		skillToAdd.setFatigueCost(::Math.max(0, skillToAdd.getFatigueCostRaw() + this.getItem().m.FatigueOnSkillUse));
		this.getContainer().add(skillToAdd);
	}
});
