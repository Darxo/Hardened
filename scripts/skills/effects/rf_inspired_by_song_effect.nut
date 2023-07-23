this.rf_inspired_by_song_effect <- ::inherit("scripts/skills/skill", {
	m = {
		// public
		RemoveThreshold = 5,		// If the ResolveBonus reaches this value after halfing then this buff is removed

		// private
		ResolveBonus = 0,
		Musician = null		// weakref to the entity who played this song
	},

	function create()
	{
		this.m.ID = "effects.rf_inspired_by_song";
		this.m.Name = "Inspired by Song";
		this.m.Description = "This character was inspired by one of their allies playing a song. The Resolve Bonus of this effect halfs at the end of each turn.";
		this.m.Icon = "skills/rf_battle_song_skill.png";	// Todo replace placeholder
		this.m.IconMini = "";	// Todo add mini icon
		this.m.Overlay = "rf_battle_song_skill";
		this.m.Type = ::Const.SkillType.StatusEffect;
		this.m.IsActive = false;
		this.m.IsRemovedAfterBattle = true;
	}

	function init( _musician, _resolveBonus )
	{
		this.m.Musician = ::MSU.asWeakTableRef(_musician);
		this.m.ResolveBonus = _resolveBonus;
	}

	function getDescription()
	{
		local ret = this.skill.getDescription();
		ret += "This buff is removed when it reaches " + this.m.RemoveThreshold + " or less.";
		return ret;
	}

	function getTooltip()
	{
		local ret = this.skill.getTooltip();

		if (this.m.ResolveBonus != 0)
		{
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/bravery.png",
				text = ::MSU.Text.colorizeValue(this.m.ResolveBonus) + " Resolve"
			});
		}

		if (this.m.Musician != null)
		{
			ret.push({
				id = 11,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Musician: " + this.m.Musician.getName()
			});
		}

		return ret;
	}

	function onUpdate( _properties )
	{
		_properties.Bravery += this.m.ResolveBonus;
	}

	function onTurnEnd()
	{
		this.m.ResolveBonus = ::Math.floor(this.m.ResolveBonus * 0.5);
		if (this.m.ResolveBonus <= this.m.RemoveThreshold)
		{
			this.removeSelf();
			this.getContainer().getActor().setDirty(true);		// So that the Icon is removed instantly from the overlay
		}
		else
		{
			this.getContainer().update();	// So that the new Resolve bonus is already applied instantly
		}
	}

	// public
	function increaseBonus( _additionalResolve )	// This is called from outside by the rf_battle_song_skill
	{
		this.m.ResolveBonus += _additionalResolve;
		this.spawnIcon(this.m.Overlay, this.getContainer().getActor().getTile());
		this.getContainer().update();	// So that the new Resolve bonus is already applied instantly
	}
});
