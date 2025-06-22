::Hardened.HooksMod.hook("scripts/skills/racial/vampire_racial", function(q) {
	q.getTooltip = @(__original) function()
	{
		local ret = __original();

		foreach (index, entry in ret)
		{
			if (entry.id == 10 && entry.icon == "ui/icons/regular_damage.png")	// Remove the tooltip about life leech as that is now handled by the hd_life_leech_effect
			{
				ret.remove(index);
				break;
			}
		}

		return ret;
	}

	// Overwrite, because we completely change the damage reductions chosen by Reforged
	q.onAdded = @(__original) { function onAdded()
	{
		__original();

		this.getContainer().add(::new("scripts/skills/effects/hd_life_leech_effect"));
	}}.onAdded;

	// Overwrite, because we now handle the life leech within the new hd_life_leech_effect effect
	q.onTargetHit = @() function(_skill, _targetEntity, _bodyPart, _damageInflictedHitpoints, _damageInflictedArmor) {}
});
