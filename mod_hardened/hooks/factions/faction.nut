::Hardened.HooksMod.hook("scripts/factions/faction", function(q) {
	// Private
	q.m.LastSpawnedParty <- null;	// weakref to the last party, spawned by this factions spawnEntity function

	q.spawnEntity = @(__original) function( _tile, _name, _uniqueName, _template, _resources )
	{
		local ret = __original(_tile, _name, _uniqueName, _template, _resources);

		// We spawn a very short wait order on any newly created party. Fixes Vanilla bug of teleporting any parties which will instantly engage player in battle
		local waitOrder = ::new("scripts/ai/world/orders/wait_order");
		waitOrder.setTime(1);	// About 14 ingame minutes
		ret.getController().addOrder(waitOrder);

		if (this.m.BannerPrefix == "")
		{
			local owner = this.getOwner();
			if (owner != null && owner.m.BannerPrefix != "")
			{
				ret.getSprite("banner").setBrush(owner.m.BannerPrefix + (owner.m.Banner < 10 ? "0" + owner.m.Banner : owner.m.Banner));
			}
		}

		this.m.LastSpawnedParty <- ::MSU.asWeakTableRef(ret);

		return ret;
	}

	q.getPlayerRelationAsText = @(__original) function()
	{
		local ret = __original();

		if (::Hardened.Mod.ModSettings.getSetting("DisplayRelationValue").getValue())
		{
			ret += " (" + this.m.PlayerRelation + ")";
		}

		return ret;
	}

// New Functions
	// Is this faction technically owned by another faction?
	// @return null, if this faction is not owned by another faction or a reference to the other faction, if the first settlement of it is owned by that one
	q.getOwner <- function()
	{
		if (this.getSettlements().len() == 0) return null;
		return this.getSettlements()[0].getOwner();		// For simplicity, we pretend like all settlements of a faction are owned by the same faction if any
	}
});

::Hardened.HooksMod.hookTree("scripts/factions/faction", function(q) {
	q.addPlayerRelation = @(__original) function( _r, _reason = "" )
	{
		__original(_r, _reason);
		if (_r == 0) return;

		// If the player gains Relation during an active Contract or Event, we locate the active screen so we can try to push a list entry into it showcasing the change
		local activeScreen = null;
		if(::World.Contracts.getActiveContract() != null)
		{
			activeScreen = ::World.Contracts.getActiveContract().m.ActiveScreen;
		}
		else if (::World.Events.m.ActiveEvent != null)
		{
			activeScreen = ::World.Events.m.ActiveEvent.m.ActiveScreen;
		}

		if (activeScreen != null)
		{
			// Currently this does not include overview and negotiation screens

			// We push a notification about the just gained renown into the current contract screen list, so the player has accurate information about it
			activeScreen.List.push({
				id = 30,
				icon = "ui/icons/relations.png",
				text = format("You %s %s Relation with %s", _r > 0 ? "gain" : "lose", ::MSU.Text.colorizeValue(_r), this.getName()),
			});
		}
	}
});
