// Overwrite to replace usage of getCost with getPredictedWorth
::DynamicSpawns.Class.Unit.getUpgradeWeight <- function()
{
	return this.getTotal() / ::Math.pow(this.getPredictedWorth(), 2);
}
