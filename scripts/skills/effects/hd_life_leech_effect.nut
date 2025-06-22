this.hd_life_leech_effect <- ::inherit("scripts/skills/skill", {
	m = {
		// Public
		PctDamageLeechedAsLife = 1.0,	// This much of the dealt damage is leeched as life
		LeechDistance = 1,	// Maximum Distance to target for leech to happen
	},
	function create()
	{
		this.m.ID = "effects.rf_life_leech";
		this.m.Name = "Life Leech";
		this.m.Description = "This character may recover Hitpoints when dealing damage to nearby enemies.";
		this.m.Icon = "skills/status_effect_09.png";
		this.m.Overlay = "status_effect_09";
		this.m.SoundOnUse = [
			"sounds/enemies/vampire_life_drain_01.wav",
			"sounds/enemies/vampire_life_drain_02.wav",
			"sounds/enemies/vampire_life_drain_03.wav",
		];
		this.m.Type = ::Const.SkillType.StatusEffect;
		this.m.Order = ::Const.SkillOrder.Any;
	}

	function getTooltip()
	{
		local ret = this.skill.getTooltip();

		local withinText = this.m.LeechDistance == 1 ? "adjacent enemies" : "enemies within " + ::MSU.Text.colorPositive(this.m.LeechDistance) + " tiles";
		ret.push({
			id = 11,
			type = "text",
			icon = "ui/icons/health.png",
			text = ::Reforged.Mod.Tooltips.parseString("Recover " + ::MSU.Text.colorizePct(this.m.PctDamageLeechedAsLife) + " of [Hitpoint|Concept.Hitpoints] damage inflicted on " + withinText + " that have red blood"),
		});

		return ret;
	}

	function onTargetHit( _skill, _targetEntity, _bodyPart, _damageInflictedHitpoints, _damageInflictedArmor )
	{
		if (_damageInflictedHitpoints == 0) return;

		local actor = this.getContainer().getActor();
		if (actor.getHitpoints() == actor.getHitpointsMax()) return;	// We are already at full health

		if (!this.isTargetValid(_targetEntity)) return;

		if (_targetEntity.isPlacedOnMap())	// If our attack kills the target, then it is no longer placed on the map
		{
			if (actor.getTile().getDistanceTo(_targetEntity.getTile()) > this.m.LeechDistance) return;
		}

		this.leechLife(_damageInflictedHitpoints);
	}

// New Functions
	function isTargetValid( _target )
	{
		return _target.m.BloodType == ::Const.BloodType.Red;
	}

	// Recover life points depending on the damage inflicted
	// @param _damageInflicted amount of damage dealt to the target
	function leechLife( _damageInflicted )
	{
		local actor = this.getContainer().getActor();

		// If any leeching happens, we color the vampire mouth red
		local vampireRacial = actor.getSkills().getSkillByID("racial.vampire");
		if (vampireRacial != null)
		{
			vampireRacial.m.RF_HasFed = true;	// This variable controls, whether there should be a blood effect on the vampire mouth
		}

		local hitpointsHealed = ::Math.round(_damageInflicted * this.m.PctDamageLeechedAsLife);

		local leechedLife = actor.recoverHitpoints(hitpointsHealed, true);
		if (leechedLife <= 0) return;	// Probably because of a debuff, we didn't recover even a single hitpoint. Therefor we play no animation or sound

		this.spawnIcon("status_effect_09", actor.getTile());

		if (!actor.isHiddenToPlayer())
		{
			if (this.m.SoundOnUse.len() != 0)
			{
				::Sound.play(::MSU.Array.rand(this.m.SoundOnUse), ::Const.Sound.Volume.RacialEffect, actor.getPos());
			}
		}
	}
});
