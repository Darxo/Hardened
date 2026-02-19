this.perk_hd_anchor <- ::inherit("scripts/skills/skill", {
	m = {
		// Public
		MeleeDefenseModifier = 0,
		DamageReceivedTotalMult = 0.50,		// This is the damage reduction against attacks during this actors turn

		// Private
		IsInEffect = false,		// While true, this perk will grant its immunity to Displacement
		StartingTile = null,	// We remember the tile we started our turn on, so we know when to apply the buff
	},
	function create()
	{
		this.m.ID = "perk.hd_anchor";
		this.m.Name = ::Const.Strings.PerkName.HD_Anchor;
		this.m.Description = "No wave nor warrior can move you from your place!";
		this.m.Icon = "ui/perks/perk_hd_anchor.png";
		this.m.IconMini = "perk_hd_anchor_mini";
		this.m.Type = ::Const.SkillType.Perk | ::Const.SkillType.StatusEffect;
		this.m.Order = ::Const.SkillOrder.Perk;
		this.m.SoundVolume = 0.6;
		this.m.SoundOnHit = [	// We re-use this vanilla array just for the convenience of not having to load these resources ourselves
			"sounds/combat/flail_hit_01.wav",
			"sounds/combat/flail_hit_02.wav",
			"sounds/combat/flail_hit_03.wav",
		];
	}

	function getTooltip()
	{
		local ret = this.skill.getTooltip();

		local damageReceivedTotalMult = this.getDamageReceivedTotalMult();
		if (damageReceivedTotalMult != 1.0)
		{
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/special.png",
				text = format(::Reforged.Mod.Tooltips.parseString("Take %s damage during your [turn|Concept.Turn]"), ::MSU.Text.colorizeMultWithText(damageReceivedTotalMult, {InvertColor =true})),
			});
		}

		if (this.m.IsInEffect)
		{
			ret.push({
				id = 11,
				type = "text",
				icon = "ui/icons/special.png",
				text = ::Reforged.Mod.Tooltips.parseString("Immune to [Displacement|Concept.Displacement]"),
			});

			ret.push({
				id = 20,
				type = "text",
				icon = "ui/icons/action_points.png",
				text = ::Reforged.Mod.Tooltips.parseString("Lasts until the start of your [turn|Concept.Turn]"),
			});
		}

		return ret;
	}

	function isHidden()
	{
		return !this.m.IsInEffect && this.getDamageReceivedTotalMult() == 1.0;
	}

	function onUpdate( _properties )
	{
		if (this.getContainer().getActor().isActiveEntity())
		{
			_properties.MeleeDefense += this.m.MeleeDefenseModifier;
		}

		if (this.m.IsInEffect)
		{
			_properties.IsImmuneToKnockBackAndGrab = true;
		}
	}

	function onBeforeDamageReceived( _attacker, _skill, _hitInfo, _properties )
	{
		_properties.DamageReceivedTotalMult *= this.getDamageReceivedTotalMult();
	}

	function onTurnStart()
	{
		this.m.StartingTile = this.getContainer().getActor().getTile();
		this.m.IsInEffect = false;
	}

	function onTurnEnd()
	{
		local actor = this.getContainer().getActor();
		if (this.m.StartingTile.isSameTileAs(actor.getTile()))
		{
			this.m.IsInEffect = true;
			this.spawnIcon("perk_hd_anchor", actor.getTile());
			::Sound.play(::MSU.Array.rand(this.m.SoundOnHit), ::Const.Sound.Volume.Skill * this.m.SoundVolume, actor.getPos(), 0.5);
		}
	}

	function onCombatFinished()
	{
		this.skill.onCombatFinished();
		this.m.IsInEffect = false;
	}

// New Functions
	function getDamageReceivedTotalMult()
	{
		if (this.getContainer().getActor().isActiveEntity())
		{
			return this.m.DamageReceivedTotalMult;
		}

		return 1.0;
	}
});
