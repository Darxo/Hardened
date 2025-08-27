::Hardened.wipeClass("scripts/skills/perks/perk_rf_nailed_it", [
	"create",
]);

::Hardened.HooksMod.hook("scripts/skills/perks/perk_rf_nailed_it", function(q) {
	// Public
	q.m.HeadShotChance <- 25;	// This much Headshot chance is granted at a range of 2 tiles
	q.m.RangedAttackBlockedChanceMult <- 0.5;	// Multiplier for blocked attacks at a range of 2 tiles

	q.onAnySkillUsed = @(__original) function( _skill, _targetEntity, _properties )
	{
		__original(_skill, _targetEntity, _properties);

		if (this.isAttackValid(_skill, _targetEntity))
		{
			_properties.HitChance[::Const.BodyPart.Head] += this.m.HeadShotChance;
			_properties.RangedAttackBlockedChanceMult = 0;
		}
	}

// New Functions
	function isAttackValid( _skill, _targetEntity )
	{
		if (!_skill.isAttack()) return false;
		if (_targetEntity == null) return false;

		local distance = this.getContainer().getActor().getTile().getDistanceTo(_targetEntity.getTile());
		return (distance == 2);
	}
});
