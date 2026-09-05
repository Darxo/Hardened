::Hardened.wipeClass("scripts/skills/perks/perk_rf_deep_impact", [
	"create",
]);

// Our Implementation is not perfect. It can't deal with any delayed skills like Ranged Attacks or Lunge/Charge like abilities
// However we can deal with proxy-activations where one skill activates another one within it, if those happen instantly with no delay of course
::Hardened.HooksMod.hook("scripts/skills/perks/perk_rf_deep_impact", function(q) {		// Now called "Breakthrough"
	q.m.HD_RangedSkillPerKnockBackDistance <- 40.0;

	q.onAdded <- function()
	{
		local weapon = this.getContainer().getActor().getMainhandItem();
		if (weapon != null) this.onEquip(weapon);
	}

	q.onEquip <- function( _item )
	{
		if (_item.isItemType(::Const.Items.ItemType.Weapon) && _item.isWeaponType(::Const.Items.WeaponType.Hammer))
		{
			_item.addSkill(::new("scripts/skills/actives/rf_pummel_skill"));
		}
	}

	q.onUpdate <- function( _properties )
	{
		foreach (skill in this.getContainer().m.Skills)
		{
			if (skill.getID() == "actives.shatter")
			{
				skill.m.KnockbackChance = this.HD_getKnockBackChance();
				skill.m.StaggerChance = this.HD_getStaggerChance();
				skill.m.HD_KnockBackDistance += this.HD_getAdditionalKnockBackDistance();
			}
		}
	}

// MSU Events
	q.onQueryTooltip <- function( _skill, _tooltip )
	{
		local additionalKnockBacktiles = this.HD_getAdditionalKnockBackDistance();
		if (additionalKnockBacktiles > 0 && _skill.getID() == "actives.shatter")
		{
			_tooltip.push({
				id = 100,
				type = "text",
				icon = this.getIconColored(),
				text = "Knocks back enemies " + ::MSU.Text.colorPositive(additionalKnockBacktiles) + " additional tiles",
			});
		}
	}

// New Functions
	q.HD_getKnockBackChance <- function()
	{
		return ::Math.clamp(this.getContainer().getActor().getCurrentProperties().getRangedSkill(), 0, 100);
	}

	q.HD_getStaggerChance <- function()
	{
		return ::Math.clamp(this.getContainer().getActor().getInitiative(), 0, 100);
	}

	q.HD_getAdditionalKnockBackDistance <- function()
	{
		return ::Math.floor(this.getContainer().getActor().getCurrentProperties().getRangedSkill() / this.m.HD_RangedSkillPerKnockBackDistance);
	}
});
