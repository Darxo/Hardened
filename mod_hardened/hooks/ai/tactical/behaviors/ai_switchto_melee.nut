::Hardened.HooksMod.hook("scripts/ai/tactical/behaviors/ai_switchto_melee", function(q) {
	q.onExecute = @(__original) function( _entity )
	{
		local oldWeaponToEquip = this.m.WeaponToEquip;
		local ret = __original(_entity);

		if (ret && !this.m.IsNegatingDisarm)
		{
			// Feat: we now play a position-based inventory sound when NPCs equip weapons during combat
			oldWeaponToEquip.playInventorySoundWithPosition(::Const.Items.InventoryEventType.Equipped, _entity.getPos());
		}

		return ret;
	}
});
