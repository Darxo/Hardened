::mods_hookExactClass("skills/special/double_grip", function(o) {
    local oldCreate = o.create;
    o.create = function()
    {
        oldCreate();
        this.m.IconMini = "";
    }
});
