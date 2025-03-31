::Hardened.HooksMod.hook("scripts/skills/actives/chop", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.ChanceDecapitate = 50;	// In Reforged/Vanilla this is 25
	}

	q.getTooltip = @(__original) function()
	{
		local ret = __original();

		foreach (entry in ret)
		{
			if (entry.id == 6)
			{
				// Improve clarity of this tooltip to hopefully emphasize enough, that this bonus is negated with Steelbrow
				entry.text = "Deal " + ::MSU.Text.colorPositive("+50% ") + ::Reforged.Mod.Tooltips.parseString("[Critical Damage|Concept.CriticalDamage]") + " on a hit to the head";
				break;
			}
		}

		return ret;
	}
});
