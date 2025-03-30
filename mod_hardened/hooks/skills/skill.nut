::Hardened.HooksMod.hook("scripts/skills/skill", function(q) {
	q.isDuelistValid = @() function()
	{
		local mainhandItem = this.getContainer().getActor().getItems().getItemAtSlot(::Const.ItemSlot.Mainhand);
		if (::MSU.isNull(mainhandItem)) return false;
		if (!mainhandItem.isItemType(::Const.Items.ItemType.OneHanded)) return false;

		return true;
	}

	q.getHitFactors = @(__original) function( _targetTile )
	{
		local ret = __original(_targetTile);

		// New Entries
		if (_targetTile.IsOccupiedByActor)
		{
			local target = _targetTile.getEntity();
			local properties = this.getContainer().buildPropertiesForUse(this, target);

			// Headshot chance
			if (this.isAttack())
			{
				local headshotChance = properties.getHeadHitchance(::Const.BodyPart.Head, this.getContainer().getActor(), this, target);
				ret.insert(0, {
					icon = "ui/icons/chance_to_hit_head.png",
					text = ::Reforged.Mod.Tooltips.parseString(::MSU.Text.colorizeValue(headshotChance, {AddPercent = true}) + " headshot chance"),
				});
			}
		}

		return ret;
	}

// New Functions
	// Call several functions to make sure that other entities/factions know about the action this skill just did, if they see the action
	// Important: this.getContainer().getActor() must be placed on a tile, so do make sure that is the case before caling this function
	q.revealUser <- function( _targetedTile )
	{
		local user = this.getContainer().getActor();

		if (_targetedTile.IsVisibleForPlayer)
		{
			// We always reveal the user-tile, when iit's targeting a tile already visible to the player, allowing the player
			user.setDiscovered(true);
			user.getTile().addVisibilityForFaction(::Const.Faction.Player);
		}

		if (!_targetedTile.IsOccupiedByActor) return;

		local target = _targetedTile.getEntity();
		if (target.getAttackers().find(user.getID()) == null)
		{
			target.getAttackers().push(user.getID());
		}

		if (!target.isPlayerControlled())
		{
			user.getTile().addVisibilityForFaction(target.getFaction());
			target.onActorSighted(user);

			foreach (targetAlly in ::Tactical.Entities.getInstancesOfFaction(target.getFaction()))
			{
				if (targetAlly.getID() != target.getID() && targetAlly.isAlive())
				{
					targetAlly.onActorSighted(user);
					// Maybe also add user to getAttackers of any ally?
				}
			}
		}
	}
});

::Hardened.HooksMod.hookTree("scripts/skills/skill", function(q) {
	q.onUse = @(__original) function( _user, _targetTile )
	{
		// We make sure everyone who needs to know, now knows about the action we just did onto _targetTile, no matter what kind of skill we used
		this.revealUser(_targetTile);

		return __original(_user, _targetTile);
	}
});
