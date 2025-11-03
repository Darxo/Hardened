Hardened.Hooks.WorldScreenTopbarDayTimeModule_createDIV = WorldScreenTopbarDayTimeModule.prototype.createDIV;
WorldScreenTopbarDayTimeModule.prototype.createDIV = function (_parentDiv)
{
	Hardened.Hooks.WorldScreenTopbarDayTimeModule_createDIV.call(this, _parentDiv);
	this.mDayTimeText.bindTooltip({ contentType: 'msu-generic', modId: Reforged.ID, elementId: "Concept.DayTime" });
	this.mDayTimeImage.bindTooltip({ contentType: 'msu-generic', modId: Reforged.ID, elementId: "Concept.DayTime" });
}
