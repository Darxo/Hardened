::Hardened.HooksMod.hook("scripts/skills/actives/shatter_skill", function(q) {
	// Public
	q.m.StaggerChance <- 33;
	q.m.KnockbackChance <- 33;

	q.create = @(__original) function()
	{
		__original();
	}

	q.getTooltip = @(__original) function()
	{
		local ret = __original();

		foreach (entry in ret)
		{
			if (entry.id == 8 && entry.icon == "ui/icons/special.png")
			{
				entry.text = ::Reforged.Mod.Tooltips.parseString("Has a " + ::MSU.Text.colorPositive(this.m.StaggerChance + "%") + " chance to [stagger|Skill+staggered_effect] on hit");
			}
			else if (entry.id == 9 && entry.icon == "ui/icons/special.png")
			{
				entry.text = "Has a " + ::MSU.Text.colorPositive(this.m.KnockbackChance + "%") + " chance to knock back on hit";
			}
		}

		return ret;
	}

	// Overwrite because we make the effect much more moddable.
	// Stagger and Knockback are now independant effects and can happen at the same time on the same target
	q.applyEffectToTarget = @() function(_user, _target, _targetTile)
	{
		if (::Math.rand(1, 100) <= this.m.StaggerChance)
		{
			this.applyStagger(_user, _target, _targetTile);
		}

		if (::Math.rand(1, 100) <= this.m.KnockbackChance)
		{
			this.knockBack(_user, _target, _targetTile);
		}
	}

// New Functions
	q.applyStagger <- function(_user, _target, _targetTile)
	{
		if (_target.isNonCombatant())
		{
			return;
		}

		_target.getSkills().add(::new("scripts/skills/effects/staggered_effect"));

		if (!_user.isHiddenToPlayer() && _targetTile.IsVisibleForPlayer)
		{
			::Tactical.EventLog.log(::Const.UI.getColorizedEntityName(_user) + " has staggered " + ::Const.UI.getColorizedEntityName(_target) + " for two turns");
		}
	}

	q.knockBack <- function(_user, _target, _targetTile)
	{
		if (_target.getCurrentProperties().IsImmuneToKnockBackAndGrab || _target.getCurrentProperties().IsRooted)
		{
			return;
		}

		local knockToTile = this.findTileToKnockBackTo(_user.getTile(), _targetTile);

		if (knockToTile == null)
		{
			return;
		}

		this.m.TilesUsed.push(knockToTile.ID);

		if (!_user.isHiddenToPlayer() && (_targetTile.IsVisibleForPlayer || knockToTile.IsVisibleForPlayer))
		{
			this.Tactical.EventLog.log(::Const.UI.getColorizedEntityName(_user) + " has knocked back " + ::Const.UI.getColorizedEntityName(_target));
		}

		local skills = _target.getSkills();
		skills.removeByID("effects.shieldwall");
		skills.removeByID("effects.spearwall");
		skills.removeByID("effects.riposte");
		_target.setCurrentMovementType(::Const.Tactical.MovementType.Involuntary);
		local damage = this.Math.max(0, this.Math.abs(knockToTile.Level - _targetTile.Level) - 1) * ::Const.Combat.FallingDamage;

		if (damage == 0)
		{
			this.Tactical.getNavigator().teleport(_target, knockToTile, null, null, true);
		}
		else
		{
			local p = this.getContainer().getActor().getCurrentProperties();
			local tag = {
				Attacker = _user,
				Skill = this,
				HitInfo = clone ::Const.Tactical.HitInfo
			};
			tag.HitInfo.DamageRegular = damage;
			tag.HitInfo.DamageDirect = 1.0;
			tag.HitInfo.BodyPart = ::Const.BodyPart.Body;
			tag.HitInfo.BodyDamageMult = 1.0;
			tag.HitInfo.FatalityChanceMult = 1.0;
			this.Tactical.getNavigator().teleport(_target, knockToTile, this.onKnockedDown, tag, true);
		}
	}

});
