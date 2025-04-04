this.hd_inspired_by_song_effect <- ::inherit("scripts/skills/skill", {
	m = {
		// public
		RemoveThreshold = 5,		// If the ResolveBonus reaches this value after halfing then this buff is removed

		// private
		ResolveLossPct = 0.5,	// This much resolve is lost each turn
		ResolveBonus = 0,
		Musician = null,		// weakref to the entity who played this song
	},

	function create()
	{
		this.m.ID = "effects.rf_inspired_by_song";
		this.m.Name = "Inspired by Song";
		this.m.Description = "This character was inspired by one of their allies playing a song.";
		this.m.Icon = "skills/hd_inspired_by_song_effect.png";
		this.m.IconMini = "hd_inspired_by_song_effect_mini";
		this.m.Overlay = "hd_inspired_by_song_effect";
		this.m.Type = ::Const.SkillType.StatusEffect;
		this.m.IsActive = false;
		this.m.IsRemovedAfterBattle = true;
	}

	function init( _musician, _resolveBonus )
	{
		this.m.Musician = ::MSU.asWeakTableRef(_musician);
		this.m.ResolveBonus = _resolveBonus;
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
				text = ::Reforged.Mod.Tooltips.parseString(::MSU.Text.colorizeValue(this.m.ResolveBonus, {AddSign = true}) + " [Resolve|Concept.Bravery]"),
			});
		}

		ret.push({
			id = 11,
			type = "text",
			icon = "ui/icons/special.png",
			text = ::Reforged.Mod.Tooltips.parseString("At the end of your turn, lose " + ::MSU.Text.colorizePct(this.m.ResolveLossPct) + " of this bonus and remove this effect when it reaches " + ::MSU.Text.colorNegative(this.m.RemoveThreshold) + " [Resolve|Concept.Bravery]"),
		});

		if (!::MSU.isNull(this.m.Musician))
		{
			ret.push({
				id = 12,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Musician: " + ::Const.UI.getColorizedEntityName(this.m.Musician),
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
		this.m.ResolveBonus -= ::Math.ceil(this.m.ResolveBonus * this.m.ResolveLossPct);
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
	function increaseBonus( _additionalResolve )	// This is called from outside by the hd_battle_song_skill
	{
		this.m.ResolveBonus += _additionalResolve;
		this.spawnIcon(this.m.Overlay, this.getContainer().getActor().getTile());
		this.getContainer().update();	// So that the new Resolve bonus is already applied instantly
	}
});
