::Hardened.HooksMod.hook("scripts/entity/tactical/enemies/rf_hollenhund", function(q) {
	q.onInit = @(__original) { function onInit()
	{
		__original();

		// We reset the saturation of the base layers to make this unit overall more visible
		local head = this.getSprite("head");
		head.Saturation = 1.0;

		local body = this.getSprite("body");
		body.Saturation = 1.0;
	}}.onInit;
});
