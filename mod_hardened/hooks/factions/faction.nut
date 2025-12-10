::Hardened.HooksMod.hook("scripts/factions/faction", function(q) {
	// Public
	q.m.RelationChangesMax <- 6;	// maximum amount of relation change strings allowed to exist at once

	// Private
	q.m.HD_LastSpawnedParty <- null;	// weakref to the last party, spawned by this factions spawnEntity function

	q.create = @(__original) function()
	{
		__original();
		this.m.HD_PricePctPerNegativeRelation = -0.02;		// Vanilla: -0.006
	}

	// Overwrite, because we can't easily apply the changes
	q.addPlayerRelationEx = @() function( _r, _reason = "" )
	{
		if (_r == 0.0) return;

		// Vanilla Fix: Relationship changes are no longer rounded
		this.m.PlayerRelation = ::Math.clampf(this.m.PlayerRelation + _r, 0.0, 100.0);
		this.updatePlayerRelation();

		// We allow the _reason to be overwritten from the outside. This allows us to mirror the original reason, when an owner applies a penalty following a penalty to one of its lackeys
		if (::Hardened.Temp.PlayerRelationReason != null) _reason = ::Hardened.Temp.PlayerRelationReason;
		if (_reason == "") return;

		// Feat: Display the relation change in brackets behind the reason
		_reason +=  format(" (%s)", ::MSU.Text.colorizeValue(_r, {AddSign = true}));

		// This rest is an mostly copy of the vanilla logic
		if (this.m.PlayerRelationChanges.len() >= 1 && this.m.PlayerRelationChanges[0].Text == _reason)
		{
			this.m.PlayerRelationChanges[0].Time = ::Time.getVirtualTimeF();
			// Feat: Combine subsequent duplicate entries into
			this.m.PlayerRelationChanges[0].Combined += 1;
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
				Time = ::Time.getVirtualTimeF(),
				Combined = 1,	// When multiple entries are Combined into one, this number will showcase that
			});
		}
	}

	q.setIsTemporaryEnemy = @(__original) function( _bool )
	{
		local hasChanged = (this.m.IsTemporaryEnemy != _bool);
		__original(_bool);
		if (hasChanged)
		{
			// We need to update all entities from that faction, because our temporary status with them just changed
			foreach (settlement in this.getSettlements())
			{
				settlement.updatePlayerRelation();
			}
			foreach (worldParty in this.getUnits())
			{
				worldParty.updatePlayerRelation();
			}
		}
	}

	q.spawnEntity = @(__original) function( _tile, _name, _uniqueName, _template, _resources, _minibossify = 0 )
	{
		local ret = __original(_tile, _name, _uniqueName, _template, _resources, _minibossify);

		// We spawn a very short sleep_order (similar to how noble houses do it) on any newly created party. Fixes Vanilla bug of teleporting any parties which will instantly engage player in battle
		local sleepOrder = ::new("scripts/ai/world/orders/sleep_order");
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

	q.onSerialize = @(__original) function( _out )
	{
		// We serialize the information from the new Combined field, by adding it to the Text directly
		foreach (relationChange in this.m.PlayerRelationChanges)
		{
			if (relationChange.Combined > 1)
			{
				relationChange.Text += " (x" + relationChange.Combined + ")";
				relationChange.Combined = 1;
			}
		}

		__original(_out);
	}

	q.onDeserialize = @(__original) function( _in )
	{
		__original(_in);

		// We artificially add the Combined field, after deserilizing, to make sure it's always present
		foreach (relationChange in this.m.PlayerRelationChanges)
		{
			relationChange.Combined <- 1;
		}
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
		// Vanilla does a -PlayerRelation change with the reason "Attacked them" only ever, when the player attacks a friendly character on the world map
		// Feat: When the player force attacks allies, they only become temporary enemies, instead of tanking the player relationship immediately and completely
		if (-_r == this.getPlayerRelation() && _reason == "Attacked them")
		{
			local functionCaller = ::Hardened.getFunctionCaller();
			if (functionCaller == "onMouseInput")
			{
				this.setIsTemporaryEnemy(true);
				::World.Assets.m.MoralReputation += 3.0;	// Vanilla subtracts 3 MoralReputation, so we need to counteract that. We dont use the helper function to circumvent clamping
				return;	// Do Nothing. We don't want the player relation to change in these cases
			}
			else if (functionCaller == "onUpdate")
			{
				this.setIsTemporaryEnemy(true);
				::World.Assets.m.MoralReputation += 2.0;	// Vanilla subtracts 2 MoralReputation, so we need to counteract that. We dont use the helper function to circumvent clamping
				return;	// Do Nothing. We don't want the player relation to change in these cases
			}
		}

		__original(_r, _reason);
	}

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
		if (::World.Contracts.m.IsEventVisible && !::MSU.isNull(::World.Contracts.m.LastShown) && !::MSU.isNull(::World.Contracts.m.LastShown.getActiveScreen()))		// Contracts and Negotiations
		{
			activeObject = ::World.Contracts.m.LastShown;
		}
		else if (::World.Events.m.ActiveEvent != null)		// Regular Events
		{
			activeObject = ::World.Events.m.ActiveEvent;
		}
		else if (!::MSU.isNull(::World.Contracts.getActiveContract()) && ::World.Contracts.getActiveContract().m.HD_CalledPrematureSetScreen)
		{
			// We gained Renown while a screen was set but the contract wasnt yet shown to the player
			activeObject = ::World.Contracts.getActiveContract();
		}

		if (activeObject != null)
		{
			::MSU.Text.colorizeValue(_change)

			_change = ::Math.round(_change * 10.0) / 10.0;	// We round _change up to 1 decimal place

			// We push a notification about the just gained renown into the current contract screen list, so the player has accurate information about it
			activeObject.addListItem({
				id = 30,
				icon = "ui/icons/relations.png",
				text = format("You %s %s Relation with %s", _change > 0 ? "gain" : "lose", ::MSU.Text.colorizeValue(_change, {HD_UseEventColors = true}), this.getName()),
			});
		}
	}
});
