this.hd_retreat_skill <- this.inherit("scripts/skills/skill", {
	m = {
	},
	function create()
	{
		this.m.ID = "actives.hd_retreat";
		this.m.Name = "Retreat";
		this.m.Description = ::Reforged.Mod.Tooltips.parseString("Retreat from combat and leave your allies behind.\nCannot be used while [engaged|Concept.ZoneOfControl] in melee.");
		this.m.Icon = "skills/hd_retreat_skill.png";
		this.m.IconDisabled = "skills/hd_retreat_skill_sw.png";
		this.m.Type = ::Const.SkillType.Active;
		this.m.Order = ::Const.SkillOrder.Last;
		this.m.IsSerialized = false;
		this.m.IsActive = true;
	}

	function getTooltip()
	{
		local ret = this.skill.getDefaultUtilityTooltip();	// Todo: maybe dont show a cost string, because this skill is meant to never cost anything?

		ret.push({
			id = 10,
			type = "text",
			icon = "ui/icons/special.png",
			text = ::Reforged.Mod.Tooltips.parseString("Remove yourself from the battlefield"),
		});

		local actor = this.getContainer().getActor();
		if (actor.isPlacedOnMap() && actor.getTile().hasZoneOfControlOtherThan(actor.getAlliedFactions()))
		{
			ret.push({
				id = 20,
				type = "text",
				icon = "ui/tooltips/warning.png",
				text = ::Reforged.Mod.Tooltips.parseString("Cannot be used because this character is [engaged|Concept.ZoneOfControl] in melee"),
			});
		}

		return ret;
	}

	function isUsable()
	{
		if (::Tactical.State.getStrategicProperties().IsFleeingProhibited) return false;	// e.g. Icy Cave or Arena Fights

		if (!this.isAtMapBorder()) return false;	// We assume (just like vanilla ai_retreat), that all border tiles are valid for retreating

		local actor = this.getContainer().getActor();
		if (actor.getTile().hasZoneOfControlOtherThan(actor.getAlliedFactions())) return false;		// We are not allowed to retreat if an adjacent enemy exerts zone of control onto us

		return this.skill.isUsable();
	}

	function isHidden()
	{
		return !this.isAtMapBorder();
	}

	function onVerifyTarget( _originTile, _targetTile )
	{
		return true;
	}

	function onUse( _user, _targetTile )
	{
		// Calling retreat, similarto calling kill, will remove this entity without resolving the scheduledSkill
		// Just like with the vanilla exploding skulls, we therefor do the retreating with the tiniest delay
		::Time.scheduleEvent(::TimeUnit.Real, 1, function ( _user )
		{
			_user.retreat();
		}, _user);
		return true;
	}

// New Functions
	// This is a copy to the simple check that vanilla ai_retreat uses to determine whether a character is allowed to leave the battle
	function isAtMapBorder()
	{
		local actor = this.getContainer().getActor();
		if (!actor.isPlacedOnMap()) return false;

		if (::MSU.Tile.getNeighbors(actor.getTile()).len() != 6) return true;	// We assume that only tiles at the border are missing neighboring tiles

		return false;
	}
});

