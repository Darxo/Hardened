// This special effect is meant to be given to certain enemies in certain encounters at the start of combat
// It can be used to:
// 	- Delay enemy actions by X turns during an encircled ambush scenario to allow player to relocate
//	- Delay certain parts of an army so that the enemy attacks staggered
//	- Hide certain enemies in bushes until a random time expires or you get too close
this.hd_lying_in_ambush_effect <- this.inherit("scripts/skills/skill", {
	m = {
		MeleeDefenseModifier = 30,
		RangedDefenseModifier = 30,
		InitiativeModifier = 30,
		DurationInRounds = 2,	// This is counted down on round start and this effect is removed when this hits 0. A value of 1 will almost do nothing as it will be removed on round 1
		TileAlertRadius = 3,	// On RoundStart, when an enemy is within this many tiles, remove this effect

		// Private
		RemainingDuration = null,
	},

	function create()
	{
		this.m.ID = "effects.hd_lying_in_ambush";
		this.m.Name = "Lying in Ambush";
		this.m.Icon = "ui/perks/perk_rf_ghostlike.png";		// Todo, find other unique art?
		this.m.Type = ::Const.SkillType.StatusEffect;
		this.m.IsRemovedAfterBattle = true;
	}

	function getTooltip()
	{
		local ret = this.skill.getTooltip();

		ret.push({
			id = 11,
			type = "text",
			icon = "ui/icons/melee_defense.png",
			text = ::Reforged.Mod.Tooltips.parseString(::MSU.Text.colorizeValue(this.m.MeleeDefenseModifier, {AddSign = true}) + " [Melee Defense|Concept.MeleeDefense]"),
		});

		ret.push({
			id = 11,
			type = "text",
			icon = "ui/icons/ranged_defense.png",
			text = ::Reforged.Mod.Tooltips.parseString(::MSU.Text.colorizeValue(this.m.RangedDefenseModifier, {AddSign = true}) + " [Ranged Defense|Concept.RangeDefense]"),
		});

		ret.push({
			id = 12,
			type = "text",
			icon = "ui/icons/initiative.png",
			text = ::Reforged.Mod.Tooltips.parseString(::MSU.Text.colorizeValue(this.m.InitiativeModifier, {AddSign = true}) + " [Initiative|Concept.Initiative]"),
		});

		if (this.m.TileAlertRadius > 0)
		{
			ret.push({
				id = 20,
				type = "text",
				icon = "ui/icons/warning.png",
				text = ::Reforged.Mod.Tooltips.parseString("Is removed at the start of the [round,|Concept.Round] when an enemy is within " + ::MSU.Text.colorPositive(this.m.TileAlertRadius) + " tiles"),
			});
		}

		if (this.m.RemainingDuration > 1)
		{
			ret.push({
				id = 21,
				type = "text",
				icon = "ui/icons/action_points.png",
				text = ::Reforged.Mod.Tooltips.parseString("Lasts for " + this.m.RemainingDuration + " [rounds|Concept.Round]"),
			});
		}
		else	// Then it must be == 1
		{
			ret.push({
				id = 21,
				type = "text",
				icon = "ui/icons/action_points.png",
				text = ::Reforged.Mod.Tooltips.parseString("Lasts until the start of the next [round|Concept.Round]"),
			});
		}

		return ret;
	}

	function onNewRound()
	{
		if (this.m.RemainingDuration != null)
		{
			this.m.RemainingDuration--;
			if (this.m.RemainingDuration <= 0) this.removeSelf();
		}

		if (this.m.TileAlertRadius > 0)
		{
			local actor = this.getContainer().getActor();
			if (::Tactical.Entities.getHostileActors(actor.getFaction(), actor.getTile(), this.m.TileAlertRadius).len() > 0) this.removeSelf();
		}
	}

	function onAdded()
	{
		this.m.RemainingDuration = this.m.DurationInRounds;
	}

	function onUpdate( _properties )
	{
		this.getContainer().getActor().setActionPoints(0);	// That way this entity will not do anything
		_properties.MeleeDefense += this.m.MeleeDefenseModifier;
		_properties.RangedDefense += this.m.RangedDefenseModifier;
		_properties.Initiative += this.m.InitiativeModifier;
	}
});
