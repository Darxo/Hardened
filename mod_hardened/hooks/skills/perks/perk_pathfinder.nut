::Hardened.HooksMod.hook("scripts/skills/perks/perk_pathfinder", function(q) {
	q.onRemoved = @(__original) function()
	{
		__original();

		// Vanilla Fix: pathfinder not resetting its changes when it is removed
		local actor = this.getContainer().getActor();
		actor.m.ActionPointCosts = clone ::Const.DefaultMovementAPCost;
		actor.m.FatigueCosts = clone ::Const.DefaultMovementFatigueCost;
		actor.m.LevelActionPointCost = ::Const.Movement.LevelDifferenceActionPointCost;
	}
});
