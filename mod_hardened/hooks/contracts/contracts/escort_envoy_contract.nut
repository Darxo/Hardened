// Adjustments
// 1. Player Party moves 20% slower while escorting the Envoy
// 2. The Contract pays out 50% more

::Hardened.HooksMod.hook("scripts/contracts/contracts/escort_envoy_contract", function(q) {
	// Public
	q.m.MovementSpeedMult <- 0.8;	// While the Envoy is in your party, your movement speed is multiplied with this value

	q.create = @(__original) function()
	{
		__original();

		this.m.PaymentMult *= 1.5;	// This contract now grants 50% more crowns as a reward
	}

	q.createStates = @(__original) function()
	{
		__original();

		foreach (state in this.m.States)
		{
			if (state.ID == "Running")
			{
				local oldStart = "start" in state ? state.start : function() {};
				state.start <- function()
				{
					oldStart();

					// We use MSU's movementspeed system way to temporary implement our contract specific movement speed mult
					local speedMult = this.Contract.m.MovementSpeedMult;
					::World.State.getPlayer().m.MovementSpeedMultFunctions.HD_escort_envoy_contract <- function()
					{
						return speedMult;
					}
				}

				local oldEnd = "end" in state ? state.end : function() {};
				state.end <- function()
				{
					::World.State.getPlayer().m.MovementSpeedMultFunctions.rawdelete("HD_escort_envoy_contract");
					oldEnd();
				}
			}
			else if (state.ID == "Return")
			{
				local oldStart = "start" in state ? state.start : function() {};
				state.start <- function()
				{
					oldStart();

					// We use MSU's movementspeed system way to temporary implement our contract specific movement speed mult
					local speedMult = this.Contract.m.MovementSpeedMult;
					::World.State.getPlayer().m.MovementSpeedMultFunctions.HD_escort_envoy_contract <- function()
					{
						return speedMult;
					}
				}

				local oldEnd = "end" in state ? state.end : function() {};
				state.end <- function()
				{
					::World.State.getPlayer().m.MovementSpeedMultFunctions.rawdelete("HD_escort_envoy_contract");
					oldEnd();
				}
			}
		}
	}
});
