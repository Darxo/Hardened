::Hardened.HooksMod.hook("scripts/skills/actives/split_shield", function(q) {
	q.m.BonusShieldDamage <- 0;
	q.m.ShieldDamageMult <- 1.0;

	q.create = @(__original) function()
	{
		__original();
		this.m.Name = "Split Shield";
		this.m.Description = "An attack specifically aimed at destroying an opponent\'s shield. Can only be used against targets that carry a shield. Will always hit but may take several hits depending on type of shield and weapon used.";
	}

	// Replace Reforged tooltip until it gets more moddable
	q.getTooltip = @() function()
	{
		// We overwrite the vanilla split_shield tooltip, because that one assumes a weapon to be equipped in the main hand
		local ret = this.skill.getDefaultUtilityTooltip();

		local expectedShieldDamage = this.getShieldDamage() * this.getExpectedShieldDamageMult();
		ret.push({
			id = 10,
			type = "text",
			icon = "ui/icons/shield_damage.png",
			text = "Deal " + ::MSU.Text.colorDamage(expectedShieldDamage) + " Shield Damage",
		});

		if (this.getMaxRange() > 1)
		{
			ret.push({
				id = 8,
				type = "text",
				icon = "ui/icons/vision.png",
				text = "Has a range of " + ::MSU.Text.colorPositive(this.m.MaxRange) + " tiles",
			});
		}

		return ret;
	}

	// Overwrite Reforged onUse until it gets more moddable
	q.onUse = @() function( _user, _targetTile )
	{
		local targetEntity = _targetTile.getEntity()
		local shield = targetEntity.getOffhandItem();

		if (shield != null)
		{
			this.spawnAttackEffect(_targetTile, ::Const.Tactical.AttackEffectSplitShield);

			local conditionBefore = shield.getCondition();
			shield.applyShieldDamage(this.getShieldDamage());

			if (shield.getCondition() == 0)
			{
				if (!_user.isHiddenToPlayer() && _targetTile.IsVisibleForPlayer)
				{
					::Tactical.EventLog.log(::Const.UI.getColorizedEntityName(_user) + " uses " + this.getName() + " and destroys " + ::Const.UI.getColorizedEntityName(_targetTile.getEntity()) + "\'s shield");
				}
			}
			else
			{
				if (this.m.SoundOnHit.len() != 0)
				{
					::Sound.play(::MSU.Array.rand(this.m.SoundOnHit), ::Const.Sound.Volume.Skill, _targetTile.getEntity().getPos());
				}

				if (!_user.isHiddenToPlayer() && _targetTile.IsVisibleForPlayer)
				{
					::Tactical.EventLog.log(::Const.UI.getColorizedEntityName(_user) + " uses " + this.getName() + " and hits " + ::Const.UI.getColorizedEntityName(_targetTile.getEntity()) + "\'s shield for [b]" + (conditionBefore - shield.getCondition()) + "[/b] damage");
				}
			}

			if (!::Tactical.getNavigator().isTravelling(_targetTile.getEntity()))
			{
				::Tactical.getShaker().shake(_targetTile.getEntity(), _user.getTile(), 2, ::Const.Combat.ShakeEffectSplitShieldColor, ::Const.Combat.ShakeEffectSplitShieldHighlight, ::Const.Combat.ShakeEffectSplitShieldFactor, 1.0, [
					"shield_icon"
				], 1.0);
			}

			_user.getSkills().onTargetHit(this, targetEntity, ::Const.BodyPart.Body, 0, 0);
		}

		return true;
	}

// Hardened Functions
	q.getQueryTargetValueMult = @(__original) function( _user, _target, _skill )
	{
		local ret = __original(_user, _target, _skill);

		if (this.getContainer().getActor().getID() != _user.getID()) return ret;	// We must be the user

		local targetShield = _target.getOffhandItem();
		if (targetShield == null) return ret;
		if (!targetShield.isItemType(::Const.Items.ItemType.Shield)) return ret;

		if (::MSU.isNull(this.getItem())) return ret;

		local expectedShieldDamage = this.getShieldDamage() * this.getExpectedShieldDamageMult(_target);
		if (expectedShieldDamage > targetShield.getCondition())
		{
			ret *= 1.5;		// We strongly prefer targetting shields, that will die instantly, over those, which survive the impact
		}

		return ret;
	}

// New Functions
	// Return the raw shield damage, that this skill in isolation would do
	q.getShieldDamage <- function()
	{
		local skillItem = this.getItem();
		if (::MSU.isNull(skillItem) || !skillItem.isItemType(::Const.Items.ItemType.Weapon)) return 0;

		return skillItem.getShieldDamage();
	}
});
