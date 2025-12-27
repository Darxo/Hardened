this.perk_hd_brace_for_impact <- ::inherit("scripts/skills/skill", {
	m = {
	// Public
		HitpointMitigationPct = 0.1,	// We take this much less Hitpoint damage for every stack
		StacksMax = 5,		// We can only have at most this many stacks

	// Private
		Stacks = 0,
	},

	function create()
	{
		this.m.ID = "perk.hd_brace_for_impact";
		this.m.Name = ::Const.Strings.PerkName.HD_BraceForImpact;
		this.m.Description = "This is going to hurt.";
		this.m.Icon = "skills/status_effect_104.png";
		this.m.Overlay = "hd_brace_for_impact_effect";
		this.m.Type = ::Const.SkillType.Perk | ::Const.SkillType.StatusEffect;
		this.m.Order = ::Const.SkillOrder.Perk;
	}

	function isHidden()
	{
		return this.m.Stacks == 0;
	}

	function getName()
	{
		local ret = this.skill.getName();
		if (this.m.Stacks >= 1) ret += " (x" + this.m.Stacks + ")";
		return ret;
	}

	function getTooltip()
	{
		local ret = this.skill.getTooltip();

		local damageReceivedRegularMult = this.HD_getDamageReceivedRegularMult();
		if (damageReceivedRegularMult != 1.0)
		{
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/damage_received.png",
				text = "Take " + ::MSU.Text.colorizeMultWithText(damageReceivedRegularMult, {InvertColor = true}) + ::Reforged.Mod.Tooltips.parseString(" [Hitpoint|Concept.Hitpoints] Damage from Attacks"),
			});
		}

		ret.push({
			id = 20,
			type = "text",
			icon = "ui/icons/action_points.png",
			text = ::Reforged.Mod.Tooltips.parseString("Lasts until the start of your next [turn|Concept.Turn]"),
		});

		return ret;
	}

	function onBeforeDamageReceived( _attacker, _skill, _hitInfo, _properties )
	{
		if (!this.isSkillValid(_skill)) return;

		// DamageReceivedTotalMult
		_properties.DamageReceivedRegularMult *= this.HD_getDamageReceivedRegularMult();
	}

	function onTurnStart()
	{
		this.m.Stacks = 0;
	}

	function onCombatFinished()
	{
		this.m.Stacks = 0;
	}

	function onMovementFinished()
	{
		local actor = this.getContainer().getActor();
		local adjacentEnemies = ::Tactical.Entities.getHostileActors(actor.getFaction(), actor.getTile(), 1, true);
		this.addStacks(adjacentEnemies.len());
	}

// New Functions
	function addStacks( _stacks )
	{
		local oldStacks = this.m.Stacks;
		this.m.Stacks = ::Math.clamp(this.m.Stacks + _stacks, 0, this.m.StacksMax);
		if ((this.m.Stacks - oldStacks) > 0)
		{
			local actor = this.getContainer().getActor();
			if (actor.isPlacedOnMap() && this.m.Overlay != "")
			{
				this.spawnIcon(this.m.Overlay, actor.getTile());
			}
		}
	}

	function isSkillValid( _skill )
	{
		return _skill != null && _skill.isAttack();
	}

	function HD_getDamageReceivedRegularMult()
	{
		return ::Math.maxf(0, 1.0 - (this.m.Stacks * this.m.HitpointMitigationPct));
	}
});
