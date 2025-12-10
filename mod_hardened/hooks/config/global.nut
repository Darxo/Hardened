// The lowest two difficulties are now the same
::Const.Difficulty.EnemyMult[0] = ::Const.Difficulty.EnemyMult[1];	// Beginner now has the same resources for enemies as Veteran (both 100%)
::Const.Difficulty.EnemyMult[2] += 0.05;	// Expert now grants enemies 120% resources (up from 115%)

::Const.Difficulty.PaymentMult[0] = 1.2;	// Vanilla: 1.1
::Const.Difficulty.PaymentMult[2] = 0.8;	// Vanilla: 0.9

::Const.Difficulty.PlayerDamageReceivedMult <- [
	0.85,	// Player characters receive 15% less damage in beginner difficulty
	1.0,
	1.0,
];

// We change the orientation icons of several bandits to better match the appearance they have in Hardened
::Const.EntityIcon[::Const.EntityType.RF_BanditScoundrel] = "rf_bandit_thug_orientation";		// Reforged: bandit_thug_orientation
::Const.EntityIcon[::Const.EntityType.BanditThug] = "bandit_thug_orientation";					// Reforged: rf_bandit_thug_orientation
::Const.EntityIcon[::Const.EntityType.RF_BanditVandal] = "rf_bandit_pillager_orientation";		// Reforged: bandit_raider_orientation
::Const.EntityIcon[::Const.EntityType.RF_BanditPillager] = "hd_bandit_pillager_orientation";	// Reforged: rf_bandit_pillager_orientation
::Const.EntityIcon[::Const.EntityType.RF_BanditOutlaw] = "hd_bandit_outlaw_orientation";		// Reforged: rf_bandit_outlaw_orientation
::Const.EntityIcon[::Const.EntityType.RF_BanditMarauder] = "hd_bandit_marauder_orientation";	// Reforged: rf_bandit_marauder_orientation

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

::Const.Difficulty.generateCombatDifficultyTooltip <- function( _tooltip, _difficulty )
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

::Const.Difficulty.generateEconomicDifficultyTooltip <- function( _tooltip, _difficulty )
{
	if (::Const.Difficulty.BuyPriceMult[_difficulty] != 1.0)
	{
		_tooltip.push({		// Buy Price
			id = 10,
			type = "text",
			icon = "ui/icons/asset_money.png",
			text = "Buying Items costs " + ::MSU.Text.colorizeMultWithText(::Const.Difficulty.BuyPriceMult[_difficulty], {InvertColor = true}),
		});
	}

	if (::Const.Difficulty.SellPriceMult[_difficulty] != 1.0)
	{
		_tooltip.push({		// Sell Price
			id = 12,
			type = "text",
			icon = "ui/icons/asset_money.png",
			text = "Selling Items yields " + ::MSU.Text.colorizeMultWithText(::Const.Difficulty.SellPriceMult[_difficulty]),
		});
	}

	if (::Const.Difficulty.PaymentMult[_difficulty] != 1.0)
	{
		_tooltip.push({		// Contracts
			id = 13,
			type = "text",
			icon = "ui/icons/contract_scroll.png",
			text = "Contracts pay " + ::MSU.Text.colorizeMultWithText(::Const.Difficulty.PaymentMult[_difficulty]) + " Crowns",
		});
	}

	_tooltip.push({
		id = 20,
		type = "text",
		icon = "ui/icons/asset_supplies.png",
		text = "Maximum Tools: " + ::MSU.Text.colorPositive(::Const.Difficulty.MaxResources[_difficulty].ArmorParts),
	});

	_tooltip.push({
		id = 21,
		type = "text",
		icon = "ui/icons/asset_ammo.png",
		text = "Maximum Ammo: " + ::MSU.Text.colorPositive(::Const.Difficulty.MaxResources[_difficulty].Ammo),
	});

	_tooltip.push({
		id = 22,
		type = "text",
		icon = "ui/icons/asset_medicine.png",
		text = "Maximum Medicine: " + ::MSU.Text.colorPositive(::Const.Difficulty.MaxResources[_difficulty].Medicine),
	});
}

// Vanilla uses magic numbers in-code, so we just re-define those in a simple data-structure, until some mod globalizes them
local startingResources = [
	{
		Money = 2500,
		Ammo = 80,
		Tools = 40,
		Medicine = 30,
	},
	{
		Money = 2000,
		Ammo = 40,
		Tools = 20,
		Medicine = 20,
	},
	{
		Money = 1500,
		Ammo = 20,
		Tools = 10,
		Medicine = 10,
	},
];

::Const.Difficulty.generateStartingDifficultyTooltip <- function( _tooltip, _difficulty )
{
	_tooltip.push({		// Starting Money
		id = 10,
		type = "text",
		icon = "ui/icons/asset_money.png",
		text = "Starting Crowns: " + ::MSU.Text.colorizeValue(startingResources[_difficulty].Money),
	});

	_tooltip.push({		// Ammunition
		id = 11,
		type = "text",
		icon = "ui/icons/asset_ammo.png",
		text = "Starting Ammunition: " + ::MSU.Text.colorizeValue(startingResources[_difficulty].Ammo),
	});

	_tooltip.push({		// Tools and Supplies
		id = 12,
		type = "text",
		icon = "ui/icons/asset_supplies.png",
		text = "Starting Tools: " + ::MSU.Text.colorizeValue(startingResources[_difficulty].Tools),
	});

	_tooltip.push({		// Medicine
		id = 13,
		type = "text",
		icon = "ui/icons/asset_medicine.png",
		text = "Starting Medicine: " + ::MSU.Text.colorizeValue(startingResources[_difficulty].Medicine),
	});
}

