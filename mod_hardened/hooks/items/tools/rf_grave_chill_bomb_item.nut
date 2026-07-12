::Hardened.HooksMod.hook("scripts/items/tools/rf_grave_chill_bomb_item", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.Description = "A fragile pot filled with finely ground remains of creatures touched by unnatural frost. Anyone caught in the freezing cloud will be chilled. Can be thrown at short ranges.";
	}
});
