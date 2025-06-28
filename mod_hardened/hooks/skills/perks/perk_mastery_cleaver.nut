// The reforged hook for this perk is being sniped
::Hardened.HooksMod.hook("scripts/skills/perks/perk_mastery_cleaver", function(q) {
	q.m.CriticalDamagePct <- 0.5;	// This much Critical Damage is gained when targeting the body of a disarmed or unarmed (melee weapon) enemy

	q.create = @(__original) function()
	{
		__original();
		this.m.Icon = "ui/perks/perk_52.png";	// Vanilla Fix: Vanilla has the icon for Anticipation here
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
	q.isTargetValid <- function( _target )
	{
		if (::MSU.isNull(_target)) return false;

		local item = _target.getMainhandItem();
		return (::MSU.isNull(item) || !item.isItemType(::Const.Items.ItemType.MeleeWeapon) || _target.isDisarmed())
	}
});
