::Hardened.HooksMod.hook("scripts/ambitions/ambitions/trade_ambition", function(q) {
	q.m.TransactionTarget <- 25;	// This many tradegoods need to be bought or sold in order to fullfil this ambition

	// Overwrite, because we change the vanilla condition to count both, selling and buying, instead of just the bigger one of them
	q.onCheckSuccess = @() function()
	{
		return this.getTransactionsSinceStart() >= this.m.TransactionTarget;
	}

	// Overwrite, because we change the vanilla condition to count both, selling and buying, instead of just the bigger one of them
	q.getUIText = @() function()
	{
		return this.m.UIText + " (" + this.getTransactionsSinceStart() + "/" + this.m.TransactionTarget + ")";
	}

// New Functions
	// Return the combined amount of trade goods bought or sold by the player since they started this ambition
	q.getTransactionsSinceStart <- function()
	{
		local transactionsBefore = this.m.AmountToBuy + this.m.AmountToSell - 50;	// Vanilla adds 25 to both values so we need to subtract those again for this calculation
		local transactionsNow = ::World.Statistics.getFlags().getAsInt("TradeGoodsBought") + ::World.Statistics.getFlags().getAsInt("TradeGoodsSold");

		return transactionsNow - transactionsBefore;
	}
});
