::Hardened.HooksMod.hook("scripts/skills/racial/vampire_racial", function(q) {
	q.getTooltip = @(__original) function()
	{
		local ret = __original();

		// Remove the existing tooltips
		::Hardened.util.HD_deleteBulletPoint(ret, function(_entry) {
			if (_entry.id == 10 && _entry.icon == "ui/icons/regular_damage.png") return true;	// Remove the tooltip about life leech as that is now handled by the hd_life_leech_effect
			if (_entry.id == 22 && _entry.icon == "ui/icons/special.png") return true;			// Remove the tooltip about poison immunity
			return false;
		});

		return ret;
	}

	q.onAdded = @(__original) { function onAdded()
	{
		// We prevent Reforged from granting poison immunity with this racial effect. Vampires are no longer immune to this
		local baseProperties = this.getContainer().getActor().getBaseProperties();
		local oldIsImmuneToPoison = baseProperties.IsImmuneToPoison;
		__original();
		baseProperties.IsImmuneToPoison = oldIsImmuneToPoison;
	}}.onAdded;

	// Overwrite, because we now handle the life leech within the new hd_life_leech_effect effect
	q.onTargetHit = @() function(_skill, _targetEntity, _bodyPart, _damageInflictedHitpoints, _damageInflictedArmor) {}
});
