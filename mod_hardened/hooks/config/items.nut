// We add these two nimble helmets an additional time to the pool of NamedHelmets so that they get picked more often
::Const.Items.NamedHelmets.push("helmets/named/norse_helmet");
::Const.Items.NamedHelmets.push("helmets/named/wolf_helmet");

// We remove the named longsword from appearing
::MSU.Array.removeByValue(::Const.Items.NamedWeapons, "weapons/named/named_rf_longsword");
::MSU.Array.removeByValue(::Const.Items.NamedMeleeWeapons, "weapons/named/named_rf_longsword");
