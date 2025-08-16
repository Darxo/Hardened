::Hardened.wipeClass("scripts/skills/perks/perk_rf_iron_sights", [
	"create",
]);

::Hardened.HooksMod.hook("scripts/skills/perks/perk_rf_iron_sights", function(q) {
	q.m.InitiativeNeededForHeadHitChance <- 3.0;	// This perk grants 1% chance to hit the head per this many Initiative points

	q.onAfterUpdate = @(__original) function( _properties )
	{
		__original(_properties);

		_properties.HitChance[::Const.BodyPart.Head] += this.getHeadHitChanceModifier();
	}

	// New Functions
	q.isEnabled <- function()
	{
		if (this.getContainer().getActor().isDisarmed()) return false;

		local weapon = this.getContainer().getActor().getMainhandItem();
		return weapon != null && (weapon.isWeaponType(::Const.Items.WeaponType.Crossbow) || weapon.isWeaponType(::Const.Items.WeaponType.Firearm));
	}

	q.getHeadHitChanceModifier <- function()
	{
		if (!this.isEnabled()) return 0;

		local ret = this.getContainer().getActor().getInitiative() / this.m.InitiativeNeededForHeadHitChance;

		return ::Math.max(0, ::Math.floor(ret));	// This value can never be negative and it always rounds down
	}
});
