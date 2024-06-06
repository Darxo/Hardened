::Hardened.HooksMod.hook("scripts/entity/world/settlement", function(q) {
	q.m.LastVisited <- -1;	// the day that the player last entered this location

	q.onEnter = @(__original) function()
	{
		this.m.LastVisited = ::World.getTime().Days;
		return __original();
	}

	q.onSerialize = @(__original) function( _out )
	{
		this.getFlags().set("hd_LastVisited", this.m.LastVisited);
		__original(_out);
	}

	q.onDeserialize = @(__original) function( _in )
	{
		__original(_in);
		if (this.getFlags().has("hd_LastVisited")) this.m.LastVisited = this.getFlags().get("hd_LastVisited");
	}

	q.getTooltip = @(__original) function()
	{
		local ret = __original();
		ret.push({
			id = 12,
			type = "hint",
			icon = "ui/icons/action_points.png",
			text = this.getLastVisitedString()
		});
		return ret;
	}

// New Functions
	q.getLastVisitedString <- function()
	{
		local ret = "Last visited: ";
		if (this.isVisited() == false) return ret + "never";
		if (this.getLastVisited() == -1) return ret + "unknown";	// This should only ever happen when loading old save games

		local dayDifference = ::World.getTime().Days - this.getLastVisited();
		if (dayDifference == 0) return ret + "today";
		if (dayDifference == 1) return ret + "1 day ago";
		return ret + dayDifference + " days ago";
	}

	q.getLastVisited <- function()
	{
		return this.m.LastVisited;
	}
});
