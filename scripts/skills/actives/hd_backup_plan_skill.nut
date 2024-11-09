this.hd_backup_plan_skill <- this.inherit("scripts/skills/skill", {
	m = {
		// Public
		ActionPointsRecovered = 7,

		// Private
		IsSpent = false,	// This skill can only be used once per combat
		IsEffectActive = false,	// This skill will apply a debuff for the rest of this turn, controlled by flag
	},
	function create()
	{
		this.m.ID = "actives.hd_backup_plan";
		this.m.Name = "Backup Plan";
		this.m.Description = "I\'ve got a Plan B!";
		this.m.Icon = "skills/rf_bestial_vigor_skill.png";	// Todo, find new skill
		this.m.IconDisabled = "skills/rf_bestial_vigor_skill_sw.png";	// Todo, find new skill
		this.m.Overlay = "rf_bestial_vigor_skill";	// Todo, find new overlay
		this.m.SoundOnUse = [
			"sounds/new_round_01.wav",
			"sounds/new_round_02.wav",
			"sounds/new_round_03.wav",
		];
		this.m.Type = ::Const.SkillType.Active;
		this.m.Order = ::Const.SkillOrder.Any;
		this.m.IsSerialized = false;
		this.m.IsActive = true;
		this.m.IsIgnoredAsAOO = true;
		this.m.ActionPointCost = 0;
		this.m.FatigueCost = 0;
	}

	function getTooltip()
	{
		local ret = this.skill.getDefaultUtilityTooltip();

		ret.push({
			id = 10,
			type = "text",
			icon = "ui/icons/action_points.png",
			text = ::Reforged.Mod.Tooltips.parseString("Recover " + ::MSU.Text.colorizeValue(this.m.ActionPointsRecovered) + " [Action Point(s)|Concept.ActionPoints]"),
		});

		ret.push({
			id = 11,
			type = "text",
			icon = "ui/icons/special.png",
			text = ::Reforged.Mod.Tooltips.parseString("Disable all Attack-Skills during your turn until the end of your turn"),
		});

		ret.push({
			id = 20,
			type = "text",
			icon = "ui/icons/warning.png",
			text = "Can only be used once per battle",
		});

		if (this.m.IsSpent)
		{
			ret.push({
				id = 21,
				type = "text",
				icon = "ui/icons/warning.png",
				text = ::MSU.Text.colorNegative("Has already been used this battle"),
			});
		}

		return ret;
	}

	function isUsable()
	{
		return !this.m.IsSpent && this.skill.isUsable();
	}

	function onUpdate( _properties )
	{
		if (this.m.IsEffectActive && ::Tactical.TurnSequenceBar.isActiveEntity(this.getContainer().getActor()))
		{
			this.setAllAttacks(false);
		}
	}

	function onVerifyTarget( _originTile, _targetTile )
	{
		return true;
	}

	function onUse( _user, _targetTile )
	{
		this.m.IsSpent = true;
		this.m.IsEffectActive = true;

		local actor = this.getContainer().getActor().recoverActionPoints(this.m.ActionPointsRecovered);

		return true;
	}

	function onTurnEnd()
	{
		if (this.m.IsEffectActive)
		{
			this.m.IsEffectActive = false;
			this.setAllAttacks(true);
		}
	}

	function onCombatFinished()
	{
		if (this.m.IsEffectActive)
		{
			this.m.IsEffectActive = false;
			this.setAllAttacks(true);
		}
		this.m.IsSpent = false;
	}

// MSU Events
	function onQueryTooltip( _skill, _tooltip )
	{
		if (this.m.IsEffectActive && _skill.isAttack() && ::Tactical.TurnSequenceBar.isActiveEntity(this.getContainer().getActor()))
		{
			_tooltip.push({
				id = 100,
				type = "text",
				icon = "ui/icons/warning.png",
				text = ::Reforged.Mod.Tooltips.parseString("Cannot be used because of " + ::Reforged.NestedTooltips.getNestedSkillName(this)),
			});
		}
	}

// New Function
	function setAllAttacks( _enabled )
	{
		local changeHappened = false;
		// Reduce fatigue cost of all spear attacks
		foreach (skill in this.getContainer().m.Skills)
		{
			if (skill.isAttack())
			{
				if (skill.m.IsUsable != _enabled)
				{
					changeHappened = true;
					skill.m.IsUsable = _enabled;
				}
			}
		}

		if (changeHappened)	// Otherwise during the onUpdate loop we would constantly update the UI
		{
			this.getContainer().getActor().setDirty(true);	// Update the UI so that enable/disable status is visible instantly
		}
	}
});

