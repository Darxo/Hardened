// We add these two nimble helmets an additional time to the pool of NamedHelmets so that they get picked more often
::Const.Items.NamedHelmets.push("helmets/named/norse_helmet");
::Const.Items.NamedHelmets.push("helmets/named/wolf_helmet");

// We remove the named longsword from appearing
::MSU.Array.removeByValue(::Const.Items.NamedWeapons, "weapons/named/named_rf_longsword");
::MSU.Array.removeByValue(::Const.Items.NamedMeleeWeapons, "weapons/named/named_rf_longsword");

// We remove the named battle axe from appearing
::MSU.Array.removeByValue(::Const.Items.NamedWeapons, "weapons/named/named_rf_battle_axe");
::MSU.Array.removeByValue(::Const.Items.NamedMeleeWeapons, "weapons/named/named_rf_battle_axe");

// We remove the named pole axe from appearing
::MSU.Array.removeByValue(::Const.Items.NamedWeapons, "weapons/named/named_rf_poleaxe");
::MSU.Array.removeByValue(::Const.Items.NamedMeleeWeapons, "weapons/named/named_rf_poleaxe");

{	// MSU Config
	::Const.Items.ItemTypeName[::MSU.Math.log2int(::Const.Items.ItemType.Ammo) + 1] = "Ammunition";
	::Const.Items.ItemTypeName[::MSU.Math.log2int(::Const.Items.ItemType.Accessory) + 1] = "Accessory";
	::Const.Items.ItemTypeName[::MSU.Math.log2int(::Const.Items.ItemType.Food) + 1] = "Food";
	::Const.Items.ItemTypeName[::MSU.Math.log2int(::Const.Items.ItemType.Usable) + 1] = "Consumable";
	::Const.Items.ItemTypeName[::MSU.Math.log2int(::Const.Items.ItemType.Quest) + 1] = "Quest Item";
}
