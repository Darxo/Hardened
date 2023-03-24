::mods_hookExactClass("skills/perks/perk_rf_formidable_approach", function(o) {

    local oldRegisterEnemy = o.registerEnemy;
	o.registerEnemy = function( _actor )
	{
		local weapon = this.getContainer().getActor().getMainhandItem();
        if (weapon == null) return;
        if (weapon.isItemType(::Const.Items.ItemType.TwoHanded)) return;
        oldRegisterEnemy(_actor);
	}

    local oldOnAnySkillUsed = o.onAnySkillUsed;
    o.onAnySkillUsed = function( _skill, _targetEntity, _properties )
    {
		local weapon = this.getContainer().getActor().getMainhandItem();
        if (weapon == null) return;
        if (weapon.isItemType(::Const.Items.ItemType.TwoHanded)) return;
        oldOnAnySkillUsed(_skill, _targetEntity, _properties);
    }

    local oldOnBeingAttacked = o.onBeingAttacked;
    o.onBeingAttacked = function( _attacker, _skill, _properties )
    {
		local weapon = this.getContainer().getActor().getMainhandItem();
        if (weapon == null) return;
        if (weapon.isItemType(::Const.Items.ItemType.TwoHanded)) return;
        oldOnBeingAttacked(_attacker, _skill, _properties);
    }
/*
    local oldOnGetHitFactors = o.onGetHitFactors;
    o.onGetHitFactors = function( _skill, _targetTile, _tooltip )
    {
		local weapon = this.getContainer().getActor().getMainhandItem();
        if (weapon.isItemType(::Const.Items.ItemType.TwoHanded)) return;
        oldOnGetHitFactors(_skill, _targetTile, _tooltip);
    }

    local oldOnGetHitFactorsAsTarget = o.onGetHitFactorsAsTarget;
    o.onGetHitFactorsAsTarget = function( _skill, _targetTile, _tooltip )
    {
		local weapon = this.getContainer().getActor().getMainhandItem();
        if (weapon.isItemType(::Const.Items.ItemType.TwoHanded)) return;
        oldOnGetHitFactorsAsTarget(_skill, _targetTile, _tooltip);
    }
*/
});
