::Hardened.HooksMod.hook("scripts/contracts/contracts/escort_caravan_contract", function(q) {
	q.createStates = @(__original) function()
	{
		__original();
		foreach (screen in this.m.States)
		{
			if (screen.ID == "Running")
			{
				local oldOnRetreatedFromCombat = screen.onRetreatedFromCombat;
				screen.onRetreatedFromCombat = function( _combatID )
				{
					// Pressing the cancel button in combat dialogs no longer stuns enemies in Hardened
					// But that means fleeing from caravan contracts instantly allows the attacker to engage the player again
					// Therefor we do a manual major stun around the player when he flees during caravan escorts
					::World.State.stunPartiesNearPlayer();
					oldOnRetreatedFromCombat(_combatID);
				}
			}
		}

	}
});
