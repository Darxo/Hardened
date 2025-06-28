// The reforged hook for this perk is being sniped
::Hardened.HooksMod.hook("scripts/skills/perks/perk_mastery_cleaver", function(q) {
	// Public
	q.m.CriticalDamagePct <- 0.5;	// This much Critical Damage is gained when targeting the body of a disarmed or unarmed (melee weapon) enemy
	q.m.HD_FatigueCostMult <- 0.75;

	q.create = @(__original) function()
	{
		__original();
		this.m.Icon = "ui/perks/perk_52.png";	// Vanilla Fix: Vanilla has the icon for Anticipation here
	}

	q.onAfterUpdate = @(__original) function( _properties )
	{
		__original(_properties);
		// Feat: We now implement the fatigue cost discount of masteries within the mastery perk
		if (this.m.HD_FatigueCostMult != 1.0)
		{
			foreach (skill in this.getContainer().m.Skills)
			{
				if (this.isSkillValid(skill))
				{
					skill.m.FatigueCostMult *= this.m.HD_FatigueCostMult;
				}
			}
		}
	}

	q.onAnySkillUsed = @(__original) function( _skill, _targetEntity, _properties )
	{
		__original(_skill, _targetEntity, _properties);

		if (this.isSkillValid(_skill) && this.isTargetValid(_targetEntity))
		{
			_properties.DamageAgainstMult[::Const.BodyPart.Body] += this.m.CriticalDamagePct;
		}
	}

// MSU Functions
	q.onGetHitFactors = @(__original) function( _skill, _targetTile, _tooltip )
	{
		__original(_skill, _targetTile, _tooltip);

		if (!_targetTile.IsOccupiedByActor) return;

		if (this.isSkillValid(_skill) && this.isTargetValid(_targetTile.getEntity()))
		{
			_tooltip.push({
				icon = this.getIconColored(),
				text = this.getName(),
			});
		}
	}

// New Functions
	q.isSkillValid <- function( _skill )
	{
		if (_skill == null) return false;
		if (!_skill.isActive()) return false;

		local skillItem = _skill.getItem();
		if (::MSU.isNull(skillItem)) return false;
		if (!skillItem.isItemType(::Const.Items.ItemType.Weapon)) return false;
		if (!skillItem.isWeaponType(::Const.Items.WeaponType.Cleaver)) return false;

		return true;
	}

	q.isTargetValid <- function( _target )
	{
		if (::MSU.isNull(_target)) return false;

		local item = _target.getMainhandItem();
		return (::MSU.isNull(item) || !item.isItemType(::Const.Items.ItemType.MeleeWeapon) || _target.isDisarmed())
	}
});
