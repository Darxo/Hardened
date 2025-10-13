Hardened.Hooks.WorldCombatDialog_loadFromData = WorldCombatDialog.prototype.loadFromData;
WorldCombatDialog.prototype.loadFromData = function ( _data )
{
	Hardened.Hooks.WorldCombatDialog_loadFromData.call(this, _data);

	var entities = _data.Entities;

	// Feat: we improve the vanilla entity display by
	//	- wrapping it inside a scroll container allowing much more entities to be displayed at once
	//	- cut off long entity names with "..."

	if(entities.length >= 0)
	{
		var rightColumn = this.mContentContainer.find('.right-column');
		if (rightColumn.length === 0) return;

		var table = rightColumn.find('.entity-table');
		if (table.length === 0) return;
		table.remove();		// We delete the old entity-table as we wanna add a new one that we control

		var myTable = $('<table class="entity-table">');	//  custom-entity-table
		rightColumn.append(myTable);

		// We now add a scrollbar
		myTable.createList(0.5);
		var scrollContainer = myTable.findListScrollContainer();

		for (var i = 0; i < entities.length; i++)
		{
			var entity = entities[i];
			var row = $('<div class="entity-row">');
			var left = $('<div class="entity-left">');
			left.append('<img src="' + Path.GFX + 'ui/orientation/' + entity.Icon + '.png" />');
			row.append(left);

			var right = $('<div class="entity-right">');
			right.append('<span class="entity-name text-font-medium font-color-description">' + entity.Name + '</span>');
			row.append(right);

			scrollContainer.append(row);
		}
	}
};
