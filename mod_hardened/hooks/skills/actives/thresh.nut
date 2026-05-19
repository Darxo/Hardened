::Hardened.HooksMod.hook("scripts/skills/actives/thresh", function(q) {
	q.create = @(__original) function()
	{
		__original();

		this.m.StunChance = 0;		// Vanilla: 20
	}

	q.getTooltip = @(__original) function()
	{
		local ret = __original();

		if (this.m.StunChance == 0)
		{
			// We remove the tooltip about stun chance, when this skill has no natural globla stun chance
			::Hardened.util.HD_deleteBulletPoint(ret, function(_entry) {
				return (_entry.id == 8) && (_entry.icon == "ui/icons/special.png");
			});
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
