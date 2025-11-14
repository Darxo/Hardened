::Hardened.HooksMod.hook("scripts/skills/actives/quick_shot", function(q) {
	// Public
	q.m.HD_WeaponMaxRangeDifference <- -2;	// This skills MaxRange will be set to the equipped weapons + this value; Vanilla: -1

	q.create = @(__original) function()
	{
		__original();
		this.m.AdditionalHitChance = -5;	// Vanilla: -4
	}

	q.getTooltip = @(__original) function()
	{
		local ret = __original();

		foreach (index, entry in ret)
		{
			if (entry.id == 6 && entry.icon == "ui/icons/hitchance.png" && ::String.contains(entry.text, "+10%"))
			{
				ret.remove(index);
				break;
			}
		}

		return ret;
	}

	q.onUpdate = @(__original) function( _properties )
	{
		__original(_properties);
		this.m.MaxRange = this.getItem().getRangeMax() + this.m.HD_WeaponMaxRangeDifference;
	}

	q.onAfterUpdate = @(__original) function( _properties )
	{
		// We revert any vanilla changes to MaxRange
		local oldMaxRange = this.m.MaxRange;
		__original(_properties);
		this.m.MaxRange = oldMaxRange;

		if (_properties.IsSpecializedInBows) this.m.MaxRange += 1;	// This is the bow mastery effect that is currently still hard-coded into the skills; Todo: move it into the mastery
	}
});
