::Hardened.HooksMod.hook("scripts/entity/world/settlements/situations/situation", function(q) {
	// Public
	// Array of information for all supported situation effects from the settlement_modifiers class
	q.m.SupportedSituationEffects <- [
		{ index = "PriceMult", type = "price", text = "Items" },
		{ index = "BuyPriceMult", type = "buy", text = "Items" },
		{ index = "SellPriceMult", type = "sell", text = "Items" },
		{ index = "FoodPriceMult", type = "price", text = "Food" },
		{ index = "MedicalPriceMult", type = "price", text = "Medicine" },
		{ index = "BuildingPriceMult", type = "price", text = "Building Supplies" },
		{ index = "IncensePriceMult", type = "price", text = "Incense" },
		{ index = "BeastPartsPriceMult", type = "price", text = "Beast Parts" },
		{ index = "RarityMult", type = "rarity", text = "Items" },
		{ index = "FoodRarityMult", type = "rarity", text = "Food" },
		{ index = "MedicalRarityMult", type = "rarity", text = "Medicine" },
		{ index = "MineralRarityMult", type = "rarity", text = "Minerals" },
		{ index = "BuildingRarityMult", type = "rarity", text = "Building Supplies" },
		{ index = "RecruitsMult", type = "recruits", text = "Recruits" },
	];

	q.getTooltip = @(__original) function()
	{
		local ret = __original();

		local oldLen = ret.len();

		local situationModifiers = this.getModifiers();
		foreach (supportedEffect in this.m.SupportedSituationEffects)
		{
			if (!(supportedEffect.index in situationModifiers)) continue;

			local multiplier = situationModifiers[supportedEffect.index];
			if (multiplier == 1.0) continue;

			this.addPriceTooltipEntries(supportedEffect, multiplier, ret);
		}

		this.addRecruitTooltipEntries(ret);

		if (ret.len() == oldLen)
		{
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/special.png",
				text = "This situation has no effect",
			});
		}

		return ret;
	}

// New Functions
	q.getModifiers <- function()
	{
		local situationModifiers = ::new("scripts/entity/world/settlement_modifiers");
		this.onUpdate(situationModifiers);
		return situationModifiers;
	}

	q.getNewBackgrounds <- function()
	{
		local newBackgrounds = [];
		this.onUpdateDraftList(newBackgrounds);
		return ::MSU.Array.uniques(newBackgrounds);
	}

	q.getRemovedBackgrounds <- function()
	{
		local allCharacterBackgrounds = clone ::Const.CharacterBackgrounds;
		this.onUpdateDraftList(allCharacterBackgrounds);

		local removedBackgrounds = [];
		foreach (background in ::Const.CharacterBackgrounds)
		{
			if (allCharacterBackgrounds.find(background) != null) continue;

			removedBackgrounds.push(background);
		}
		return removedBackgrounds;
	}

	q.addPriceTooltipEntries <- function( _situationEffect, _multiplier, _tooltip )
	{
		switch (_situationEffect.type)
		{
			case "price":
			{
				_tooltip.push({		// Buy Price
					id = 10,
					type = "text",
					icon = "ui/icons/asset_money.png",
					text = "Buying " + _situationEffect.text + " costs " + ::MSU.Text.colorizeMultWithText(_multiplier, {InvertColor = true}),
				});

				_tooltip.push({		// Sell Price
					id = 11,
					type = "text",
					icon = "ui/icons/asset_money.png",
					text = "Selling " + _situationEffect.text + " yields " + ::MSU.Text.colorizeMultWithText(_multiplier),
				});
				break;
			}
			case "buy":
			{
				_tooltip.push({		// Buy Price
					id = 10,
					type = "text",
					icon = "ui/icons/asset_money.png",
					text = "Buying " + _situationEffect.text + " costs " + ::MSU.Text.colorizeMultWithText(_multiplier, {InvertColor = true}),
				});
				break;
			}
			case "sell":
			{
				_tooltip.push({		// Sell Price
					id = 11,
					type = "text",
					icon = "ui/icons/asset_money.png",
					text = "Selling " + _situationEffect.text + " yields " + ::MSU.Text.colorizeMultWithText(_multiplier),
				});
				break;
			}
			case "rarity":
			{
				_tooltip.push({		// Rarity
					id = 12,
					type = "text",
					icon = "ui/icons/bag.png",
					text = ::MSU.Text.colorizeMultWithText(_multiplier) + " " + _situationEffect.text + " for sale",
				});
				break;
			}
			case "recruits":
			{
				_tooltip.push({		// Rarity
					id = 12,
					type = "text",
					icon = "ui/icons/asset_brothers.png",
					text = ::MSU.Text.colorizeMultWithText(_multiplier) + " " + _situationEffect.text,
				});
				break;
			}
		}
	}

	q.addRecruitTooltipEntries <- function( _tooltip )
	{
		foreach (newBackground in this.getNewBackgrounds())
		{
			local background = ::new("scripts/skills/backgrounds/" + newBackground);
			_tooltip.push({
				id = 15,
				type = "text",
				icon = "ui/icons/asset_brothers.png",
				text = background.getNameOnly() + "s are more common",
			});
		}

		foreach (removedBackground in this.getRemovedBackgrounds())
		{
			_tooltip.push({
				id = 16,
				type = "text",
				icon = "ui/icons/asset_brothers.png",
				text = removedBackground.getNameOnly() + "s are not available for hire",
			});
		}
	}
});
