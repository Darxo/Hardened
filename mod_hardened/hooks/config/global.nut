// The lowest two difficulties are now the same
::Const.Difficulty.EnemyMult[0] = ::Const.Difficulty.EnemyMult[1];	// Beginner now has the same resources for enemies as Veteran (both 100%)
::Const.Difficulty.EnemyMult[2] += 0.05;	// Expert now grants enemies 120% resources (up from 115%)

::Const.Difficulty.PlayerDamageReceivedMult <- [
	0.85,	// Player characters receive 15% less damage in beginner difficulty
	1.0,
	1.0,
]

::Const.Difficulty.getPlayerDamageReceivedMult <- function()
{
	if (!::MSU.Utils.hasState("tactical_state")) return 1.0;
	if (::Tactical.State.isScenarioMode()) return 1.0;

	local difficulty = ::World.Assets.getCombatDifficulty();
	if (difficulty >= ::Const.Difficulty.PlayerDamageReceivedMult.len())
	{
		// Will happen when new difficulties are introduced by other mods
		return ::Const.Difficulty.PlayerDamageReceivedMult[::Const.Difficulty.PlayerDamageReceivedMult.len()];
	}
	else
	{
		return ::Const.Difficulty.PlayerDamageReceivedMult[difficulty];
	}
}

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

	if (::Const.Difficulty.PlayerDamageReceivedMult[_difficulty] != 1.0)
	{
		_tooltip.push({
			id = 6,
			type = "text",
			icon = "ui/icons/regular_damage.png",
			text = "Your characters take " + ::MSU.Text.colorizeMultWithText(::Const.Difficulty.PlayerDamageReceivedMult[_difficulty], {InvertColor = true}) + " damage",
		});
	}

	if (::Const.Difficulty.RetreatDefenseBonus[_difficulty] != 0)
	{
		_tooltip.push({
			id = 7,
			type = "text",
			icon = "ui/icons/melee_defense.png",
			text = ::MSU.Text.colorizeValue(::Const.Difficulty.RetreatDefenseBonus[_difficulty], {AddSign = true}) + " Melee Defense during Auto-Retreat",
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
