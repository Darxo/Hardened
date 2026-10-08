::Hardened.HooksMod.hook("scripts/skills/perks/perk_bullseye", function(q) {
	q.m.DamageDirectAdd <- 0.20;

	// This perk no longer nerfs target cover
	q.onUpdate = @() function( _properties ) {}

	// Overwrite because we are more restrictive
	q.onAnySkillUsed = @() function( _skill, _targetEntity, _properties )
	{
		if (_targetEntity == null || !this.isSkillValid(_skill)) return;

		local actor = this.getContainer().getActor();
		if (::Const.Tactical.Common.getBlockedTiles(actor.getTile(), _targetEntity.getTile(), actor.getFaction()).len() == 0)
		{
			_properties.DamageDirectAdd += this.m.DamageDirectAdd;
		}
	}

// MSU Functions
	// Overwrite because we implement this in our HD_onGetTargetingTooltipAsUser event instead
	q.onGetHitFactors = @() function( _skill, _targetTile, _tooltip )
	{
	}

// Hardened Functions
	q.HD_onGetTargetingTooltipAsUser = @(__original) { function HD_onGetTargetingTooltipAsUser( _skill, _targetActor, _tooltip )
	{
		__original(_skill, _targetActor, _tooltip);

		if (!this.isSkillValid(_skill)) return;

		local actor = this.getContainer().getActor();
		if (::Const.Tactical.Common.getBlockedTiles(actor.getTile(), _targetActor.getTile(), actor.getFaction()).len() == 0)
		{
			local extraData = "entityId:" + this.getContainer().getActor().getID();
			_tooltip.push({
				id = 10,
				type = "headerText",
				icon = this.getIconColored(),
				text = ::Reforged.Mod.Tooltips.parseString(::Reforged.NestedTooltips.getNestedSkillName(this, extraData)),
			});
		}
	}}.HD_onGetTargetingTooltipAsUser;

// New Functions
	q.isSkillValid <- function( _skill )
	{
		return _skill != null && _skill.isAttack() && _skill.isRanged() && !_skill.isAOE();
	}
});
