// This effect is only used for displaying the nested tooltip for the poison inflicted by spider_poison_coat_effect
// It is introduced so that its nested tooltip is showing the correct damage value that is defined in spider_poison_coat_effect
this.hd_spider_poison_effect_item <- ::inherit("scripts/skills/effects/spider_poison_effect", {
	m = {},

	function create()
	{
		this.spider_poison_effect.create();

		local effect = ::new("scripts/skills/effects/spider_poison_coat_effect");
		this.m.Damage = effect.m.HitpointDamagePerTurn;
	}
});
