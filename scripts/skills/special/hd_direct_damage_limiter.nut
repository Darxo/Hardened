// Caps the direct damage of an attacker to this.m.Max
this.hd_direct_damage_limiter <- ::inherit("scripts/skills/skill", {
	m = {
		Max = 0.9999
	},
	function create()
	{
		this.m.ID = "special.hd_direct_damage_limiter";
		this.m.Name = "";
		this.m.Description = "";
		this.m.Icon = "";
		this.m.Type = ::Const.SkillType.Special;
		this.m.Order = ::Const.SkillOrder.VeryLast + 10;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = true;
		this.m.IsSerialized = false;
	}

	function onBeforeTargetHit( _skill, _targetEntity, _hitInfo )
	{
		if (_skill.getDirectDamage() < 1.0)
		{
			_hitInfo.DamageDirect = ::Math.minf(this.m.Max, _hitInfo.DamageDirect);
		}
	}
});
