::Hardened.HooksMod.hook("scripts/skills/actives/throw_fire_bomb_skill", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.IsAttack = false;	// This skill is no longer considered an attack. This flag didn't make sense in vanilla anyways
	}

	q.getTooltip = @(__original) function()
	{
		local ret = __original();

		ret.push({
			id = 10,
			type = "text",
			icon = "ui/icons/special.png",
			text = ::Reforged.Mod.Tooltips.parseString("Burns away any [rooted|Rooted.StatusEffect] effects on the target"),
		});

		return ret;
	}
});
