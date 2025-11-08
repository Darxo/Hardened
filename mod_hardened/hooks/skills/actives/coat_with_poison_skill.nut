::Hardened.HooksMod.hook("scripts/skills/actives/coat_with_poison_skill", function(q) {
	q.create = @(__original) { function create()
	{
		__original();
		this.m.Name = "Use Goblin Poison";	// Vanilla: Use Poison
	}}.create;

	q.getTooltip = @(__original) function()
	{
		local ret = __original();

		foreach (entry in ret)
		{
			if (entry.id == 7 && entry.icon == "ui/icons/special.png")
			{
				entry.text = ::Reforged.Mod.Tooltips.parseString("Gain [Coated in Goblin Poison|Skill+poison_coat_effect]");
				// Maybe include children
				break;
			}
		}

		return ret;
	}

	// Overwrite, because we don't grant any AP discount during the first Round
	q.onAfterUpdate = @() function( _properties ) {}
});
