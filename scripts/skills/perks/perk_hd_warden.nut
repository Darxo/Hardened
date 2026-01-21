this.perk_hd_warden <- ::inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "perk.hd_warden";
		this.m.Name = ::Const.Strings.PerkName.HD_Scout;
		this.m.Description = "Under your watch, no one gets harmed.";
		this.m.Icon = "ui/perks/perk_rf_phalanx.png";
		this.m.Type = ::Const.SkillType.Perk;
		this.m.Order = ::Const.SkillOrder.Perk;
	}

	function onUpdate( _properties )
	{
		_properties.UpdateWhenTileOccupationChanges = true;

		if (this.isEnabled())
		{
			this.scanForWardTargets();
		}
	}

// New Functions
	// Try to add our warded effect to nearby allies
	function scanForWardTargets()
	{
		local actor = this.getContainer().getActor();
		foreach (nextTile in ::MSU.Tile.getNeighbors(actor.getTile()))
		{
			if (!nextTile.IsOccupiedByActor) continue;

			local nextEntity = nextTile.getEntity();
			if (!nextEntity.isAlliedWith(actor)) continue;

			local addWarded = true;
			foreach (skill in nextEntity.getSkills().m.Skills)
			{
				if (skill.isGarbage()) continue;
				if (skill.getID() == this.getID())	// This perk does not affect on someone who also has this perk
				{
					addWarded = false;
					break;
				}

				if (skill.getID() != "effects.hd_warded") continue;
				if (!skill.HD_isAlive()) continue;
				if (!::MSU.isEqual(skill.m.SourceWarden, actor)) continue;

				addWarded = false;
				break;
			}
			if (!addWarded) continue;

			local wardedEffect = ::new("scripts/skills/effects/hd_warded_effect");
			wardedEffect.m.SourceWarden = ::MSU.asWeakTableRef(actor);
			nextEntity.getSkills().add(wardedEffect);
		}
	}

	// Is this perk enabled and this actor able to exert their warden effect?
	function isEnabled()
	{
		if (!::Tactical.isActive()) return false;

		local actor = this.getContainer().getActor();
		if (!actor.isPlacedOnMap()) return false;
		if (actor.getMoraleState() == ::Const.MoraleState.Fleeing) return false;

		return true;
	}
});
