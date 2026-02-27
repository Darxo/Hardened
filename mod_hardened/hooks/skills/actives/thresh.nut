::Hardened.HooksMod.hook("scripts/skills/actives/thresh", function(q) {
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
