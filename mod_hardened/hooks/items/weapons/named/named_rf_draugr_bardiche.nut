// We design this weapon from a Bardiche-Like into a Greataxe-Like
::Hardened.HooksMod.hook("scripts/items/weapons/named/named_rf_draugr_bardiche", function(q) {
	q.create = @(__original) function()
	{
		__original();

		this.m.Description = ::MSU.String.replace(this.m.Description, "bardiche", "greataxe");
		this.m.BaseItemScript = "scripts/items/weapons/rf_draugr/rf_draugr_greataxe";
		this.randomizeValues();
	}
});
