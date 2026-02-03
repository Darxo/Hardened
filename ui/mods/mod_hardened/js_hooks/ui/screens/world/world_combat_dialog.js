var terrainNameTable = {
	Needles: "Needle Forest",
	"Forest Snow": "Snow Forest",
}

var formatTerrainName = function(image) {
	// Remove everything up to and including "engage_"
	var name = image.replace(/^.*engage_/, "");

	// Remove ".png" at the end
	name = name.replace(/\.png$/, "");

	// Detect and remove "_night"
	var isNight = false;
	if (name.indexOf("_night") !== -1)
	{
		isNight = true;
		name = name.replace(/_night$/, "");
	}

	// Replace underscores with spaces
	name = name.replace(/_/g, " ");

	// Capitalize every word
	name = name.replace(/\b\w/g, function(c)
	{
		return c.toUpperCase();
	});

	name = terrainNameTable[name] || name;

	if (isNight)
	{
		name += " (Night)";
	}
	else
	{
		name += " (Day)";
	}

	return name;
}

Hardened.Hooks.WorldCombatDialog_loadFromData = WorldCombatDialog.prototype.loadFromData;
WorldCombatDialog.prototype.loadFromData = function ( _data )
{
	var oldCreateDialog = $.fn.createDialog;
	$.fn.createDialog = function(_title, _subTitle, _headerImagePath, _withTabs, _classes)
	{
		_subTitle = formatTerrainName(_data.Image);
		return oldCreateDialog.apply(this, arguments);
	}

	Hardened.Hooks.WorldCombatDialog_loadFromData.call(this, _data);

	$.fn.createDialog = oldCreateDialog;

	// Feat: we improve the vanilla entity display by
	//	- wrapping it inside a scroll container allowing much more entities to be displayed at once
	//	- cut off long entity names with "..."
	var entities = _data.Entities;
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
