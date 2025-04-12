// Adjustments
// 1. Serialize LastHelpTime
//	- Loading the game no longer instantly spawns a direction-helping dialog

::Hardened.HooksMod.hook("scripts/contracts/contracts/barbarian_king_contract", function(q) {
	q.onSerialize = @(__original) function( _out )
	{
		this.m.Flags.set("HD_LastHelpTime", this.m.LastHelpTime);

		__original(_out);
	}

	q.onDeserialize = @(__original) function( _in )
	{
		__original(_in);

		if (this.m.Flags.has("HD_LastHelpTime"))
		{
			this.m.LastHelpTime = this.m.Flags.get("HD_LastHelpTime");
		}
	}
});
