this.perk_hd_ethereal <- ::inherit("scripts/skills/skill", {
	m = {
		// Public
		RangedDefensePerDistance = 10,	// This much Ranged Defense is gained per tile between the attacker and you
		MeleeDefensePerDistance = 10,	// This much Melee Defense is gained per tile between the attacker and you
	},
	function create()
	{
		this.m.ID = "perk.hd_ethereal";
		this.m.Name = ::Const.Strings.PerkName.HD_Ethereal;
		this.m.Description = "Your form appears faint and uncertain at a distance, as if not fully bound to the world.";
		this.m.Icon = "ui/orientation/rf_banshee_orientation.png";
		this.m.Type = ::Const.SkillType.Perk;
		this.m.Order = ::Const.SkillOrder.Perk;
	}

	function onBeingAttacked( _attacker, _skill, _properties )
	{
		if (this.isSkillValid(_skill))
		{
			local distance = _attacker.getTile().getDistanceTo(this.getContainer().getActor().getTile());
			_properties.MeleeDefense += this.getMeleeDefenseModifier(distance);
			_properties.RangedDefense += this.getRangedDefenseModifier(distance);
		}
	}

// MSU Functions
	function onGetHitFactorsAsTarget( _skill, _targetTile, _tooltip )
	{
		if (this.isSkillValid(_skill))
		{
			local distance = _skill.getContainer().getActor().getTile().getDistanceTo(_targetTile);
			local defenseModifier = _skill.isRanged() ? this.getRangedDefenseModifier(distance) : this.getMeleeDefenseModifier(distance);
			if (defenseModifier != 0)
			{
				_tooltip.push({
					icon = "ui/tooltips/negative.png",
					text = ::MSU.Text.colorNegative(defenseModifier + "% ") + this.getName(),
				});
			}
		};
	}

// New Functions
	function isSkillValid( _skill )
	{
		return _skill.isAttack();
	}

	/// We decrement the distance by 1, because our scales scales depending on the tiles BETWEEN (not the distance between), for balance reasons
	/// @param _distance tile distance from attacker tile to our tile
	function getMeleeDefenseModifier( _distance )
	{
		return ::Math.max(0, (_distance - 1) * this.m.MeleeDefensePerDistance);
	}

	/// We decrement the distance by 1, because our scales scales depending on the tiles BETWEEN (not the distance between), for balance reasons
	/// @param _distance tile distance from attacker tile to our tile
	function getRangedDefenseModifier( _distance )
	{
		return ::Math.max(0, (_distance - 1) * this.m.RangedDefensePerDistance);
	}
});
