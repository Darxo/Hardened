::Hardened.HooksMod.hook("scripts/skills/actives/possess_undead_skill", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.FatigueCost = 15;	// This nerf is a result of double grip reducing the cost of non-attacks
	}

	// Vanilla doesn't have a getTooltip function defined for this skill
	q.getTooltip = @(__original) { function getTooltip()
	{
		local ret = __original();

		ret.push({
			id = 13,
			type = "text",
			icon = "ui/icons/action_points.png",
			text = ::Reforged.Mod.Tooltips.parseString("Move the target to the end in the [turn|Concept.Turn] sequence"),
		});

		return ret;
	}}.getTooltip;

	q.onUse = @(__original) { function onUse( _user, _targetTile )
	{
		__original(_user, _targetTile);

		// Feat: Possess undead now pushes the target zombie back in the turn order for the current round, allowing some more counter play from the player
		::Tactical.TurnSequenceBar.pushEntityBack(_targetTile.getEntity().getID());
	}}.onUse;
});
