this.hd_trickster_sweep_zoc_skill <- this.inherit("scripts/skills/actives/hd_trickster_sweep_skill", {
	m = {
	},

	function create()
	{
		this.hd_trickster_sweep_skill.create();
		this.m.ID = "actives.hd_trickster_sweep_zoc";
		this.m.Name = "Antler Thrust";
		this.m.Description = "Thrust your massive antlers towards a single enemy.";
		this.m.IsIgnoredAsAOO = false;
		this.m.ActionPointCost = 999;
		this.m.FatigueCost = 999;
		this.m.HD_Cooldown = 0;
	}

	function getTooltip()
	{
		return this.skill.getDefaultTooltip();
	}

	function onUse( _user, _targetTile )
	{
		this.spawnAttackEffect(_targetTile, ::Const.Tactical.AttackEffectImpale);
		return this.attackEntity(_user, _targetTile.getEntity());
	}

	function onTargetSelected( _targetTile )
	{
	}

	function onAnySkillUsed( _skill, _targetEntity, _properties )
	{
	}
});
