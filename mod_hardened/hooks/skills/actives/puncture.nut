::Hardened.HooksMod.hook("scripts/skills/actives/puncture", function(q) {
	// Public
	q.m.RequiredSurroundedCount <- 2;	// 0 is either caused by none, or one adjacent character. 1 SurroundedCount requires two characters

	// We add this multiplier to balance out the extra potential damage gained from the double grip effect
	q.m.DamageTotalMult <- 0.85;	// This skill deals this much more/less damage passively

	q.create = @(__original) function()
	{
		__original();
		this.m.Description = ::MSU.String.replace(this.m.Description, ", nor inflict additional damage with double grip", "");
	}

	q.getTooltip = @(__original) function()
	{
		local ret = __original();

		if (this.m.DamageTotalMult != 1.0)
		{
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/damage_dealt.png",
				text = ::Reforged.Mod.Tooltips.parseString("Deal " + ::MSU.Text.colorizeMultWithText(this.m.DamageTotalMult) + " Damage"),
			});
		}

		if (this.m.RequiredSurroundedCount != 0)
		{
			ret.push({
				id = 20,
				type = "text",
				icon = "ui/icons/warning.png",
				text = ::Reforged.Mod.Tooltips.parseString("Target must be [surrounded|Concept.Surrounding] by atleast " + ::MSU.Text.colorPositive(this.m.RequiredSurroundedCount) + " characters"),
			});
		}

		return ret;
	}

	q.onAnySkillUsed = @(__original) function( _skill, _targetEntity, _properties )
	{
		__original(_skill, _targetEntity, _properties);
		if (_skill == this)
		{
			_properties.DamageTotalMult *= this.m.DamageTotalMult;
		}
	}

	q.onVerifyTarget <- function( _originTile, _targetTile )
	{
		local ret = this.skill.onVerifyTarget(_originTile, _targetTile);
		if (ret == false) return false;

		return (_targetTile.getEntity().getSurroundedCount() >= this.m.RequiredSurroundedCount - 1);		// getSurroundedCount returns 1 less
	}
});
