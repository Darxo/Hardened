this.hd_explode_skill <- this.inherit("scripts/skills/skill", {
	m = {
		// Public
		DamageRegularMin = 25,
		DamageRegularMax = 35,
		BodyPart = ::Const.BodyPart.Body,
	},

	function create()
	{
		this.m.ID = "actives.hd_explode";
		this.m.Name = "Explode";
		// this.m.Description = "";
		this.m.Icon = "skills/active_221.png";
		this.m.IconDisabled = "skills/active_221_sw.png";
		this.m.Overlay = "active_221";
		this.m.Type = ::Const.SkillType.Active;
		this.m.Order = ::Const.SkillOrder.OffensiveTargeted;
		this.m.IsSerialized = false;
		this.m.IsActive = true;
		this.m.IsTargeted = true;
		this.m.IsIgnoredAsAOO = true;
		this.m.IsDoingForwardMove = false;

		this.m.IsTargetingActor = true;
		this.m.IsVisibleTileNeeded = false;
		this.m.InjuriesOnBody = ::Const.Injury.BurningBody;
		this.m.InjuriesOnHead = ::Const.Injury.BurningHead;
		this.m.DirectDamageMult = 0.3;
		this.m.ActionPointCost = 99;
		this.m.FatigueCost = 0;
		this.m.MinRange = 1;
		this.m.MaxRange = 1;
		this.m.MaxRangeBonus = 0;
		this.m.MaxLevelDifference = 1;

		// We have to manually assign the burning damage type, because MSU does not correctly generate damage types for Non-Attack skills
		this.m.DamageType = ::MSU.Class.DamageType();
		this.m.DamageType.add(::Const.Damage.DamageType.Burning);
	}

	function getTooltip()
	{
		return this.skill.getDefaultTooltip();
	}

	function onUse( _user, _targetTile )
	{
		local target = _targetTile.getEntity();

		local hitInfo = this.HD_generateHitInfo(target, this.m.BodyPart, true);
		target.onDamageReceived(this.getContainer().getActor(), this, hitInfo);

		return true;
	}

	function onAnySkillUsed( _skill, _targetEntity, _properties )
	{
		if (_skill == this)
		{
			_properties.DamageRegularMin = this.m.DamageRegularMin;
			_properties.DamageRegularMax = this.m.DamageRegularMax;
		}
	}
});
