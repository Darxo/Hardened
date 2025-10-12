this.hd_onslaught_line_breaker_skill <- this.inherit("scripts/skills/actives/line_breaker", {
	m = {
		IsSpent = false,
	},

	function create()
	{
		this.line_breaker.create();
		this.m.ID = "actives.hd_onslaught_line_breaker";
		this.m.Name = "Line Breaker (Onslaught)";
		this.m.Description = "Push through the ranks of your enemies by knocking back a target and taking its place, all in one action.";
		this.m.Icon = "skills/rf_line_breaker_skill.png";
		this.m.IconDisabled = "skills/rf_line_breaker_skill_sw.png";
		this.m.Overlay = "rf_line_breaker_skill";
		this.m.SoundOnUse = [
			"sounds/combat/indomitable_01.wav",
			"sounds/combat/indomitable_02.wav"
		];
		this.m.FatigueCost = 15;	// Vanilla: 30
		this.m.AIBehaviorID = ::Const.AI.Behavior.ID.LineBreaker;
		this.m.IsRemovedAfterBattle = true;
	}

	function isHidden()
	{
		return this.line_breaker.isHidden() || this.m.IsSpent;
	}

	function isUsable()
	{
		return this.line_breaker.isUsable() && !this.getContainer().getActor().getCurrentProperties().IsRooted;
	}

	function onUse( _user, _targetTile )
	{
		local ret = this.line_breaker.onUse(_user, _targetTile );

		this.m.IsSpent = true;
	}

	function onTurnEnd()
	{
		if (this.m.IsSpent) this.removeSelf();
	}

	function onRefresh()
	{
		this.m.IsSpent = false;
	}
});

