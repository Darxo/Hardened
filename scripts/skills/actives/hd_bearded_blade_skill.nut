this.hd_bearded_blade_skill <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "actives.hd_bearded_blade";
		this.m.Name = "Bearded Blade";
		this.m.Description = "Use the bearded blade of your axe to temporarily disarm an opponent on a hit. This attack does not deal damage.";
		this.m.Icon = "skills/rf_bearded_blade_skill.png";
		this.m.IconDisabled = "skills/rf_bearded_blade_skill_sw.png";
		this.m.Overlay = "rf_bearded_blade_skill";
		this.m.SoundOnUse = [
			"sounds/combat/hook_01.wav",
			"sounds/combat/hook_02.wav",
			"sounds/combat/hook_03.wav",
		];
		this.m.SoundOnHit = [
			"sounds/combat/hook_hit_01.wav",
			"sounds/combat/hook_hit_02.wav",
			"sounds/combat/hook_hit_03.wav",
		];
		this.m.Type = ::Const.SkillType.Active;
		this.m.Order = ::Const.SkillOrder.OffensiveTargeted;
		this.m.IsSerialized = false;
		this.m.IsActive = true;
		this.m.IsTargeted = true;
		this.m.IsAttack = true;
		this.m.IsIgnoredAsAOO = true;
		this.m.IsWeaponSkill = true;

		this.m.DirectDamageMult = 0.0;
		this.m.ActionPointCost = 4;
		this.m.FatigueCost = 25;
		this.m.MinRange = 1;
		this.m.MaxRange = 1;

	// MSU Members:
		this.m.AIBehaviorID = ::Const.AI.Behavior.ID.KnockOut;
	}

	function getTooltip()
	{
		local ret = this.skill.getDefaultUtilityTooltip();

		ret.push({
			id = 7,
			type = "text",
			icon = "ui/icons/special.png",
			text = ::Reforged.Mod.Tooltips.parseString("Apply [disarmed|Skill+disarmed_effect] on a hit"),
		});

		if (!::MSU.isEqual(this.getContainer().getActor(), ::MSU.getDummyPlayer()))
		{
			ret.push({
				id = 11,
				type = "text",
				icon = "ui/icons/vision.png",
				text = "Has a range of " + ::MSU.Text.colorizeValue(this.getMaxRange()) + " tiles",
			});
		}

		return ret;
	}

	function onVerifyTarget( _originTile, _targetTile )
	{
		if (!this.skill.onVerifyTarget(_originTile, _targetTile)) return false;

		local target = _targetTile.getEntity();
		if (target.getCurrentProperties().IsImmuneToDisarm) return false;
		if (target.getCurrentProperties().IsStunned) return false;			// Stun already skips the turn which would also wait out the disarm, so we prevent this
		if (target.getSkills().hasSkill("effects.disarmed")) return false;	// Disarm does not stack so we prevent the player from making a mistake

		return true;
	}

	function onUse( _user, _targetTile )
	{
		local target = _targetTile.getEntity();
		local success = this.attackEntity(_user, target);
		if (success)
		{
			local disarm = ::new("scripts/skills/effects/disarmed_effect");
			target.getSkills().add(disarm);

			if (!_user.isHiddenToPlayer() && _targetTile.IsVisibleForPlayer)
			{
				::Tactical.EventLog.log(disarm.getLogEntryOnAdded(::Const.UI.getColorizedEntityName(_user), ::Const.UI.getColorizedEntityName(target)));
			}
		}

		return success;
	}

	function onAnySkillUsed( _skill, _targetEntity, _properties )
	{
		// We make sure that this attack does not deal any damage and never hits the ead
		if (_skill == this)
		{
			_properties.DamageTotalMult = 0.0;
			_properties.HitChanceMult[::Const.BodyPart.Head] = 0.0;
		}
	}
});
