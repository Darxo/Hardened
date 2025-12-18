::Hardened.HooksMod.hook("scripts/contracts/contracts/escort_caravan_contract", function(q) {
	q.createScreens = @(__original) function()
	{
		__original();
		foreach (screen in this.m.Screens)
		{
			if (screen.ID == "Vampires1")
			{
				this.hookVampireScreen(screen);
			}
		}
	}

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

	q.spawnCaravan = @(__original) function()
	{
		local home = (typeof this.m.Home == "instance" && this.m.Home instanceof ::WeakTableRef) ? this.m.Home.get() : this.m.Home;

		// We switcheroo getProduce, so that vanilla doesnt add its wares items to the caravan. Instead we want to have control over them being added
		local oldGetProduce = home.getProduce;
		home.getProduce = function() { return [] };

		// We switcheroo getResources, to prevent the escorted caravan party from scaling with world difficulty
		local oldGetResources = home.getResources;
		local resources = home.m.Resources;
		home.getResources = function() { return resources };

		__original();

		home.getResources = oldGetResources;
		home.getProduce = oldGetProduce;

		// Now we add produces in our way to the party. But we first need to find it:
		local lastSpawnedParty = ::World.FactionManager.getFaction(this.getFaction()).m.HD_LastSpawnedParty;
		if (!::MSU.isNull(lastSpawnedParty))
		{
			// We now allow a customizable amount of trade goods. And we mark those trade goods in a special way, so that they drop in mint condition alter on
			if (home.getProduce().len() != 0)
			{
				for (local i = 0; i < this.HD_getProduceAmount(); ++i)
				{
					lastSpawnedParty.HD_addMintItemToInventory(::MSU.Array.rand(home.getProduce()));
				}
			}
		}
	}

// New Functions
	q.HD_getProduceAmount <- function()
	{
		return 3;
	}

	// When the player starts the fight against those vampires, they gain the "Lying in Ambush" effect, which causes them to not act during the first turn
	// This will allow the player to have a chance to save the donkeys
	q.hookVampireScreen <- function( _screen )
	{
		foreach (option in _screen.Options)
		{
			if (option.Text != "Defend the caravan!") continue;

			local oldOption = option.getResult;
			option.getResult = function()
			{
				local arguments = null;

				// Prevent the original startScriptedCombat from running and save its arguments
				local mockStartScriptedCombat = ::Hardened.mockFunction(::World.Contracts, "startScriptedCombat", function( _properties = null, _isPlayerInitiated = true, _isCombatantsVisible = true, _allowFormationPicking = true ) {
					arguments = [_properties, _isPlayerInitiated, _isCombatantsVisible, _allowFormationPicking];
					return { done = true, value = null };
				});
				local ret = oldOption();
				mockStartScriptedCombat.cleanup();

				// Now we adjust the arguments and then run our own startScriptedCombat
				if (arguments != null)
				{
					local oldAfterDeploymentCallback = arguments[0].AfterDeploymentCallback;
					arguments[0].AfterDeploymentCallback = function() {
						if (oldAfterDeploymentCallback != null) oldAfterDeploymentCallback();
						foreach (undeadEntity in ::Tactical.Entities.getInstancesOfFaction(::World.FactionManager.getFactionOfType(::Const.FactionType.Undead).getID()))
						{
							local lyingInAmbush = ::new("scripts/skills/effects/hd_lying_in_ambush_effect");
							lyingInAmbush.m.HD_LastsForRounds = 2;
							lyingInAmbush.m.TileAlertRadius = 0;
							undeadEntity.getSkills().add(lyingInAmbush);
						}
					}
					::World.Contracts.startScriptedCombat(arguments[0], arguments[1], arguments[2], arguments[3]);
				}

				return ret;
			}

			break;
		}
	}
});
