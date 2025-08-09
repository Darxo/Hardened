::Hardened.HooksMod.hook("scripts/items/helmets/named/named_helmet", function(q) {
	q.m.HD_RandomizedWeightThreshold <- -3;	// Vanilla: -4; This is the lowest that a randomized Weight for a named helmet can roll

	q.randomizeValues = @(__original) function()
	{
		local rolledWeight = this.HD_randomizeWeight(this.getWeight());
		__original();
		this.setWeight(rolledWeight);	// We overwrite, whatever vanilla has calculated here, with our own
	}

// New Functions
	q.HD_randomizeWeight <- function( _currentWeight )
	{
		local randomizedWeight = _currentWeight - ::Math.rand(1, 4);
		return ::Math.max(this.m.HD_RandomizedWeightThreshold, randomizedWeight);
	}
});
