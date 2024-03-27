::Const.Difficulty.generateTooltipInfo <- function( _tooltip, _difficulty )
{
	if (::Const.Difficulty.XPMult[_difficulty] != 1.0)
	{
		_tooltip.push({
			id = 3,
			type = "text",
			icon = "ui/icons/xp_received.png",
			text = "Your characters gain " + ::MSU.Text.colorizeMultWithText(::Const.Difficulty.XPMult[_difficulty]) + " Global Experience",
		});
	}

	// Hard coded entry for Easy Difficulty, describing a very hard-coded effect by vanilla
	if (_difficulty == ::Const.Difficulty.Easy)
	{
		_tooltip.push({
			id = 4,
			type = "text",
			icon = "ui/icons/melee_skill.png",
			text = "Your characters have " + ::MSU.Text.colorPositive("+5%") + " chance to hit (hidden)",
		});

		_tooltip.push({
			id = 5,
			type = "text",
			icon = "ui/icons/melee_defense.png",
			text = "Attacks against your characters have " + ::MSU.Text.colorNegative("-5%") + " chance to hit (hidden)",
		});
	}

	if (::Const.Difficulty.RetreatDefenseBonus[_difficulty] != 0)
	{
		_tooltip.push({
			id = 7,
			type = "text",
			icon = "ui/icons/melee_defense.png",
			text = ::MSU.Text.colorizeValue(::Const.Difficulty.RetreatDefenseBonus[_difficulty]) + " Melee Defense during Auto-Retreat",
		});
	}

	if (::Const.Difficulty.EnemyMult[_difficulty] != 1.0)
	{
		_tooltip.push({
			id = 8,
			type = "text",
			icon = "ui/icons/camp.png",
			text = "Enemy Parties have " + ::MSU.Text.colorizeMultWithText(::Const.Difficulty.EnemyMult[_difficulty], {InvertColor = true}) + " Resources",
		});
	}
}
