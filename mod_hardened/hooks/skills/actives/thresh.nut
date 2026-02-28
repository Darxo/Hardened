::Hardened.HooksMod.hook("scripts/skills/actives/thresh", function(q) {
	q.create = @(__original) function()
	{
		__original();

		this.m.StunChance = 0;		// Vanilla: 20
	}

	q.getTooltip = @(__original) function()
	{
		local ret = __original();

		for (local index = (ret.len() - 1); index >= 0; index--)
		{
			// We remove the tooltip about the chance to stun, if the skill has no stun-chance
			local entry = ret[index];
			if (this.m.StunChance == 0 && entry.id == 8 && entry.icon == "ui/icons/special.png")
			{
				ret.remove(index);
				break;
			}
		}

		return ret;
	}

	q.getHitChanceModifier = @(__original) function()
	{
		// Flail Mastery no longer grants +5% HitChance with this skill
		local oldSpecialized = this.getContainer().getActor().getCurrentProperties().IsSpecializedInFlails;
		this.getContainer().getActor().getCurrentProperties().IsSpecializedInFlails = false;
		local ret = __original();
		this.getContainer().getActor().getCurrentProperties().IsSpecializedInFlails = oldSpecialized;

		return ret;
	}
});
