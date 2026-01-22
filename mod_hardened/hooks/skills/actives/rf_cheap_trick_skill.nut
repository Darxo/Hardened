::Hardened.HooksMod.hook("scripts/skills/actives/rf_cheap_trick_skill", function(q) {
	q.create = @(__original) function()
	{
		__original();

		this.m.SoundOnUse = [
			"sounds/dice_01.wav",
			"sounds/dice_02.wav",
			"sounds/dice_03.wav",
		];
	}

	q.getTooltip = @(__original) function()
	{
		local ret = __original();

		foreach (entry in ret)
		{
			if (entry.id == 10 || entry.id == 11)
			{
				entry.text = ::MSU.String.replace(entry.text, "attack", "attack skill");
			}
		}

		return ret;
	}
});
