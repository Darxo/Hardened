// Adjustments
// 1. Player Party moves 20% slower while escorting the Envoy
// 2. The Contract pays out 50% more

::Hardened.HooksMod.hook("scripts/contracts/contracts/escort_envoy_contract", function(q) {
	// Public
	q.m.MovementSpeedMult <- 0.8;	// While the Envoy is in your party, your movement speed is multiplied with this value
	q.m.WaitTimeMin <- 70;		// Vanilla: 20 BB Seconds
	q.m.WaitTimeMax <- 70;		// Vanilla: 60 BB Seconds

	// Private
	q.m.PreviousHoursText <- "";		// Temporary variable so that the contract UI is only updated when changes happen

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
			else if (state.ID == "Waiting")
			{
				local oldStart = "start" in state ? state.start : function() {};
				state.start <- function()
				{
					oldStart();

					// We set the waiting period once again, but a specialized function so it becomes moddable
					this.Contract.m.Flags.set("WaitUntil", ::Time.getVirtualTimeF() + this.Contract.calculateWaitingTime());

					this.Contract.updateWaitingState();
					this.Contract.m.Destination.getSprite("selection").Visible = false;
				}

				local oldUpdate = "update" in state ? state.update : function() {};
				state.update <- function()
				{
					// This has to happen first, because Vanilla might switch states during the update call, which then sets "selection" visibility
					this.Contract.updateWaitingState();
					oldUpdate();
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

// New Functions
	q.updateWaitingState <- function()
	{
		local hoursText = this.getWaitUntilHours();

		if (hoursText == "")
		{
			this.m.BulletpointsObjectives = [
				"Return to " + this.m.Destination.getName() + " to meet up with %envoy% %envoy_title%",
			];
			this.m.Destination.getSprite("selection").Visible = true;
		}
		else
		{
			this.m.BulletpointsObjectives = [
				"Wait around " + this.m.Destination.getName() + " for " + hoursText + " until %envoy% %envoy_title% is done",
			];
		}

		if (hoursText != this.m.PreviousHoursText)
		{
			this.m.PreviousHoursText = hoursText;
			::World.Contracts.updateActiveContract();	// So that our bullet point change gets updated
		}
	}

	q.getWaitUntilHours <- function()
	{
		local bbSeconds = ::Math.max(0, this.m.Flags.get("WaitUntil") - ::Time.getVirtualTimeF());
		if (bbSeconds == 0) return "";
		return ::Reforged.Text.getDayHourString(bbSeconds);
	}

	q.calculateWaitingTime <- function()
	{
		return ::Math.rand(this.m.WaitTimeMin, this.m.WaitTimeMax) * 1.0;
	}
});
