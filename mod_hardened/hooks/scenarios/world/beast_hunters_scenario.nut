::Hardened.HooksMod.hook("scripts/scenarios/world/beast_hunters_scenario", function(q) {
	q.create = @(__original) { function create()
	{
		__original();

		// This effect is implemented inside isDesirable of food_item
		this.m.Description = ::MSU.String.replace(this.m.Description, "[color=#bcad8c]Expert Skinners:[/color] Each beast you slay has a 50% chance to drop an additional trophy.\n[color=#bcad8c]Prejudice:[/color] Most people don\'t trust your kind, so you get 10% worse prices.", "[color=#bcad8c]Not to picky:[/color] Your men will eat any food.");
	}}.create;

	q.onInit = @(__original) { function onInit()
	{
		__original();

		// Revert most vanilla effects
		this.World.Assets.m.BuyPriceMult = 1.0;
		this.World.Assets.m.SellPriceMult = 1.0;
		this.World.Assets.m.ExtraLootChance = 0;
	}}.onInit;

	q.onSpawnAssets = @(__original) { function onSpawnAssets()
	{
		__original();

		::World.Assets.getStash().add(this.new("scripts/items/supplies/strange_meat_item"));
	}}.onSpawnAssets;
});
