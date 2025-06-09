::Hardened.HooksMod.hook("scripts/factions/faction", function(q) {
	// Public
	q.m.RelationChangesMax <- 6;	// maximum amount of relation change strings allowed to exist at once

	// Private
	q.m.HD_LastSpawnedParty <- null;	// weakref to the last party, spawned by this factions spawnEntity function

	// Overwrite, because we can't easily apply the changes
	q.addPlayerRelationEx = @() function( _r, _reason = "" )
	{
		if (_r == 0.0) return;

		// Vanilla Fix: Relationship changes are no longer rounded
		this.m.PlayerRelation = ::Math.clampf(this.m.PlayerRelation + _r, 0.0, 100.0);
		this.updatePlayerRelation();

		if (_reason == "") return;

		// Feat: Display the relation change in brackets behind the reason
		_reason +=  format(" (%s)", ::MSU.Text.colorizeValue(_r, {AddSign = true}));

		// This rest is an mostly copy of the vanilla logic
		if (this.m.PlayerRelationChanges.len() >= 1 && this.m.PlayerRelationChanges[0].Text == _reason)
		{
			this.m.PlayerRelationChanges[0].Time = ::Time.getVirtualTimeF();
			// Feat: Combine subsequent duplicate entries into one in a very simple way
			this.m.PlayerRelationChanges[0].Text += " x2";	// We only combine two duplicates at most, as that is the most straightforward and easy way
		}
		else
		{
			if (this.m.PlayerRelationChanges.len() >= this.m.RelationChangesMax)	// We make the maximum change entries moddable
			{
				this.m.PlayerRelationChanges.remove(this.m.PlayerRelationChanges.len() - 1);
			}

			this.m.PlayerRelationChanges.insert(0, {
				Positive = _r >= 0 ? true : false,
				Text = _reason,
				Time = ::Time.getVirtualTimeF()
			});
		}
	}

	q.spawnEntity = @(__original) function( _tile, _name, _uniqueName, _template, _resources, _minibossify = 0 )
	{
		local ret = __original(_tile, _name, _uniqueName, _template, _resources, _minibossify);

		// We spawn a very short sleep_prder (similar to how noble houses do it) on any newly created party. Fixes Vanilla bug of teleporting any parties which will instantly engage player in battle
		local sleepOrder = this.new("scripts/ai/world/orders/sleep_order");
		sleepOrder.setTime(1.0);	// About 14 ingame minutes
		ret.getController().addOrder(sleepOrder);

		if (this.m.BannerPrefix == "")
		{
			local owner = this.getOwner();
			if (owner != null && owner.m.BannerPrefix != "")
			{
				ret.getSprite("banner").setBrush(owner.m.BannerPrefix + (owner.m.Banner < 10 ? "0" + owner.m.Banner : owner.m.Banner));
			}
		}

		this.m.HD_LastSpawnedParty = ::MSU.asWeakTableRef(ret);

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
	q.addPlayerRelationEx = @(__original) function( _r, _reason = "" )
	{
		__original(_r, _reason);
		this.tryListRelationChange(_r);
	}

// New Function
	q.tryListRelationChange <- function( _change )
	{
		if (_change == 0) return;

		// If the player gains Relation during an active Contract or Event, we locate the active screen so we can try to push a list entry into it showcasing the change
		local activeObject = null;
		if (::World.Contracts.m.IsEventVisible)
		{
			activeObject = ::World.Contracts.m.LastShown;
		}
		else if (::World.Events.m.ActiveEvent != null)
		{
			activeObject = ::World.Events.m.ActiveEvent;
		}

		if (activeObject != null)
		{
			::MSU.Text.colorizeValue(_change)

			_change = ::Math.round(_change * 10.0) / 10.0;	// We round _change up to 1 decimal place

			// We push a notification about the just gained renown into the current contract screen list, so the player has accurate information about it
			activeObject.addListItem({
				id = 30,
				icon = "ui/icons/relations.png",
				text = format("You %s %s Relation with %s", _change > 0 ? "gain" : "lose", ::MSU.Text.colorizeValue(_change), this.getName()),
			});
		}
	}
});
