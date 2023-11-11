::Hardened.HooksMod.hook("scripts/skills/special/rf_inspiring_presence_buff_effect", function(q) {
	q.onAdded = @() function()
	{
		this.removeSelf();
	}
});
