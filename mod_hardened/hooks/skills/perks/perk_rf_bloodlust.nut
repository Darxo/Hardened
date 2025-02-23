::Hardened.wipeClass("scripts/skills/perks/perk_rf_bloodlust", [
	"create",
]);

// Our Implementation is not perfect. It can't deal with any delayed skills like Ranged Attacks or Lunge/Charge like abilities
// However we can deal with proxy-activations where one skill activates another one within it, if those happen instantly with no delay of course
::Hardened.HooksMod.hook("scripts/skills/perks/perk_rf_bloodlust", function(q) {
	// Public
	q.m.DamageTotalMult <- 1.1;		// Damage multiplier for when this character attacks a bleeding enemy
	q.m.DamageReceivedTotalMult <- 0.9;	// Damage multiplier for when this character is attacked by a bleeding enemy

	// Private
	q.m.IsAttackingBleedingEnemy <- false;
	q.m.IsAttackedByBleedingENemy <- false;

	q.create = @(__original) function()
	{
		__original();
		this.m.Type = ::Const.SkillType.Perk;
		this.m.IsHidden = true;
	}

	q.onAnySkillUsed <- function( _skill, _targetEntity, _properties )
	{
		if (this.isEnabled() && !::MSU.isNull(_targetEntity) && this.isEnabledFor(_targetEntity))
		{
			_properties.DamageTotalMult *= this.m.DamageTotalMult;
		}
	}

	q.onBeforeDamageReceived <- function( _attacker, _skill, _hitInfo, _properties )
	{
		if (this.isEnabled() && !::MSU.isNull(_attacker) && this.isEnabledFor(_attacker))
		{
			_properties.DamageReceivedTotalMult *= this.m.DamageReceivedTotalMult;
		}
	}

// MSU Events
	q.onGetHitFactors <- function( _skill, _targetTile, _tooltip )
	{
		if (_targetTile.IsOccupiedByActor && this.isEnabledFor(_targetTile.getEntity()) && this.isEnabled())
		{
			_tooltip.push({
				icon = "ui/icons/damage_dealt.png",
				text = this.getName(),
			});
		}
	}

	q.onGetHitFactorsAsTarget <- function( _skill, _targetTile, _tooltip )
	{
		if (this.isEnabled() && this.isEnabledFor(_skill.getContainer().getActor()))
		{
			_tooltip.push({
				icon = "ui/tooltips/negative.png",
				text = this.getName(),
			});
		}
	}

// New Functions
	q.isEnabled <- function()
	{
		if (this.m.RequiredWeaponType == null) return true;

		local weapon = this.getContainer().getActor().getMainhandItem();
		return weapon != null && weapon.isItemType(::Const.Items.ItemType.Weapon) && weapon.isWeaponType(this.m.RequiredWeaponType);
	}

	q.isEnabledFor <- function( _targetEntity )
	{
		return _targetEntity.getSkills().hasSkill("effects.bleeding");
	}
});
