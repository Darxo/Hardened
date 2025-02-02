::Hardened.HooksMod.hook("scripts/retinue/followers/bounty_hunter_follower", function(q) {
	q.m.ChampionChanceAdditional <- 5;	// In Vanilla this is 3

	q.create = @(__original) function()
	{
		__original();
		this.m.Cost = 2500;	// In Vanila this is 4000
		this.m.Effects[0] = "Enemies have " + ::MSU.Text.colorizeValue(this.m.ChampionChanceAdditional, {AddSign = true, AddPercent = true}) + " Chance to become a Champion";
		this.m.Effects.remove(1);	// Remove mention of the money for champion kills effect
	}

	q.onUpdate = @(__original) function()
	{
		// Revert Vanilla change, because we apply the change additively now instead of overwriting the value
		local oldChampionChanceAdditional = this.World.Assets.m.ChampionChanceAdditional;
		__original();
		::World.Assets.m.ChampionChanceAdditional = oldChampionChanceAdditional;

		::World.Assets.m.ChampionChanceAdditional += this.m.ChampionChanceAdditional;
	}

	q.onChampionKilled = @() function( _champion ) {}	// Overwrite because this follower no longer grants crowns on champion kill
});
