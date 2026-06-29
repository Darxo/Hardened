this.perk_hd_zweikampf <- ::inherit("scripts/skills/skill", {
	m = {
		BraveryModifier = 20,
		InitiativeModifier = 20,
		DamageReceivedTotalMult = 0.75,
	},
	function create()
	{
		this.m.ID = "perk.hd_zweikampf";
		this.m.Name = ::Const.Strings.PerkName.HD_Zweikampf;
		this.m.Description = "Let's Dance!";
		this.m.Icon = "ui/perks/perk_rf_swordmaster_juggernaut.png";
		// Todo: add mini icon
		this.m.Type = ::Const.SkillType.Perk | ::Const.SkillType.StatusEffect;
		this.m.Order = ::Const.SkillOrder.Perk;
	}

	function isHidden()
	{
		return !this.isEnabled();
	}

	function getTooltip()
	{
		local ret = this.skill.getTooltip();

		if (this.m.BraveryModifier != 0)
		{
			ret.push({
				id = 11,
				type = "text",
				icon = "ui/icons/bravery.png",
				text = ::MSU.Text.colorizeValue(this.m.BraveryModifier, {AddSign = true}) + ::Reforged.Mod.Tooltips.parseString(" [Resolve|Concept.Bravery]"),
			});
		}

		if (this.m.InitiativeModifier != 0)
		{
			ret.push({
				id = 12,
				type = "text",
				icon = "ui/icons/initiative.png",
				text = ::MSU.Text.colorizeValue(this.m.InitiativeModifier, {AddSign = true}) + ::Reforged.Mod.Tooltips.parseString(" [Initiative|Concept.Initiative]"),
			});
		}

		if (this.m.DamageReceivedTotalMult != 1.0)
		{
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/melee_defense.png",
				text = format("Take %s Damage", ::MSU.Text.colorizeMultWithText(this.m.DamageReceivedTotalMult, {InvertColor =true})),
			});
		}

		return ret;
	}

	function onUpdate( _properties )
	{
		_properties.UpdateWhenTileOccupationChanges = true;		// Because our bonus is applied depending on how many adjacent allies/enemies there are

		if (this.isEnabled())
		{
			_properties.Bravery += this.m.BraveryModifier;
			_properties.Initiative += this.m.InitiativeModifier;
			_properties.DamageReceivedTotalMult *= this.m.DamageReceivedTotalMult;
		}
	}

// New Functions
	function isEnabled()
	{
		local actor = this.getContainer().getActor();
		if (!actor.isPlacedOnMap()) return false;

		local neighbors = 0;
		foreach (nextTile in ::MSU.Tile.getNeighbors(actor.getTile()))
		{
			if (!nextTile.IsOccupiedByActor) continue;
			neighbors += 1;
		}

		return neighbors == 1;
	}
});
