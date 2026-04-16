::Hardened.HooksMod.hook("scripts/factions/contracts/return_item_action", function(q) {
	// Overwrite, because we change too many things from the original function:
	//	- We adjust the chance for this contract depend on player renown instead of day number
	q.onUpdate = @() function( _faction )
	{
		if (!_faction.isReadyForContract()) return;
		if (_faction.getSettlements()[0].isIsolatedFromRoads()) return;
		if (!this.HD_rollContractChance()) return;

		this.m.Score = this.m.HD_ScoreOverwrite;
	}

// New Functions
	q.HD_rollContractChance <- function()
	{
		// Vanilla: 80% on day 1-3 and 9% chance after than
		if (::Math.rand(1, 1000) > ::World.Assets.getBusinessReputation()) return true;

		return ::Math.rand(1, 10) == 1;
	}
});
