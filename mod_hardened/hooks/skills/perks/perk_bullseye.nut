::Hardened.HooksMod.hook("scripts/skills/perks/perk_bullseye", function(q) {
	q.m.DamageDirectAdd <- 0.25;

	// This perk no longer nerfs target cover
	q.onUpdate = @() function( _properties ) {}

	// Overwrite because we are more restrictive
	q.onAnySkillUsed = @() function( _skill, _targetEntity, _properties )
	{
		if (_targetEntity == null || !this.isSkillValid(_skill)) return;

		local actor = this.getContainer().getActor();
		if (::Const.Tactical.Common.getBlockedTiles(actor.getTile(), _targetEntity.getTile(), _targetEntity.getFaction()).len() == 0)
		{
			_properties.DamageDirectAdd += this.m.DamageDirectAdd;
		}
	}

	// Overwrite because we are more restrictive
	q.onGetHitFactors = @() function( _skill, _targetTile, _tooltip )
	{
		if (!this.isSkillValid(_skill)) return;

		local actor = this.getContainer().getActor();
		if (::Const.Tactical.Common.getBlockedTiles(actor.getTile(), _targetTile, actor.getFaction()).len() == 0)
		{
			_tooltip.push({
				icon = "ui/icons/direct_damage.png",
				text = this.getName(),
			});
		}
	}

// New Functions
	q.isSkillValid <- function( _skill )
	{
		return _skill != null && _skill.isAttack() && _skill.isRanged();
	}
});
