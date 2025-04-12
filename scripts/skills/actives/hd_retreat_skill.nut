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
		local ret = this.skill.getDefaultUtilityTooltip();

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
		if (!this.isAtMapBorder()) return false;	// We assume (just like vanilla ai_retreat), that all border tiles are valid for retreating

		local actor = this.getContainer().getActor();
		if (actor.getTile().hasZoneOfControlOtherThan(actor.getAlliedFactions())) return false;		// We are not allowed to retreat if an adjacent enemy exerts zone of control onto us

		return true;
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
		this.getContainer().getActor().retreat();
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

