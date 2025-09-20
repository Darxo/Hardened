::Hardened.HooksMod.hook("scripts/ai/tactical/agent", function(q) {
	q.m.HD_RangedAtDayVisionThreshold <- 2;		// Vanilla: 4

	// Overwrite, because we lower the hard-coded vanilla cut-off for when ranged troops go into yolo-melee mode
	q.setRangedAtDayOnly = @() function()
	{
		if (this.m.Actor.getCurrentProperties().getVision() <= this.m.HD_RangedAtDayVisionThreshold)
		{
			this.m.Properties.BehaviorMult[::Const.AI.Behavior.ID.Defend] = 1.0;
			this.m.Properties.BehaviorMult[::Const.AI.Behavior.ID.EngageMelee] = 0.5;
			this.m.Properties.BehaviorMult[::Const.AI.Behavior.ID.EngageRanged] = 0.0;
			this.m.Properties.BehaviorMult[::Const.AI.Behavior.ID.SwitchToRanged] = 0.0;

			if (::Time.getRound() <= 2)
			{
				this.m.Properties.PreferWait = true;
			}
			else
			{
				this.m.Properties.PreferWait = false;
			}
		}
		else
		{
			this.m.Properties.BehaviorMult[::Const.AI.Behavior.ID.Defend] = 1.0;
			this.m.Properties.BehaviorMult[::Const.AI.Behavior.ID.EngageMelee] = 0.0;
			this.m.Properties.BehaviorMult[::Const.AI.Behavior.ID.EngageRanged] = 1.0;
			this.m.Properties.BehaviorMult[::Const.AI.Behavior.ID.SwitchToRanged] = 1.0;
			this.m.Properties.PreferWait = false;
		}
	}
});
