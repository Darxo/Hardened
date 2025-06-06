::Hardened.HooksMod.hook("scripts/skills/actives/puncture", function(q) {
	q.m.RequiredSurroundedCount <- 2;	// 0 is either caused by none, or one adjacent character. 1 SurroundedCount requires two characters

	q.create = @(__original) function()
	{
		__original();
		this.m.Description = ::MSU.String.replace(this.m.Description, ", nor inflict additional damage with double grip", "");
	}

	q.getTooltip = @(__original) function()
	{
		local ret = __original();

		if (this.m.RequiredSurroundedCount != 0)
		{
			ret.push({
				id = 8,
				type = "text",
				icon = "ui/icons/warning.png",
				text = ::Reforged.Mod.Tooltips.parseString("Target must be [surrounded|Concept.Surrounding] by atleast " + ::MSU.Text.colorPositive(this.m.RequiredSurroundedCount) + " characters"),
			});
		}

		return ret;
	}

	q.onVerifyTarget <- function( _originTile, _targetTile )
	{
		local ret = this.skill.onVerifyTarget(_originTile, _targetTile);
		if (ret == false) return false;

		return (_targetTile.getEntity().getSurroundedCount() >= this.m.RequiredSurroundedCount - 1);		// getSurroundedCount returns 1 less
	}
});
