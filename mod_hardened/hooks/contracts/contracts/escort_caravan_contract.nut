::Hardened.HooksMod.hook("scripts/contracts/contracts/escort_caravan_contract", function(q) {
	q.createStates = @(__original) function()
	{
		__original();
		foreach (state in this.m.States)
		{
			if (state.ID == "Running")
			{
				local oldOnRetreatedFromCombat = state.onRetreatedFromCombat;
				state.onRetreatedFromCombat = function( _combatID )
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

	q.onClear = @(__original) function()
	{
		if (!this.m.IsActive)
		{
			// Do spawn caravan
			foreach (card in ::World.FactionManager.getFaction(this.getFaction()).m.Deck)
			{
				if (card.getID() != "send_caravan_action") continue;

				// We only execute this action, if half of our cooldown has passed already
				local remainingCooldown = card.getCooldownUntil() - ::Time.getVirtualTimeF();
				if (remainingCooldown > (card.m.Cooldown / 2)) break;

				// Do prepare action
				card.m.Start = this.m.Origin;
				card.m.Dest = this.m.Destination;

				// We execute that action the usual way, which causes a new cooldown afterwards
				card.execute();
			}
		}

		__original();
	}
});
